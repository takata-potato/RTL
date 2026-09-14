#!/usr/bin/env python3
"""IEEE 1800-2017 lab runner. Python 3.9+, no third-party dependencies."""
import argparse
from collections import Counter
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import signal
import subprocess
import sys
import time

COURSE = Path(__file__).resolve().parent
ROOT = COURSE.parent
CATALOG = json.loads((COURSE / 'catalog.json').read_text(encoding='utf-8'))


def lab_for(name):
    found = [x for x in CATALOG if x['id']==name or x['id'].split('_')[0]==name.zfill(2)]
    if len(found)!=1:
        raise ValueError(f'Unknown lab: {name}. Use: make learn-list')
    return found[0]


def execute(argv, cwd, timeout, env=None):
    """Terminate the entire simulator process group on a wall-clock timeout."""
    proc = subprocess.Popen([str(x) for x in argv], cwd=cwd, env=env,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            text=True, encoding='utf-8', errors='replace',
                            start_new_session=(os.name=='posix'))
    try:
        output,_ = proc.communicate(timeout=timeout)
        return proc.returncode,output,False
    except subprocess.TimeoutExpired:
        if os.name=='posix':
            os.killpg(proc.pid,signal.SIGTERM)
        else:
            proc.terminate()
        try:
            output,_=proc.communicate(timeout=3)
        except subprocess.TimeoutExpired:
            if os.name=='posix': os.killpg(proc.pid,signal.SIGKILL)
            else: proc.kill()
            output,_=proc.communicate()
        return 124,output+'\nWALL_CLOCK_TIMEOUT\n',True


def tool(name, variable):
    chosen=os.environ.get(variable,name)
    resolved=shutil.which(chosen)
    if resolved: return resolved
    raise FileNotFoundError(f'{name} not found; configure {variable} or env.local.sh')


def header_dir(filename, variable):
    candidates=[]
    if os.environ.get(variable): candidates.append(Path(os.environ[variable]))
    if os.environ.get('XCELIUM_HOME'):
        home=Path(os.environ['XCELIUM_HOME'])
        candidates.extend(home / x for x in ('tools/include','tools/inca/include','tools.lnx86/include'))
    xrun=shutil.which(os.environ.get('XRUN','xrun'))
    if xrun:
        parent=Path(xrun).resolve().parent
        candidates.extend((parent.parent/'include',parent.parent/'inca'/'include'))
    for path in candidates:
        if (path / filename).is_file(): return path
    raise FileNotFoundError(f'{filename} not found; set {variable} to its directory')


def copy_inputs(folder, output):
    for path in folder.iterdir():
        if path.suffix in ('.hex','.sdf','.txt','.dat'):
            shutil.copyfile(path,output/path.name)


def source_digest(folder):
    digest=hashlib.sha256()
    for path in sorted(folder.iterdir(), key=lambda p: p.name):
        if path.is_file():
            digest.update(path.name.encode()); digest.update(path.read_bytes())
    digest.update((COURSE/'common'/'lab.svh').read_bytes())
    return digest.hexdigest()


def run_one(item,args):
    folder=COURSE/'labs'/item['id']
    kind=item['kind']
    result=dict(id=item['id'],engine=args.engine,kind=kind,status='NOT_RUN',
                source_sha256=source_digest(folder),reason='')
    if kind=='reference':
        result.update(status='READING',reason=item['aim'])
        if not args.all:
            print((folder/'README.md').read_text(encoding='utf-8'))
            for name in ('EXERCISE.md','TRACES.md'):
                if (folder/name).exists(): print((folder/name).read_text(encoding='utf-8'))
        return result
    if args.engine=='icarus' and not item['portable']:
        result.update(status='SKIP',reason='Outside the Icarus subset; use Xcelium / reference exercise')
        return result
    if kind=='external' and not (os.environ.get('PROTECTED_SOURCE') or '+PLAIN' in args.extra):
        result.update(status='EXTERNAL_REQUIRED',reason='See labs/59_protection/GUIDE.md; choose +PLAIN or PROTECTED_SOURCE')
        if not args.all: print((folder/'GUIDE.md').read_text(encoding='utf-8'))
        return result
    mode='compile' if kind=='compile_fail' else ('waves' if args.waves else 'run')
    name=f'learn-{item["id"]}-{args.engine}'
    output=ROOT/'build'/name/mode
    result['output']=output.relative_to(ROOT).as_posix()
    env=os.environ.copy()
    extra=list(args.extra)
    if args.engine=='xrun':
        if sys.platform!='linux' and not args.dry_run:
            result.update(status='BLOCKED',reason='Run xrun on Linux (or WSL connected to your licensed setup)')
            return result
        env.update(TOP='tb',FILELIST=str(folder/'files.f'),RUN_NAME=name,SEED=str(args.seed))
        if 'coverage' in item['flags'] or item['id'] in ('22_coverage','50_coverage_bins','72_integrated_fifo','80_coverage_selection'):
            extra=['-coverage','all']+extra
        if kind=='dpi': extra=[str(folder/x) for x in item['files'] if x.endswith('.c')]+extra
        if kind=='vpi': extra=['-access','+rwc','-loadvpi',str(output/'lab_vpi.so')+':register_lab_vpi']+extra
        if kind=='config':
            env['TOP']='lab_config'
            extra=['-libmap',str(output/'libraries.map'),'-compcnfg',str(folder/'select.cfg')]+extra
        if kind=='external':
            env['FILELIST']=str(output/'protected.f')
        command=['bash',str(ROOT/'scripts'/'xrun.sh'),mode]
        if args.dry_run:
            # The wrapper cannot validate a generated protected.f before creation.
            if kind=='external': env['FILELIST']=str(folder/'files.f')
            command+=['--dry-run']
        command+=extra
    else:
        compiler=os.environ.get('IVERILOG','iverilog')
        base=[compiler,'-g2012','-Wall','-I',str(COURSE/'common'),'-s','tb']
        if os.environ.get('IVERILOG_BASE'): base+=['-B',os.environ['IVERILOG_BASE']]
        if 'specify' in item['flags']: base+=['-gspecify']
        comp_extra=[]; run_extra=[]
        for x in extra:
            if x.startswith('+define+'):
                comp_extra.extend('-D'+d for d in x[len('+define+'):].split('+'))
            elif x=='-mindelays': comp_extra+=['-Tmin']
            elif x=='-maxdelays': comp_extra+=['-Tmax']
            elif x.startswith('+'): run_extra.append(x)
            else: raise ValueError(f'Icarus subset does not translate argument: {x}')
        sources=[folder/x for x in item['files'] if x.endswith(('.sv','.v'))]
        sources.sort(key=lambda p:p.name=='tb.sv')
        command=base+comp_extra+['-o',str(output/'lab.vvp')]+[str(p) for p in sources]
    if args.dry_run:
        if args.engine=='xrun':
            rc,log,_=execute(command,ROOT,15,env); print(log,end='')
        else:
            print(shlex.join(command)); rc=0
        result.update(status='DRY_RUN' if rc==0 else 'FAIL',reason='Command generation only')
        return result
    try:
        tool('xrun','XRUN') if args.engine=='xrun' else tool('iverilog','IVERILOG')
    except FileNotFoundError as error:
        result.update(status='BLOCKED',reason=str(error)); return result
    output.mkdir(parents=True,exist_ok=True)
    # Lock the entire lab, including fixture copy and C compilation.
    import fcntl
    with (output/'.course.lock').open('w') as lock:
        try: fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        except BlockingIOError:
            result.update(status='BLOCKED',reason='This lab is already running in the same directory'); return result
        copy_inputs(folder,output)
        if kind=='config':
            template=(folder/'libraries.map.in').read_text(encoding='utf-8')
            (output/'libraries.map').write_text(template.replace('@LAB@',str(folder)),encoding='utf-8')
        if kind=='external':
            selected=Path(os.environ['PROTECTED_SOURCE']).resolve() if os.environ.get('PROTECTED_SOURCE') else folder/'source.sv'
            if not selected.is_file():
                result.update(status='BLOCKED',reason=f'Protected source not found: {selected}'); return result
            (output/'protected.f').write_text(f'"{selected}"\n"{folder / "tb.sv"}"\n',encoding='utf-8')
            result['protection_mode']='protected-input' if os.environ.get('PROTECTED_SOURCE') else 'plain-reference'
        if kind=='vpi':
            try:
                cc=tool('cc','CC'); headers=header_dir('vpi_user.h','VPI_INCLUDE')
                build=[cc,'-std=c11','-Wall','-Wextra','-fPIC','-shared','-I',headers,folder/'plugin.c','-o',output/'lab_vpi.so']
                rc,log,timed_out=execute(build,output,args.timeout,env)
                (output/'c-build.log').write_text(log,encoding='utf-8')
                if rc!=0:
                    result.update(status='FAIL',reason='VPI C build failed; see c-build.log'); return result
            except FileNotFoundError as error:
                result.update(status='BLOCKED',reason=str(error)); return result
        (output/'invocation.json').write_text(json.dumps({'argv':command,'seed':args.seed,'engine':args.engine},indent=2),encoding='utf-8')
        rc,log,timed_out=execute(command,ROOT,args.timeout,env)
        (output/'compile.log' if args.engine=='icarus' else output/'console.log').write_text(log,encoding='utf-8')
        compile_rc=rc
        if args.engine=='icarus' and rc==0 and kind!='compile_fail':
            loader=['-m',str(output/'lab_vpi.so')] if kind=='vpi' else []
            rc,log,timed_out=execute([tool('vvp','VVP')]+loader+[str(output/'lab.vvp')]+run_extra,output,args.timeout,env)
            (output/'console.log').write_text(log,encoding='utf-8')
        result['returncode']=rc
        if timed_out:
            result.update(status='FAIL',reason='Wall-clock timeout; simulator process group terminated')
        elif kind in ('compile_fail','runtime_fail'):
            infrastructure=re.search(r'(?i)license|not found|cannot open|unable to open|permission denied|LMF-',log)
            diagnostic=re.search(item['diagnostic'],log)
            correct_stage=(kind=='compile_fail' or args.engine=='xrun' or compile_rc==0)
            if rc!=0 and diagnostic and not infrastructure and correct_stage:
                result.update(status='EXPECTED_FAIL',reason='Required diagnostic observed at intended stage')
            else: result.update(status='FAIL',reason='Expected failure did not match; inspect log')
        elif rc==0 and f'LAB_PASS {item["id"]}' in log and not re.search(r'CHECK_FAIL|SVA_FAILURE|VPI_FAILURE',log):
            result.update(status='PASS',reason='Self-checks completed')
        else:
            result.update(status='FAIL',reason='Compile/runtime failure or missing LAB_PASS; inspect log')
        if args.verbose or (result['status']=='FAIL' and not args.all): print(log,end='')
        (output/'result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    return result


def reference_search(command,query):
    index=json.loads((COURSE/'reference_index.json').read_text(encoding='utf-8'))
    source=index['source']
    if command=='ref':
        exact=[r for r in index['sections'] if r['id'].lower()==query.lower().replace('annex ','')]
        found=exact or [r for r in index['sections'] if query.lower() in (r['id']+' '+r['title']).lower()]
        for row in found[:50]:
            print(f'{row["id"]:10} PDF p.{row["pdf_page"]:<4} {row["title"]}')
            print('  labs: '+', '.join(row['labs'])+' ['+row['mapping']+']')
        if len(exact)==1:
            pages_file=COURSE/'reference.local.json'
            if pages_file.exists():
                pages=json.loads(pages_file.read_text(encoding='utf-8'))
                print('\n'+pages[exact[0]['pdf_page']-1]['text'])
        print('PDF:',source['source_path'])
    elif command=='grammar':
        found=[r for r in index['grammar'] if query.lower() in r['symbol'].lower()]
        for row in found[:20]:
            print(f'\n{row["symbol"]} — PDF p.{row["pdf_page"]}\n{row["text"]}')
    elif command=='keyword':
        for row in index['keywords']:
            if query.lower() in row['word'].lower():
                print(row['word']+': '+(', '.join(row['labs']) or '原文・発展課題'))
    elif command=='api':
        for row in index['apis']:
            if query.lower() in row['name'].lower():
                print(f'{row["name"]}: PDF p.{row["pdf_page"]} code='+(','.join(row['labs']) or '原文・発展課題'))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command',choices=['list','show','run','ref','grammar','keyword','api','report','serve'])
    parser.add_argument('query',nargs='?',default='')
    parser.add_argument('--lab',default='72_integrated_fifo')
    parser.add_argument('--engine',choices=['xrun','icarus'],default='xrun')
    parser.add_argument('--all',action='store_true')
    parser.add_argument('--dry-run',action='store_true')
    parser.add_argument('--waves',action='store_true')
    parser.add_argument('--verbose',action='store_true')
    parser.add_argument('--seed',type=int,default=1)
    parser.add_argument('--timeout',type=float,default=120)
    parser.add_argument('--port',type=int,default=8765)
    parsed,extra=parser.parse_known_args()
    parsed.extra=[x for x in extra if x!='--']
    if parsed.timeout<=0 or parsed.seed<0: parser.error('timeout must be positive; seed must be nonnegative')
    if parsed.command=='list':
        for item in CATALOG:
            match=(parsed.query.lower() in json.dumps(item,ensure_ascii=False).lower())
            if match: print(f'{item["id"]:24} [{item["kind"]:12}] {item["title"]}')
        return 0
    if parsed.command=='show':
        item=lab_for(parsed.query or parsed.lab)
        print((COURSE/'labs'/item['id']/'README.md').read_text(encoding='utf-8')); return 0
    if parsed.command in ('ref','grammar','keyword','api'):
        reference_search(parsed.command,parsed.query); return 0
    if parsed.command=='serve':
        from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
        from functools import partial
        print(f'Local catalog: http://127.0.0.1:{parsed.port}/course/index.html',flush=True)
        ThreadingHTTPServer(('127.0.0.1',parsed.port),partial(SimpleHTTPRequestHandler,directory=str(ROOT))).serve_forever()
    if parsed.command=='report':
        for engine in ('xrun','icarus'):
            report=ROOT/'build'/'course-results'/f'{engine}.json'
            if report.exists(): print(report.read_text(encoding='utf-8'))
        return 0
    selected=CATALOG if parsed.all else [lab_for(parsed.lab)]
    results=[]
    for item in selected:
        started=time.monotonic()
        try: result=run_one(item,parsed)
        except (FileNotFoundError,ValueError,OSError) as error:
            result=dict(id=item['id'],engine=parsed.engine,status='BLOCKED',reason=str(error))
        result['seconds']=round(time.monotonic()-started,3)
        results.append(result)
        print(f'{result["status"]:18} {item["id"]:24} {result["reason"]}',flush=True)
    counts=Counter(x['status'] for x in results)
    print('Summary: '+', '.join(f'{k}={v}' for k,v in sorted(counts.items())))
    if not parsed.dry_run:
        dest=ROOT/'build'/'course-results'; dest.mkdir(parents=True,exist_ok=True)
        data=dict(date=datetime.datetime.now(datetime.timezone.utc).isoformat(),engine=parsed.engine,
                  seed=parsed.seed,all=parsed.all,summary=dict(counts),results=results)
        # Keep suite evidence when a later single-lab run is performed.
        name=parsed.engine if parsed.all else parsed.engine+'-'+selected[0]['id']
        (dest/(name+'.json')).write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
    if counts['FAIL']: return 1
    if counts['BLOCKED'] or (not parsed.all and (counts['SKIP'] or counts['EXTERNAL_REQUIRED'])): return 2
    return 0


if __name__=='__main__':
    try: sys.exit(main())
    except KeyboardInterrupt: sys.exit(130)

#!/usr/bin/env python3
"""Meaningful runner checks + independent FIFO RTL tests. Run on Linux."""
import json,os,re,shutil,subprocess,sys,tempfile
from pathlib import Path,PurePosixPath,PureWindowsPath
ROOT=Path(__file__).resolve().parents[2]
OUTPUT=ROOT/'build'/'course-validation'; OUTPUT.mkdir(parents=True,exist_ok=True)
results=[]

def run(command,expected=0,env=None,log=None,cwd=None):
    p=subprocess.run([str(x) for x in command],cwd=cwd or ROOT,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=50)
    if log: (OUTPUT/(log+'.log')).write_text(p.stdout,encoding='utf-8')
    assert p.returncode==expected,(command,p.returncode,p.stdout)
    return p.stdout
def passed(name):
    print('PASS',name,flush=True); results.append(name)

catalog=json.loads((ROOT/'course/catalog.json').read_text(encoding='utf-8'))
index=json.loads((ROOT/'course/reference_index.json').read_text(encoding='utf-8'))
assert index['source']['source_path']=='course/reference.local.pdf'
verification=json.loads((ROOT/'course/verification.json').read_text(encoding='utf-8'))
for row in verification['runtime']['results']:
    if 'output' in row:
        assert not PurePosixPath(row['output']).is_absolute()
        assert not PureWindowsPath(row['output']).is_absolute()
        assert row['output'].startswith('build/')
bundle=(ROOT/'course/catalog-data.js').read_text(encoding='utf-8')
data=json.loads(bundle.removeprefix('window.IEEE_COURSE=').strip().removesuffix(';'))
assert data['index']==index and data['verification']==verification
assert len(catalog)==81 and len({x['id'] for x in catalog})==81
assert index['toc_count']==593 and len(index['keywords'])==248
assert all(x['labs'] for x in index['keywords'])
assert all(x['labs'] for x in index['sections'])
assert len({x['id'] for x in index['sections'] if x['id'].isdigit()})==41
assert len({x['id'] for x in index['sections'] if re.fullmatch('[A-Q]',x['id'])})==17
assert len({x['symbol'] for x in index['grammar']})==len(index['grammar'])
assert not any(re.search(r'\d$',x['symbol']) and x['symbol'] not in ['delay2','delay3','strength0','strength1'] for x in index['grammar'])
for item in catalog:
    folder=ROOT/'course'/'labs'/item['id']
    assert (folder/'README.md').is_file()
    for name in item['files']: assert (folder/name).is_file()
    for path in folder.iterdir():
        if path.is_file(): assert b'\r' not in path.read_bytes(),path
passed('Index: all 593 TOC entries, 41 chapters, 17 annexes, 248 keyword examples; no broken lab paths')

with tempfile.TemporaryDirectory(prefix='runner-',dir=OUTPUT) as temp:
    temporary=Path(temp)
    isolated=temporary/'project'; (isolated/'course').mkdir(parents=True)
    for name in ['Makefile']:
        shutil.copyfile(ROOT/name,isolated/name)
    for name in ['scripts','sim']:
        shutil.copytree(ROOT/name,isolated/name)
    for name in ['learn.py','learn.sh','catalog.json']:
        shutil.copyfile(ROOT/'course'/name,isolated/'course'/name)
    for name in ['labs','common']:
        shutil.copytree(ROOT/'course'/name,isolated/'course'/name)
    stub=temporary/'xrun_stub.py'
    stub.write_text('''#!/usr/bin/env python3
import json,os,pathlib,sys,time
kind=os.environ.get('STUB_MODE','pass')
lab=os.environ['RUN_NAME'].removeprefix('learn-').removesuffix('-xrun')
pathlib.Path('stub-arguments.json').write_text(json.dumps(sys.argv[1:]))
if kind=='timeout': time.sleep(20)
messages={'pass':'LAB_PASS '+lab+' checks=1',
          'implicit':'xmvlog: *E,UNDIDN: undeclared TYPO_SIGNAL',
          'wrong':'xmvlog: *E,OTHER: unrelated syntax failure',
          'license':'xrun: *F,LMF-ERROR: license unavailable TYPO_SIGNAL',
          'runtime':'EXPECTED_ASSERT_FAILURE',
          'empty':'simulation ended without marker'}
message=messages.get(kind,'')
if kind!='missing_log': pathlib.Path('xrun.log').write_text(message+'\\n')
print(message)
sys.exit(2 if kind in ['implicit','wrong','license','runtime'] else 0)
''',encoding='utf-8'); stub.chmod(0o755)
    env=os.environ.copy(); env['XRUN']=str(stub)
    command=[sys.executable,isolated/'course/learn.py','run','--engine','xrun']
    env['STUB_MODE']='pass'
    text=run(command+['--lab','42'],env=env,log='runner-pass'); assert 'PASS ' in text
    report=json.loads((isolated/'build/course-results/xrun-42_fileio.json').read_text(encoding='utf-8'))
    assert report['results'][0]['output']=='build/learn-42_fileio-xrun/run'
    passed('Runner accepts actual completion marker')
    env['STUB_MODE']='implicit'; text=run(command+['--lab','68'],env=env,log='runner-expected-compile'); assert 'EXPECTED_FAIL' in text
    env['STUB_MODE']='runtime'; text=run(command+['--lab','71'],env=env,log='runner-expected-runtime'); assert 'EXPECTED_FAIL' in text
    passed('Expected compile/runtime failures require matching diagnostics')
    for mode in ['wrong','license']:
        env['STUB_MODE']=mode; text=run(command+['--lab','68'],expected=1,env=env,log='runner-'+mode); assert 'EXPECTED_FAIL ' not in text
    passed('Unrelated compiler errors and license failures cannot pass negative tests')
    for mode in ['empty','missing_log']:
        env['STUB_MODE']=mode; run(command+['--lab','42'],expected=1,env=env,log='runner-'+mode)
    passed('Missing/empty completion and missing xrun.log are rejected')
    env['STUB_MODE']='timeout'; text=run(command+['--lab','42','--timeout','0.2'],expected=1,env=env,log='runner-timeout'); assert 'timeout' in text.lower()
    passed('Wall-clock timeout stops the simulator process group')
    env['STUB_MODE']='pass'
    for id in ['38','39','41','72']:
        text=run(command+['--lab',id,'--dry-run'],env=env,log='dry-'+id)
        assert 'DRY_RUN' in text
    run(['make','learn-dry-run','LAB=42','ARGS=+COUNT=2'],env=env,log='make-dry',cwd=isolated)
    passed('Make entry, config, DPI, VPI and FIFO command generation')

    compiler=os.environ.get('IVERILOG','iverilog'); vvp=os.environ.get('VVP','vvp')
    base=[compiler,'-g2012','-Wall']
    if os.environ.get('IVERILOG_BASE'): base+=['-B',os.environ['IVERILOG_BASE']]
    rtl=ROOT/'course/labs/72_integrated_fifo/fifo.sv'
    tb=ROOT/'course/tests/tb_fifo_portable.sv'
    for depth in [1,3,4,5]:
        binary=temporary/f'depth{depth}.vvp'
        run(base+['-s','tb',f'-Ptb.DEPTH={depth}','-o',binary,rtl,tb],log=f'fifo-compile-{depth}')
        text=run([vvp,binary],log=f'fifo-depth-{depth}'); assert 'FIFO_PORTABLE_PASS' in text
    passed('FIFO RTL: DEPTH=1/3/4/5, boundaries, wraparound, 1000 random steps each, asynchronous reset')
    source=rtl.read_text(encoding='utf-8')
    changes={
        'write-data':('mem[wr]<=wdata;','mem[wr]<=~wdata;'),
        'write-pointer':("wr<=(wr==DEPTH-1)?'0:wr+1'b1;","wr<=wr;"),
        'read-pointer':("if(take_pop) rd<=(rd==DEPTH-1)?'0:rd+1'b1;","if(take_pop) rd<=rd;"),
        'full-protection':('take_push=push && !full;','take_push=push;'),
        'empty-protection':('take_pop=pop && !empty;','take_pop=pop;'),
        'reset':("count<='0;","count<=1;")}
    for name,(before,after) in changes.items():
        assert before in source
        mutant=temporary/(name+'.sv'); mutant.write_text(source.replace(before,after),encoding='utf-8')
        binary=temporary/(name+'.vvp')
        run(base+['-s','tb','-o',binary,mutant,tb],log='mutant-compile-'+name)
        text=run([vvp,binary],expected=1,log='mutant-'+name)
        assert 'FIFO_' in text and 'FIFO_PORTABLE_PASS' not in text
    passed('Independent FIFO checker detects six injected RTL defects')

# Stub outputs stayed in the temporary copy; real simulator results are untouched.
(OUTPUT/'results.json').write_text(json.dumps(dict(groups=results,note='xrun-related checks use a stub; no Xcelium simulation was performed'),ensure_ascii=False,indent=2),encoding='utf-8')
print(f'Completed {len(results)} verification groups')

#!/usr/bin/env python3
"""Static SV-2017 checking with optional pyslang; never claims simulation success."""
import argparse,json,sys,hashlib
from pathlib import Path
course=Path(__file__).resolve().parents[1]; root=course.parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--python-path',type=Path); parser.add_argument('--lab')
args=parser.parse_args()
if args.python_path: sys.path.insert(0,str(args.python_path.resolve()))
import pyslang
catalog=json.loads((course/'catalog.json').read_text(encoding='utf-8'))
destination=root/'build'/'course-static'; destination.mkdir(parents=True,exist_ok=True)
results=[]
for item in catalog:
    if args.lab and item['id']!=args.lab: continue
    folder=course/'labs'/item['id']
    if item['kind'] in ('reference','external','config'):
        results.append(dict(id=item['id'],status='NOT_CHECKED',reason=item['kind'])); continue
    files=[folder/name for name in item['files'] if name.endswith(('.sv','.v'))]
    files.sort(key=lambda x:x.name=='tb.sv')
    driver=pyslang.driver.Driver(); driver.addStandardArgs()
    options='--std 1800-2017 --timescale 1ns/1ps --top tb -I "'+(course/'common').as_posix()+'" '
    options+=' '.join('"'+file.as_posix()+'"' for file in files)
    if not driver.parseCommandLine('slang '+options) or not driver.processOptions():
        raise SystemExit('Invalid slang invocation: '+options)
    driver.parseAllSources()
    comp=driver.createCompilation()
    diagnostics=comp.getAllDiagnostics()
    report=pyslang.DiagnosticEngine.reportAll(driver.sourceManager,diagnostics)
    errors=[d for d in diagnostics if d.isError()]
    expected=item['kind']=='compile_fail'
    import re
    rejected=bool(errors) and bool(re.search(item.get('diagnostic','(?!)'),report))
    status=('EXPECTED_REJECT' if rejected else 'FAIL') if expected else ('STATIC_OK' if not errors else 'FAIL')
    (destination/(item['id']+'.log')).write_text(report,encoding='utf-8')
    results.append(dict(id=item['id'],status=status,errors=len(errors),diagnostics=len(diagnostics)))
    print(f'{status:16} {item["id"]:24} errors={len(errors)} diagnostics={len(diagnostics)}',flush=True)
    if errors and not expected: print(report[:6000])
(destination/'results.json').write_text(json.dumps(dict(tool='pyslang '+pyslang.__version__,language='1800-2017',results=results),indent=2),encoding='utf-8')
raise SystemExit(any(x['status']=='FAIL' for x in results))

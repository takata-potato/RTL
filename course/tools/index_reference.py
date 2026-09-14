#!/usr/bin/env python3
"""Build local reference and code indexes from the user's IEEE 1800-2017 PDF.

The source PDF / full text stay in *.local.* files and are excluded from archives.
Rebuilding from a PDF requires pypdfium2; --pages reuses an existing extraction.
"""
import argparse,hashlib,json,re,shutil
from collections import defaultdict
from pathlib import Path

COURSE=Path(__file__).resolve().parents[1]
ROOT=COURSE.parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('pdf',type=Path)
parser.add_argument('--pages',type=Path)
args=parser.parse_args()
if args.pages:
    pages=json.loads(args.pages.read_text(encoding='utf-8'))
else:
    import pypdfium2 as pdfium
    doc=pdfium.PdfDocument(args.pdf)
    pages=[]
    for number in range(len(doc)):
        page=doc[number]; textpage=page.get_textpage()
        text=textpage.get_text_range().replace('\r\n','\n')
        pages.append(dict(page=number+1,text=text))
        textpage.close(); page.close()
    doc.close()
if len(pages)!=1315 or '1800' not in '\n'.join(x['text'] for x in pages[:10]):
    raise SystemExit('This indexer is configured for the attached 1315-page IEEE 1800-2017 edition.')
source=dict(title='IEEE Std 1800-2017',pages=len(pages),source_path='course/reference.local.pdf',
            sha256=hashlib.sha256(args.pdf.read_bytes()).hexdigest(),
            page_note='PDF physical page = printed page + 1 in this attachment')
catalog=json.loads((COURSE/'catalog.json').read_text(encoding='utf-8'))

def clean(text):
    return '\n'.join(line for line in text.splitlines()
                     if not re.match(r'^(IEEE Std 1800|IEEE Standard for|Copyright ©|Authorized licensed use limited|\d+\s*$)',line.strip()))

toc=[]
for page in pages[9:24]:
    for line in page['text'].splitlines():
        found=re.match(r'^\s*(\d+(?:\.\d+)*\.?|Annex [A-Z])\s+(.+?)\.{2,}\s*(\d+)\s*$',line)
        if found:
            id=found[1].rstrip('.').replace('Annex ','')
            toc.append(dict(id=id,title=found[2].strip(),printed_page=int(found[3]),pdf_page=int(found[3])+1,origin='contents'))
assert len(toc)==593, len(toc)
assert len([x for x in toc if x['id'].isdigit()])==41
assert len([x for x in toc if re.fullmatch('[A-Q]',x['id'])])==17
sections={x['id']:x for x in toc}
for page in pages[38:]:
    for line in clean(page['text']).splitlines():
        found=re.match(r'^((?:[1-9][0-9]?|[A-Q])(?:\.\d+)+)\s+([A-Za-z][^;=]{2,130})$',line.strip())
        if found and not re.search(r'\.{3}',found[2]):
            sections.setdefault(found[1],dict(id=found[1],title=found[2],pdf_page=page['page'],printed_page=page['page']-1,origin='body-heading'))

# References are entry points, not claims that every rule in a chapter is tested.
for row in sections.values():
    id=row['id']; chapter=id.split('.')[0]
    direct=[x['id'] for x in catalog if id in x['refs']]
    nearest=[]
    if not direct:
        parent=id
        while '.' in parent:
            parent=parent.rsplit('.',1)[0]
            nearest=[x['id'] for x in catalog if parent in x['refs']]
            if nearest: break
    if not direct and not nearest:
        nearest=[x['id'] for x in catalog if any(r==chapter or r.startswith(chapter+'.') for r in x['refs'])]
    row['labs']=direct or nearest
    row['mapping']='explicit-reference' if direct else 'chapter-entry'
    assert row['labs'],row

grammar=[]
active=None
def flush():
    global active
    if active:
        active['text']='\n'.join(active.pop('lines')).strip()
        grammar.append(active); active=None
for page in pages[38:1182]:
    # Full Annex A and the additional system-task grammar in the body.
    in_annex=1137<=page['page']<=1182
    for line in clean(page['text']).splitlines():
        found=re.match(r'^([a-z][a-z0-9_]*)(?:\d+)?\s*::=\s*(.*)$',line.strip())
        if found:
            flush()
            symbol=found[1]
            # PDF superscript footnote numbers were flattened into the LHS token.
            # delay2/3 and strength0/1 are the actual digit-bearing grammar names.
            if symbol not in ('delay2','delay3','strength0','strength1'):
                symbol=re.sub(r'\d+$','',symbol)
            active=dict(symbol=symbol,pdf_page=page['page'],annex_a=in_annex,lines=[line.strip()])
        elif active:
            if re.match(r'^(?:Syntax \d|[A-Q]\.\d|\d+\.\d+\s)',line.strip()): flush()
            else: active['lines'].append(line)
    if not in_annex: flush()
flush()
# Keep the complete Annex A rule when also shown as a partial excerpt in the body.
unique={}
for row in grammar:
    old=unique.get(row['symbol'])
    if old is None or (row['annex_a'] and not old['annex_a']): unique[row['symbol']]=row
grammar=sorted(unique.values(),key=lambda x:x['symbol'])

keyword_pages={}
for page in pages[1182:1184]:
    for line in page['text'].splitlines():
        if re.fullmatch('[a-z][a-z0-9_]*',line.strip()): keyword_pages[line.strip()]=page['page']
assert len(keyword_pages)==248
apis={}
for page in pages[937:1298]:
    for found in re.finditer(r'\b(vpi_[A-Za-z0-9_]+|sv[A-Z][A-Za-z0-9_]*)\s*\(',page['text']):
        apis.setdefault(found[1],dict(name=found[1],pdf_page=page['page']))

# Comments, strings and escaped identifiers do not count as keyword usage.
def tokens(code):
    scrub=re.sub(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/|\\\S+',' ',code)
    return set(re.findall(r'\b[a-zA-Z_][a-zA-Z0-9_$]*\b',scrub))
usage=defaultdict(list); api_usage=defaultdict(list)
source_files={}
for item in catalog:
    code_tokens=set(); c_tokens=set(); files=[]
    for path in sorted((COURSE/'labs'/item['id']).iterdir()):
        if not path.is_file(): continue
        if path.suffix in ('.sv','.svh','.v','.c','.cfg','.f','.md','.sdf','.hex') or path.name.endswith('.map.in'):
            content=path.read_text(encoding='utf-8')
            files.append(dict(name=path.name,path=path.relative_to(COURSE).as_posix(),text=content))
            if path.suffix in ('.sv','.svh','.v','.cfg') or path.name.endswith('.map.in'): code_tokens|=tokens(content)
            if path.suffix=='.c' and item['kind']!='reference': c_tokens|=tokens(content)
    source_files[item['id']]=files
    for word in code_tokens: usage[word].append(item['id'])
    for word in c_tokens: api_usage[word].append(item['id'])
keywords=[dict(word=word,pdf_page=page,labs=usage[word]) for word,page in sorted(keyword_pages.items())]
for row in apis.values(): row['labs']=api_usage[row['name']]

ordered=sorted(sections.values(),key=lambda x:(x['pdf_page'],tuple(int(y) if y.isdigit() else ord(y[0]) for y in x['id'].split('.'))))
index=dict(source=source,toc_count=len(toc),sections=ordered,grammar=grammar,keywords=keywords,
           apis=sorted(apis.values(),key=lambda x:x['name']))
(COURSE/'reference_index.json').write_text(json.dumps(index,ensure_ascii=False,indent=2),encoding='utf-8')
(COURSE/'reference.local.json').write_text(json.dumps(pages,ensure_ascii=False),encoding='utf-8')
shutil.copyfile(args.pdf,COURSE/'reference.local.pdf')
(COURSE/'reference.local.js').write_text('window.IEEE_PAGES='+json.dumps(pages,ensure_ascii=False)+';\n',encoding='utf-8')
verification={}
if (COURSE/'verification.json').exists(): verification=json.loads((COURSE/'verification.json').read_text(encoding='utf-8'))
data=dict(index=index,catalog=catalog,files=source_files,verification=verification)
(COURSE/'catalog-data.js').write_text('window.IEEE_COURSE='+json.dumps(data,ensure_ascii=False)+';\n',encoding='utf-8')

# Markdown works even without a browser or the optional local PDF copy.
rows=['# 規格から実験を探す','',
      '添付IEEE 1800-2017の目次全593項目と本文から検出した小節。`章の入口`は関連実験への案内で、その小節の全規則を実験済みという意味ではありません。','',
      '| 節 | 内容 | PDFページ | 実験への入口 | 対応 |','| --- | --- | --- | --- | --- |']
for row in ordered:
    links=', '.join(f'[{id}](labs/{id}/README.md)' for id in row['labs'][:5])
    if len(row['labs'])>5: links+=' …（画面の索引に全件）'
    rows.append(f'| {row["id"]} | {row["title"].replace("|","/")} | {row["pdf_page"]} | {links} | {"明示参照" if row["mapping"]=="explicit-reference" else "章の入口"} |')
(COURSE/'COVERAGE_MAP.md').write_text('\n'.join(rows)+'\n',encoding='utf-8')
print(json.dumps(dict(toc=len(toc),sections=len(ordered),grammar=len(grammar),annex_a_rules=sum(x['annex_a'] for x in grammar),keywords=len(keywords),keywords_in_code=sum(bool(x['labs']) for x in keywords),apis=len(apis)),ensure_ascii=False))

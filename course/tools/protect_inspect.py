#!/usr/bin/env python3
"""Inspect pragma envelope structure; this neither decrypts nor validates keys."""
import argparse,re
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__); p.add_argument('source',type=Path)
args=p.parse_args(); depth=0; envelopes=0
for number,line in enumerate(args.source.read_text(encoding='utf-8',errors='replace').splitlines(),1):
    if not re.match(r'\s*`pragma\s+protect\b',line): continue
    content=re.sub(r'^\s*`pragma\s+protect\s*','',line)
    if re.search(r'\bbegin_protected\b',content): depth+=1; envelopes+=1
    if re.search(r'\bend_protected\b',content):
        depth-=1
        if depth<0: raise SystemExit(f'Unmatched end_protected at line {number}')
    print(f'{number:5}: {content}')
if depth: raise SystemExit('Unclosed protected envelope')
if not envelopes: raise SystemExit('No protected envelope found (possibly plaintext/encryption input)')
print(f'Envelope structure found: {envelopes}. Cryptographic validity and tool compatibility remain unverified.')

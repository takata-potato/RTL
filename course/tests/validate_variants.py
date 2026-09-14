#!/usr/bin/env python3
"""Check plusargs and min/typ/max against a real Icarus installation on Linux."""
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / 'build/course-variants'
OUTPUT.mkdir(parents=True, exist_ok=True)
results = []


def run(label, lab, extra, expected_status, expected_rc=0):
    command = [sys.executable, 'course/learn.py', 'run', '--engine', 'icarus',
               '--lab', lab, '--timeout', '30', '--'] + extra
    result = subprocess.run(command, cwd=ROOT, text=True, encoding='utf-8',
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=45)
    (OUTPUT / (label + '.log')).write_text(result.stdout, encoding='utf-8')
    assert result.returncode == expected_rc, result.stdout
    report = json.loads((ROOT / 'build/course-results' / ('icarus-' + lab + '.json')).read_text())
    row = report['results'][0]
    assert row['status'] == expected_status, row
    results.append(dict(name=label, id=lab, args=extra, observed_status=expected_status,
                        verification='PASS', source_sha256=row['source_sha256']))
    print('PASS:', label, flush=True)


run('fault-injection-rejected', '42_fileio', ['+INJECT_FAIL'], 'FAIL', 1)
run('invalid-count-rejected', '42_fileio', ['+COUNT=0'], 'FAIL', 1)
run('count-and-vcd', '42_fileio', ['+COUNT=2', '+WAVES'], 'PASS')
directory = ROOT / 'build/learn-42_fileio-icarus/run'
assert (directory / 'results.txt').read_text().splitlines() == ['16', '32']
assert (directory / 'trace.vcd').stat().st_size > 0
assert '+COUNT -> count=2' in (directory / 'console.log').read_text()
run('minimum-path-delay', '35_specify', ['-mindelays', '+EXPECTED_DELAY=1'], 'PASS')
run('maximum-path-delay', '35_specify', ['-maxdelays', '+EXPECTED_DELAY=5'], 'PASS')

result = subprocess.run(['make', 'learn-dry-run', 'LAB=80'], cwd=ROOT,
                        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                        text=True, encoding='utf-8', timeout=30)
assert result.returncode == 0 and '-coverage all' in result.stdout, result.stdout
(OUTPUT / 'coverage-command.log').write_text(result.stdout, encoding='utf-8')
results.append(dict(name='coverage-80-command', verification='PASS',
                    note='Command generation only; Xcelium was not run'))
print('PASS: coverage-80-command', flush=True)
(OUTPUT / 'results.json').write_text(json.dumps(results, indent=2) + '\n', encoding='utf-8')

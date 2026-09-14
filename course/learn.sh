#!/usr/bin/env bash
set -euo pipefail
COURSE_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
cd -- "$COURSE_ROOT"
if [[ -f env.local.sh ]]; then
  set -a
  source env.local.sh
  set +a
fi
if [[ -n ${XCELIUM_HOME:-} ]]; then
  export PATH="$XCELIUM_HOME/tools/bin:$XCELIUM_HOME/bin:$PATH"
fi
exec "${PYTHON:-python3}" "$COURSE_ROOT/course/learn.py" "$@"

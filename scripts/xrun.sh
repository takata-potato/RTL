#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
export RTL_ROOT="$ROOT"
cd -- "$ROOT"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

help_text() {
    cat <<'EOF'
Usage: bash scripts/xrun.sh [COMMAND] [--dry-run] [--] [xrun arguments...]
       make [COMMAND] [TOP=tb_counter] [FILELIST=sim/files.f] [SEED=1]

  run       Compile, elaborate and simulate (default; no waveform overhead)
  waves     Run and save SHM waveforms
  gui       Open SimVision at time zero; press Run in the GUI
  compile   Compile only
  elab      Compile and elaborate only
  view      Open the SHM database from the most recent waves run
  doctor    Check Linux, xrun version and license-variable presence
  dry-run   Print the run command without xrun or output-file creation
  clean     Remove this project's generated build directory
  help      Show this help

Variables: TOP, FILELIST, SEED (integer or random), RUN_NAME, XRUN, SIMVISION
Optional tool configuration: env.local.sh (see env.example.sh)
Outputs: build/<RUN_NAME>/<COMMAND>/
Relative FILELIST paths are project-relative; entries inside it are -F-relative.
Relative paths in extra xrun arguments are relative to the output directory.

Annotated syntax tutorial (Make shortcuts):
  make demo             Run the self-checking RTL / SystemVerilog tutorial
  make demo-waves       Save tutorial SHM waveforms
  make demo-gui         Open the tutorial in SimVision
  make demo-view        View the tutorial's saved SHM waveforms
  make demo-dry-run     Print the tutorial command without xrun
  make demo XRUN_ARGS='+CYCLES=20 +VERBOSE'
EOF
}

mode=${1:-run}
if (($#)); then shift; fi
dry_run=0
if [[ $mode == dry-run ]]; then mode=run; dry_run=1; fi
if [[ ${1:-} == --dry-run ]]; then dry_run=1; shift; fi
if [[ ${1:-} == -- ]]; then shift; fi
case "$mode" in
    help|-h|--help) help_text; exit 0 ;;
    run|waves|gui|compile|elab|doctor|view|clean) ;;
    *) die "Unknown command: $mode (use make help)" ;;
esac
if ((dry_run)); then
    case "$mode" in
        doctor|view|clean) die "--dry-run is supported for run, waves, gui, compile and elab only." ;;
    esac
fi

if [[ -f "$ROOT/env.local.sh" ]]; then
    # shellcheck source=/dev/null
    source "$ROOT/env.local.sh"
fi
if [[ -n ${XCELIUM_HOME:-} ]]; then
    export PATH="$XCELIUM_HOME/tools/bin:$XCELIUM_HOME/bin:$PATH"
fi

TOP=${TOP:-tb_counter}
FILELIST=${FILELIST:-sim/files.f}
SEED=${SEED:-1}
RUN_NAME=${RUN_NAME:-$TOP}
XRUN=${XRUN:-xrun}
SIMVISION=${SIMVISION:-simvision}
build_dir="$ROOT/build"

if [[ $mode == doctor ]]; then
    printf 'Platform: %s\n' "$(uname -sm)"
    [[ $(uname -s) == Linux ]] || die "Run this environment on Linux."
    if ! command -v -- "$XRUN" >/dev/null 2>&1; then
        die "xrun was not found. Load your site's Xcelium setup or edit env.local.sh."
    fi
    printf 'xrun: %s\n' "$(command -v -- "$XRUN")"
    "$XRUN" -version
    for variable in CDS_LIC_FILE LM_LICENSE_FILE; do
        if [[ -n ${!variable:-} ]]; then
            printf '%s: set\n' "$variable"
        else
            printf '%s: not set\n' "$variable"
        fi
    done
    printf 'Version checks do not check out a simulation license; use make run to verify it.\n'
    exit 0
fi

if [[ $mode == clean ]]; then
    [[ ! -L "$build_dir" ]] || die "Refusing to clean a symlink: $build_dir"
    if [[ -d "$build_dir" ]]; then
        [[ $(cd -- "$build_dir" && pwd -P) == "$ROOT/build" ]] || die "Unexpected build path."
        rm -rf -- "$build_dir"
    fi
    printf 'Cleaned: %s\n' "$build_dir"
    exit 0
fi

[[ $RUN_NAME =~ ^[a-zA-Z0-9_][a-zA-Z0-9_.-]*$ ]] || die "Use letters, digits, _, . or - in RUN_NAME; start with a letter, digit or _."
if [[ $mode == view ]]; then
    waveform="$build_dir/$RUN_NAME/waves/waves.shm"
    [[ -d "$waveform" ]] || die "No waveform at $waveform; run make waves first."
    command -v -- "$SIMVISION" >/dev/null 2>&1 || die "simvision was not found."
    exec "$SIMVISION" "$waveform" "$@"
fi

[[ $SEED == random || $SEED =~ ^[0-9]+$ ]] || die "SEED must be a nonnegative integer or random."
[[ $FILELIST == /* ]] || FILELIST="$ROOT/$FILELIST"
[[ -f "$FILELIST" ]] || die "File list not found: $FILELIST"
run_dir="$build_dir/$RUN_NAME/$mode"
command=("$XRUN" -64bit -sv -timescale 1ns/1ps -F "$FILELIST" -top "$TOP" -l xrun.log)
case "$mode" in
    run) command+=(-svseed "$SEED") ;;
    waves) command+=(-svseed "$SEED" -access +r -input "$ROOT/sim/waves.tcl") ;;
    gui) command+=(-svseed "$SEED" -access +rwc -gui -input "$ROOT/sim/probe.tcl") ;;
    compile) command+=(-compile) ;;
    elab) command+=(-elaborate) ;;
esac
command+=("$@")

print_command() {
    printf 'cd %q\n' "$run_dir"
    printf '%q ' "${command[@]}"
    printf '\n'
}
if ((dry_run)); then print_command; exit 0; fi

[[ $(uname -s) == Linux ]] || die "Run this environment on Linux."
command -v -- "$XRUN" >/dev/null 2>&1 || die "xrun was not found. Load your site's Xcelium setup or edit env.local.sh."
# Resolve relative executable paths before changing the working directory.
if [[ $XRUN == */* && $XRUN != /* ]]; then command[0]="$ROOT/$XRUN"; fi
[[ $mode != gui || -n ${DISPLAY:-} ]] || die "GUI requires DISPLAY; use make waves for a headless run."
command -v flock >/dev/null 2>&1 || die "flock is required (Linux util-linux package)."
mkdir -p -- "$run_dir"
cd -- "$run_dir"
exec 9>.run.lock
flock -n 9 || die "This output directory is in use. Set a different RUN_NAME for parallel runs."
print_command | tee command.txt

# Do not pipe xrun through tee: preserve its real exit status.
# Clear the previous log so it cannot be mistaken for this invocation's result.
rm -f -- xrun.log
status=0
"${command[@]}" || status=$?
if ((status != 0)); then
    printf 'ERROR: xrun exited with status %d. Log: %s/xrun.log\n' "$status" "$run_dir" >&2
    exit "$status"
fi
[[ -s xrun.log ]] || die "xrun returned success without creating xrun.log. Check XRUN and do not override -l in extra arguments."
# Some simulator errors can be logged without a nonzero process exit status.
# This also prevents the Tcl exit command from hiding reported simulation errors.
if [[ -f xrun.log ]] && grep -Eq '\*[EF],' xrun.log; then
    die "xrun reported errors; see $run_dir/xrun.log"
fi
printf 'Completed: %s\nLog: %s/xrun.log\n' "$mode" "$run_dir"

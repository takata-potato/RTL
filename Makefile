SHELL := /bin/bash
.DEFAULT_GOAL := run

PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TOP ?= tb_counter
FILELIST ?= sim/files.f
SEED ?= 1
RUN_NAME ?= $(TOP)
XRUN_ARGS ?=
export TOP FILELIST SEED RUN_NAME

.PHONY: run waves gui compile elab doctor dry-run view clean help
run waves gui compile elab doctor dry-run view clean help:
	@bash "$(PROJECT_ROOT)/scripts/xrun.sh" $@ $(XRUN_ARGS)

# 前の20項目をひとつにまとめた、解説付きRTL/TB。
.PHONY: demo demo-waves demo-gui demo-view demo-dry-run
demo demo-waves demo-gui demo-view demo-dry-run: TOP = tb_syntax_demo
demo demo-waves demo-gui demo-view demo-dry-run: FILELIST = examples/syntax_demo/files.f
demo:
	@bash "$(PROJECT_ROOT)/scripts/xrun.sh" run $(XRUN_ARGS)
demo-waves demo-gui demo-view demo-dry-run:
	@bash "$(PROJECT_ROOT)/scripts/xrun.sh" $(patsubst demo-%,%,$@) $(XRUN_ARGS)

# IEEE 1800-2017 全体を辿る学習コース。Linux + Python 3。
LAB ?= 72_integrated_fifo
ENGINE ?= xrun
ARGS ?=
TIMEOUT ?= 120
export PROTECTED_SOURCE VPI_INCLUDE DPI_INCLUDE
.PHONY: learn learn-list learn-all learn-show learn-waves learn-dry-run learn-open learn-report
learn:
	@bash "$(PROJECT_ROOT)/course/learn.sh" run --lab "$(LAB)" --engine "$(ENGINE)" --seed "$(SEED)" --timeout "$(TIMEOUT)" -- $(ARGS)
learn-list:
	@bash "$(PROJECT_ROOT)/course/learn.sh" list
learn-all:
	@bash "$(PROJECT_ROOT)/course/learn.sh" run --all --engine "$(ENGINE)" --seed "$(SEED)" --timeout "$(TIMEOUT)" -- $(ARGS)
learn-show:
	@bash "$(PROJECT_ROOT)/course/learn.sh" show --lab "$(LAB)"
learn-waves:
	@bash "$(PROJECT_ROOT)/course/learn.sh" run --lab "$(LAB)" --engine "$(ENGINE)" --seed "$(SEED)" --waves -- $(ARGS)
learn-dry-run:
	@bash "$(PROJECT_ROOT)/course/learn.sh" run --lab "$(LAB)" --engine "$(ENGINE)" --seed "$(SEED)" --dry-run -- $(ARGS)
learn-open:
	@bash "$(PROJECT_ROOT)/course/learn.sh" serve
learn-report:
	@bash "$(PROJECT_ROOT)/course/learn.sh" report

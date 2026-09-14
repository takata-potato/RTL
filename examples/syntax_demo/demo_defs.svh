// [03/04] include はここを文字どおり挿入する。ガードで重複を防ぐ。
`ifndef SYNTAX_DEMO_DEFS_SVH
`define SYNTAX_DEMO_DEFS_SVH

// [05/20] +define+DEMO_WIDTH=16 があればそちらを使う。
// マクロはコンパイル時の文字置換。RTLの parameter へ渡す値に利用する。
`ifndef DEMO_WIDTH
`define DEMO_WIDTH 8
`endif

`define DEMO_TITLE "RTL / SystemVerilog syntax demo"

`endif

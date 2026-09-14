// 02_directives | コンパイル前にコードが変わる
// 規格: 22 3.14
// 見るところ: マクロはコンパイル時、plusargsはシミュレーション時に選ぶ。
// 変更してみる: make learn LAB=02_directives ARGS="+define+LAB_WIDTH=12" と ARGS="+LAB_WIDTH=12" を比べる。
`default_nettype none
`include "lab.svh"
`include "lab.svh" // 二重includeでもガードで再定義しない
`ifndef LAB_WIDTH
  `define LAB_WIDTH 8
`endif
`define JOIN(a,b) a``b
`define AS_TEXT(x) `"x`"
`begin_keywords "1800-2017"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  localparam int WIDTH = `LAB_WIDTH;
  logic [WIDTH-1:0] `JOIN(data,_q);
  initial begin
    data_q = '1;
    `CHECK($bits(data_q) == WIDTH, "macro controls declaration width")
    $display("compile WIDTH=%0d text=%s runtime_flag=%0b", WIDTH,
             `AS_TEXT(data_q), $test$plusargs("LAB_WIDTH"));
    `DONE("02_directives")
  end
  `undef JOIN
  `undef AS_TEXT
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire
`end_keywords

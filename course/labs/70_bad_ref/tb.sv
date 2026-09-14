// 70_bad_ref | 失敗を学ぶ：refの実引数
// 規格: 13.5.2
// 見るところ: refは変数そのものを参照するので、計算式は渡せない。
// 変更してみる: int tmpに1+2を代入してからtmpを渡す。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  function automatic void BAD_REF_ARGUMENT(ref int value); value++; endfunction
  initial BAD_REF_ARGUMENT(1+2);
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

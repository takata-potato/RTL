// 68_bad_implicit | 失敗を学ぶ：暗黙netを禁止する
// 規格: 6.10 22.8
// 見るところ: タイプミスを1bit wireとして通してしまう書き方を、コンパイルで止める。
// 変更してみる: `default_nettype wireへ変えて暗黙netが作られるケースと比較する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wire expected;
  assign TYPO_SIGNAL=1'b1;
  assign expected=TYPO_SIGNAL;
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

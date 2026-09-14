// 69_bad_enum | 失敗を学ぶ：enumへ整数を直入れ
// 規格: 6.19 6.24
// 見るところ: enumはビット幅が同じだけでは暗黙に代入できない。
// 変更してみる: STATE_ONEへの名前代入または$castの戻り値検査に書き換える。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  typedef enum logic [1:0] {STATE_ZERO=0,STATE_ONE=1} state_t;
  state_t BAD_ENUM_ASSIGN;
  initial BAD_ENUM_ASSIGN=2'b01;
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

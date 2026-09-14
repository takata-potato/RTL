// 38_config | libraryとconfigで実装を選ぶ
// 規格: 33 23.10
// 見るところ: 同名のcellをfast/slowライブラリーに置き、configでfastを選択する。
// 変更してみる: select.cfgのfast.cell_modelをslow.cell_modelへ変え、TB期待値を22へ変える。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wire [7:0] result; cell_model dut(result);
  initial begin #1ns; `CHECK(result==11, "configuration selected fast library") `DONE("38_config") end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

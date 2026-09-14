// 41_vpi | VPIで回路を探索しシステム関数を追加
// 規格: 36 37 38 K L M
// 見るところ: $lab_peek("tb.target")をCで定義し、指定された信号を階層名で読む。
// 変更してみる: 階層名を存在しないものへ変えると、未取得を値0として扱わず失敗する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic [31:0] target=42;
  initial begin
    #1ns; `CHECK($lab_peek("tb.target")==42, "VPI finds target by hierarchical name")
    target=99;
    #1ns; `CHECK($lab_peek("tb.target")==99, "VPI reads current simulation value")
    `DONE("41_vpi")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

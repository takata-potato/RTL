// 54_legacy_storage | 昔の記述を読む：defparamとprocedural assign
// 規格: 10.6 23.10 C
// 見るところ: 既存コードを読むため、parameterの後付け変更と手続き的連続代入を試す。
// 変更してみる: 新規RTLでは#(.WIDTH(3))へ書換え、手続き的assignは通常のalways記述へ置換する。
`default_nettype none
`include "lab.svh"
module legacy #(parameter WIDTH=8)(output wire [WIDTH-1:0] q);
  assign q='1;
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wire [2:0] parameterized; reg q=0,d=0;
  legacy dut(parameterized); defparam dut.WIDTH=3;
  initial begin
    #1ns; `CHECK(parameterized===3'b111, "legacy defparam override")
    assign q=d; d=1; #1ns; `CHECK(q===1'b1, "procedural continuous assignment")
    deassign q; d=0; #1ns; `CHECK(q===1'b1, "deassign leaves last value in variable")
    q=0; `CHECK(q===1'b0, "ordinary procedural assignment resumes")
    `DONE("54_legacy_storage")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

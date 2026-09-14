// 29_clocking | clocking blockでサンプルと駆動を分ける
// 規格: 14 16.18 25.7
// 見るところ: 入力はエッジ直前、出力はエッジ後に扱い、DUTとの競合を避ける。
// 変更してみる: cb.qを1回早く読むと旧値が見える。入力skewを図と照らして考える。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0; logic [7:0] d=0,q=0;
  always #5ns clk=~clk;
  always_ff @(posedge clk) q<=d;
  default clocking cb @(posedge clk);
    default input #1step output #0;
    output d;
    input q;
  endclocking
  initial begin
    @(cb); cb.d<=7;
    ##1; `CHECK(cb.q==0, "sample before DUT captures newly driven value")
    ##1; `CHECK(cb.q==7, "next sampled cycle sees registered value")
    `DONE("29_clocking")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

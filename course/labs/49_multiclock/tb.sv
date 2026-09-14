// 49_multiclock | 複数クロックのアサーション
// 規格: 14.14 16.9.4 16.13 16.16
// 見るところ: clk_aの要求から次のclk_bの応答へ、SVAのクロックを切り替える。
// 変更してみる: ready_bを0へ変えて失敗する時刻を比較する。future系は将来のサンプルを要するので別途規格の意味を読む。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk_a=0,clk_b=0,req_a=0,ready_b=1; int observations=0;
  always #5ns clk_a=~clk_a;
  always #7ns clk_b=~clk_b;
  global clocking global_cb @(posedge clk_a); endclocking
  a_cross_clock: assert property(@(posedge clk_a) req_a |=> @(posedge clk_b) ready_b)
    else $fatal(1,"SVA_FAILURE crossing");
  c_cross_clock: cover property(@(posedge clk_a) req_a ##1 @(posedge clk_b) ready_b) observations++;
  initial begin
    @(negedge clk_a); req_a=1;
    @(negedge clk_a); req_a=0;
    #30ns;
    `CHECK(observations==1, "sequence crossed clock domains")
    `DONE("49_multiclock")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

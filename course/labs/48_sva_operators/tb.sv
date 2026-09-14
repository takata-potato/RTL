// 48_sva_operators | SVA演算子を同じ波形で比べる
// 規格: 16.9 16.12
// 見るところ: a→b→b→cの有限トレースを複数の書き方で検査する。
// 変更してみる: 中断信号abort_signalを1にし、acceptとrejectの結論の差を見る。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,a=0,b=0,c=0,abort_signal=0; int hits=0;
  always #5ns clk=~clk;
  default clocking cb @(posedge clk); endclocking
  a_goto: assert property(a |-> b[->2] ##1 c) else $fatal(1,"SVA_FAILURE goto");
  a_nonconsecutive: assert property(a |-> b[=2] ##1 c) else $fatal(1,"SVA_FAILURE nonconsecutive");
  a_within: assert property(a |-> (b[*2] within (a ##3 c))) else $fatal(1,"SVA_FAILURE within");
  a_next: assert property(a |-> s_nexttime b) else $fatal(1,"SVA_FAILURE nexttime");
  a_eventual: assert property(a |-> s_eventually[1:3] c) else $fatal(1,"SVA_FAILURE eventually");
  a_accept: assert property(a |-> accept_on(abort_signal) (1'b1 ##3 c)) else $fatal(1,"SVA_FAILURE accept");
  a_reject: assert property(a |-> reject_on(abort_signal) (1'b1 ##3 c)) else $fatal(1,"SVA_FAILURE reject");
  a_sync_accept: assert property(a |-> sync_accept_on(abort_signal) (1'b1 ##3 c)) else $fatal(1,"SVA_FAILURE sync_accept");
  a_sync_reject: assert property(a |-> sync_reject_on(abort_signal) (1'b1 ##3 c)) else $fatal(1,"SVA_FAILURE sync_reject");
  c_hit: cover property(a ##3 c) hits++;
  initial begin
    @(negedge clk); a=1;
    @(negedge clk); a=0; b=1;
    @(negedge clk);
    @(negedge clk); b=0; c=1;
    repeat(2) @(negedge clk);
    `CHECK(hits==1, "operator examples reached their consequent")
    `DONE("48_sva_operators")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

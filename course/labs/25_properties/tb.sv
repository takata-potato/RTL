// 25_properties | propertyの合成と有限トレース
// 規格: 16.12 16.17 Annex F
// 見るところ: sequenceを真偽の性質として使い、終了までに成立すべき条件を表す。
// 変更してみる: doneを立てない変更で失敗や終了時未完了がどう報告されるか観察する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,start=0,busy=0,done=0; int observed=0;
  always #5ns clk=~clk;
  property eventual_completion;
    @(posedge clk) start |-> strong(busy[*2] ##1 done);
  endproperty
  a_complete: assert property(eventual_completion)
    else $fatal(1,"SVA_FAILURE strong completion");
  a_until: assert property(@(posedge clk) start |-> busy s_until done)
    else $fatal(1,"SVA_FAILURE until");
  c_done: cover property(@(posedge clk) start ##2 done) observed++;
  initial begin
    @(negedge clk); start=1; busy=1;
    @(negedge clk); start=0;
    @(negedge clk); busy=0; done=1;
    repeat(2) @(negedge clk);
    `CHECK(observed==1, "nonvacuous completion trace observed")
    `DONE("25_properties")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

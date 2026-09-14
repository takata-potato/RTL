// 77_property_forms | assume/restrict・expect・残りのproperty形式
// 規格: 16.12 16.14 16.17 11.12
// 見るところ: assert以外の検証文と、終了条件を含むpropertyの形式を試す。
// 変更してみる: 仮定assumeは形式検証では入力条件、シミュレーションでは検査となる点を区別する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,go=0,done=0,safe=1; bit expected=0;
  always #5ns clk=~clk;
  default clocking cb @(posedge clk); endclocking
  let positive(x)=x>0;
  `ifdef EXPLICIT_UNTYPED
    sequence enabled_sequence(untyped condition); condition; endsequence
  `else
    sequence enabled_sequence(condition); condition; endsequence
  `endif
  a_environment: assume property(enabled_sequence(safe)) else $fatal(1,"ASSUMPTION_FAILURE");
  restrict property(safe);
  a_weak: assert property(go |-> weak(1'b1 ##1 done)) else $fatal(1,"PROPERTY_FAILURE weak");
  a_next: assert property(go |-> nexttime done) else $fatal(1,"PROPERTY_FAILURE next");
  a_eventual: assert property(go |-> eventually[1:2] done) else $fatal(1,"PROPERTY_FAILURE eventual");
  a_always: assert property(go |-> s_always[0:2] safe) else $fatal(1,"PROPERTY_FAILURE always");
  a_until: assert property(go |-> safe until done) else $fatal(1,"PROPERTY_FAILURE until");
  a_until_with: assert property(go |-> safe until_with done) else $fatal(1,"PROPERTY_FAILURE until_with");
  a_strong_until: assert property(go |-> safe s_until_with done) else $fatal(1,"PROPERTY_FAILURE strong until");
  a_implies: assert property(go implies safe) else $fatal(1,"PROPERTY_FAILURE implies");
  a_iff: assert property(safe iff !1'b0) else $fatal(1,"PROPERTY_FAILURE iff");
  initial begin
    fork
      begin expect(@(posedge clk) strong(1'b1 ##2 done)) expected=1; else $fatal(1,"EXPECT_FAILURE"); end
      begin @(negedge clk); go=1; @(negedge clk); go=0; done=1; end
    join
    repeat(3) @(negedge clk);
    `CHECK(expected && positive(3), "expect completion and untyped let")
    `DONE("77_property_forms")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

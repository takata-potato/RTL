// 24_sequences | SVAの列：遅延・繰返し・合成
// 規格: 16.7 16.8 16.9 16.10 16.11 16.12
// 見るところ: A→B→Cという時間の並びを記述し、複数の演算子で同じトレースを照合する。
// 変更してみる: Bのサイクルを1つ遅らせ、##1を##[1:2]へ変えた場合を比べる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,a=0,b=0,c=0,enable=1; int matched_count=0;
  always #5ns clk=~clk;
  sequence abc; a ##1 b ##1 c; endsequence
  sequence held; enable throughout abc; endsequence
  sequence parallel_shape; abc intersect (a ##2 c); endsequence
  sequence captured;
    int sample_value;
    (a, sample_value=7) ##1 b ##1 (c && sample_value==7);
  endsequence
  a_sequence: assert property (@(posedge clk) a |-> first_match(held))
    else $fatal(1,"SVA_FAILURE held");
  a_intersect: assert property (@(posedge clk) a |-> parallel_shape)
    else $fatal(1,"SVA_FAILURE intersect");
  c_captured: cover property (@(posedge clk) captured) matched_count++;
  a_repeat: assert property (@(posedge clk) a |-> enable[*3])
    else $fatal(1,"SVA_FAILURE repeat");
  initial begin
    @(negedge clk); a=1;
    @(negedge clk); a=0; b=1;
    @(negedge clk); b=0; c=1;
    @(negedge clk); c=0;
    repeat(2) @(negedge clk);
    `CHECK(matched_count==1, "sequence local variable and cover action")
    `DONE("24_sequences")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

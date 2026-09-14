// 10_assignments | 代入・保持・force/release
// 規格: 10 9.2
// 見るところ: 組合せ、FF、ラッチそれぞれで値がいつ更新されるか見る。
// 変更してみる: always_ffの<=を=へ変え、14_schedulingと比較する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0, gate=0; logic [7:0] d=0, comb, q=0, held=0;
  wire [7:0] driven; assign driven=d;
  always #5ns clk=~clk;
  always_comb comb=d+8'd1;
  always_ff @(posedge clk) q<=d;
  always_latch if(gate) held<=d;
  initial begin
    @(negedge clk); d=7; gate=1;
    #1ns; `CHECK(comb==8 && held==7, "combinational and transparent latch")
    @(posedge clk); #1ns; `CHECK(q==7, "flip-flop after NBA")
    gate=0; d+=1; #1ns;
    `CHECK(held==7 && comb==9, "latch holds when gate closes")
    force driven=8'hff; #1ns; `CHECK(driven==255, "force overrides continuous driver")
    release driven; #1ns; `CHECK(driven==d, "wire resumes its driver")
    `DONE("10_assignments")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

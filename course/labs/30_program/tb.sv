// 30_program | programのReactive領域
// 規格: 24 4.4 4.8
// 見るところ: moduleのNBA更新を、programのReactive領域から読む。
// 変更してみる: programをmoduleに変えると同じposedgeで読む値は更新前になる。
`default_nettype none
`include "lab.svh"
program automatic stimulus(input wire logic clk, input wire logic [7:0] q);
  timeunit 1ns; timeprecision 1ps;
  int checks=0;
  initial begin
    @(posedge clk);
    `CHECK(q==1, "program sees module NBA update in Reactive")
    `DONE("30_program")
  end
endprogram

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0; logic [7:0] q=0;
  always #5ns clk=~clk;
  always_ff @(posedge clk) q<=q+1'b1;
  stimulus test_program(clk,q);
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

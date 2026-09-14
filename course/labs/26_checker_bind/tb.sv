// 26_checker_bind | checkerをbindで後付けする
// 規格: 17 23.11
// 見るところ: RTL本体を編集せず、全インスタンスに検査器を追加する。
// 変更してみる: cellの+1を+2へ変更するとbindされた検査が失敗する。
`default_nettype none
`include "lab.svh"
checker count_check(input logic clk, rst_n, input logic [3:0] q);
  default clocking cb @(posedge clk); endclocking
  default disable iff (!rst_n);
  a_increment: assert property($past(rst_n) |-> q==4'($past(q)+1))
    else $fatal(1,"BIND_FAILURE %m");
endchecker
module counter_cell(input wire logic clk,rst_n, output logic [3:0] q);
  timeunit 1ns; timeprecision 1ps;
  always_ff @(posedge clk or negedge rst_n) if(!rst_n) q<=0; else q<=q+1'b1;
endmodule
bind counter_cell count_check attached(clk,rst_n,q);

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,rst_n=0; wire [3:0] q0,q1;
  always #5ns clk=~clk;
  counter_cell c0(.*,.q(q0)); counter_cell c1(.*,.q(q1));
  initial begin
    repeat(2) @(negedge clk); rst_n=1;
    repeat(5) @(negedge clk);
    `CHECK(q0==5 && q1==5, "two bound DUT instances advanced")
    `DONE("26_checker_bind")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

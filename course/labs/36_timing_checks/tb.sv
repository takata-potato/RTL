// 36_timing_checks | setup/hold・幅・周期を検査する
// 規格: 31
// 見るところ: タイミングチェックはsetup/hold違反を通知する。論理値の正しさとは別の検査。
// 変更してみる: ARGS=+VIOLATEでdataをクロックの1ns前へ寄せる。
`default_nettype none
`include "lab.svh"
module timing_cell(input wire clk,d, output reg q=0, output reg notifier=0);
  timeunit 1ns; timeprecision 1ps;
  always @(posedge clk) q<=d;
  specify
    $setup(d, posedge clk, 2, notifier);
    $hold(posedge clk, d, 1, notifier);
    $width(posedge clk, 3, 0, notifier);
    $period(posedge clk, 8, notifier);
  endspecify
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,d=0; wire q,notifier; int notifications=0;
  timing_cell dut(.*);
  always @(notifier) if($time>0) notifications++;
  initial begin
    if($test$plusargs("VIOLATE")) begin #9ns; d=1; #1ns; end
    else begin #5ns; d=1; #5ns; end
    clk=1; #5ns; clk=0; #5ns;
    `CHECK(q===1'b1, "logical capture works")
    if($test$plusargs("VIOLATE")) `CHECK(notifications>0, "setup violation triggered notifier")
    else `CHECK(notifications==0, "legal trace has no timing violation")
    `DONE("36_timing_checks")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

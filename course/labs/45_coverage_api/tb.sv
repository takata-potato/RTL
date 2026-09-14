// 45_coverage_api | コードカバレッジAPI
// 規格: 40 20.14
// 見るところ: covergroupと別に、ツールが計測するtoggleカバレッジを問い合わせる。
// 変更してみる: -coverage allを外すと計測できない場合がある。NOCOVを100%と取り違えない。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  localparam int COV_CHECK=3, COV_HIER=11, COV_TOGGLE=23, COV_OK=1, COV_PARTIAL=2;
  bit clk=0; logic [3:0] q=0; int status,covered,maximum;
  always #1ns clk=~clk;
  always_ff @(posedge clk) q<=q+1'b1;
  initial begin
    status=$coverage_control(COV_CHECK,COV_TOGGLE,COV_HIER,tb);
    `CHECK(status==COV_OK || status==COV_PARTIAL, "coverage instrumentation is available")
    repeat(20) @(negedge clk);
    covered=$coverage_get(COV_TOGGLE,COV_HIER,tb);
    maximum=$coverage_get_max(COV_TOGGLE,COV_HIER,tb);
    $display("toggle hits=%0d maximum=%0d",covered,maximum);
    `CHECK(maximum>0 && covered>0 && covered<=maximum, "coverage values are meaningful")
    `DONE("45_coverage_api")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

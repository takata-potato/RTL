// 35_specify | specifyとパス遅延
// 規格: 30 11.11
// 見るところ: RTLの論理とセルの端子間遅延は別に記述できる。
// 変更してみる: ARGS=-maxdelaysで5nsへ変更し、ARGS="-maxdelays +EXPECTED_DELAY=5"で照合する。
`default_nettype none
`include "lab.svh"
module delayed_cell(input wire a, output wire y);
  timeunit 1ns; timeprecision 1ps;
  buf(y,a);
  specify
    specparam TPD=1:3:5;
    (a=>y)=TPD;
  endspecify
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0; wire y; realtime changed; int expected=3;
  delayed_cell dut(a,y);
  initial begin
    if($value$plusargs("EXPECTED_DELAY=%d",expected)) begin end
    #10ns; changed=$realtime; a=1;
    @(posedge y);
    `CHECK($realtime-changed==expected, "specify path delay")
    `DONE("35_specify")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

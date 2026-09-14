// 47_alias_ports | alias・非ANSIポート・interconnect
// 規格: 10.11 23.2 23.3 23.5 23.6 23.7 23.8
// 見るところ: aliasは代入でなく同じnetの別名。古い形式のポート宣言も読む。
// 変更してみる: aliasを双方向assignで真似すると意味が同じとは限らないことを検討する。
`default_nettype none
`include "lab.svh"
module old_style(a,y);
  timeunit 1ns; timeprecision 1ps;
  input [7:0] a;
  output [7:0] y;
  assign y=~a;
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wire [7:0] first,second; wire [7:0] result;
  alias first=second;
  assign first=8'ha5;
  old_style dut(second,result);
  initial begin
    #1ns;
    `CHECK(second==8'ha5 && result==8'h5a, "alias shares net; non-ANSI ports connect")
    `DONE("47_alias_ports")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

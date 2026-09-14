// 34_udp | UDPの真理値表と状態表
// 規格: 29
// 見るところ: 小さな部品を表で定義する。組合せUDPとposedgeで保持するUDPを比較する。
// 変更してみる: 表の0 ? : 0を消すと、該当入力が未定義のXになる。
`default_nettype none
`include "lab.svh"
primitive udp_and(y,a,b);
  output y; input a,b;
  table
    0 ? : 0;
    ? 0 : 0;
    1 1 : 1;
  endtable
endprimitive
primitive udp_ff(q,d,clk);
  output q; reg q; input d,clk;
  initial q=0;
  table
    0 (01) : ? : 0;
    1 (01) : ? : 1;
    ? (10) : ? : -;
    *  ?   : ? : -;
  endtable
endprimitive

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0,b=0,clk=0; wire y,q;
  udp_and u_and(y,a,b); udp_ff u_ff(q,a,clk);
  initial begin
    for(int i=0;i<4;i++) begin
      {a,b}=2'(i); #1ns; `CHECK(y===(a&b), "combinational UDP table")
    end
    clk=1; #1ns; `CHECK(q===1'b1, "sequential UDP captures at edge")
    clk=0; a=0; #1ns; `CHECK(q===1'b1, "UDP retains state")
    `DONE("34_udp")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

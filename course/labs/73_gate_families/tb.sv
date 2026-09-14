// 73_gate_families | 全ゲート系の真理値を比較する
// 規格: 28.4 28.5 28.6 28.10
// 見るところ: 全4入力組について各ゲートの論理式と比較し、三状態の有効極性も確認する。
// 変更してみる: bufif0とbufif1を入れ替え、enableの有効極性が逆になるのを確かめる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0,b=0,en=0;
  wire ya,yn,yo,yr,yx,ye,yi,t0,t1,n0,n1,low;
  and(ya,a,b); nand(yn,a,b); or(yo,a,b); nor(yr,a,b);
  xor(yx,a,b); xnor(ye,a,b); not(yi,a);
  bufif0(t0,a,en); bufif1(t1,a,en);
  notif0(n0,a,en); notif1(n1,a,en); pulldown(pull0) p0(low);
  initial begin
    for(int i=0;i<4;i++) begin
      {a,b}=2'(i); #1ns;
      `CHECK(ya===(a&b) && yn===~(a&b) && yo===(a|b) && yr===~(a|b), "AND/NAND/OR/NOR")
      `CHECK(yx===(a^b) && ye===~(a^b) && yi===~a, "XOR/XNOR/NOT")
    end
    `CHECK(t0===a && n0===~a && t1===1'bz && n1===1'bz && low===1'b0, "active-low tristate")
    en=1; #1ns; `CHECK(t1===a && n1===~a && t0===1'bz && n0===1'bz, "active-high tristate")
    `DONE("73_gate_families")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

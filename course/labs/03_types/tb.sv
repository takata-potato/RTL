// 03_types | 2値・4値・整数・実数・時間
// 規格: 6.1 6.2 6.3 6.4 6.5 6.8 6.9 6.11 6.12 6.13 6.20 6.22 6.23
// 見るところ: 宣言時の値、ビット幅、2値型への代入によるX/Z消失。
// 変更してみる: bit b4をlogicにするとXを保存する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic [3:0] l4;
  bit [3:0] b4;
  byte by; shortint si; int ii; longint li; integer iv; time ticks;
  real r; shortreal sr; realtime rt;
  initial begin
    `CHECK(l4 === 4'bxxxx && b4 === 4'b0000, "default initialization")
    l4 = 4'b1xz0; b4 = l4;
    `CHECK(b4 == 4'b1000 && $isunknown(l4), "2-state conversion discards X/Z")
    `CHECK($bits(by)==8 && $bits(si)==16 && $bits(ii)==32 && $bits(li)==64,
           "integer atom widths")
    `CHECK($bits(iv)==32 && $bits(ticks)==64, "integer and time widths")
    r = 1.75; sr = 0.5; rt = 2ns;
    `CHECK(int'(r)==2 && $rtoi(r)==1, "cast rounds; rtoi truncates")
    `DONE("03_types")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

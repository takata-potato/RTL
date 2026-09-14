// 32_gates | ゲートプリミティブと駆動強度
// 規格: 28.1 28.2 28.3 28.4 28.5 28.6 28.10 28.11 28.12 28.15 28.16
// 見るところ: 論理ゲートを直接インスタンス化し、三状態と強弱の解決を観察する。
// 変更してみる: strong0をweak0へ変えると同強度の競合がXになる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0,b=0,en=0; wire y_and,y_xor,line;
  and g_and(y_and,a,b); xor g_xor(y_xor,a,b);
  bufif1 (strong1,strong0) g_drive(line,a,en);
  pullup (weak1) g_pull(line);
  initial begin
    #1ns; `CHECK(line===1'b1, "undriven tri-state line is pulled high")
    en=1; #1ns; `CHECK(line===1'b0, "strong zero beats weak one")
    a=1; b=1; #1ns;
    `CHECK(y_and===1'b1 && y_xor===1'b0 && line===1'b1, "gate truth values")
    $display("resolved strength=%v",line);
    `DONE("32_gates")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

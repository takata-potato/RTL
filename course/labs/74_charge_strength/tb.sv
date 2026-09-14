// 74_charge_strength | 電荷保持・抵抗性スイッチ・net種類
// 規格: 6.6 6.9.2 28.7 28.8 28.9 28.11 28.12 28.13 28.14
// 見るところ: 接続が切れたtriregは電荷を保持する。triのZとは異なる。
// 変更してみる: triregをtriへ変えると切断後の値はZ。weakとstrongの組合せで%vを比べる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg source=1,en=1; wire src; assign src=source;
  trireg (small) small_cap; trireg (medium) medium_cap; trireg (large) large_cap;
  bufif1(small_cap,src,en); bufif1(medium_cap,src,en); bufif1(large_cap,src,en);
  supply0 ground; supply1 power;
  tri0 default_low; tri1 default_high;
  triand wired_and; trior wired_or;
  assign wired_and=1'b1; assign wired_and=1'b0;
  assign wired_or=1'b1; assign wired_or=1'b0;
  tri scalared [3:0] scalar_bus; tri vectored [3:0] vector_bus;
  assign scalar_bus=4'ha; assign vector_bus=4'h5;
  wire p,rn,rp,rc,t,rt,t0,rt0,rt1;
  pmos(p,src,!en); rnmos(rn,src,en); rpmos(rp,src,!en); rcmos(rc,src,en,!en);
  tran(t,src); rtran(rt,src); tranif0(t0,src,!en);
  rtranif0(rt0,src,!en); rtranif1(rt1,src,en);
  wire weak_line,open_zero,open_one;
  assign (weak1,weak0) weak_line=source;
  assign (highz0,strong1) open_zero=1'b0;
  assign (strong0,highz1) open_one=1'b1;
  initial begin
    #2ns;
    `CHECK({p,rn,rp,rc,t,rt,t0,rt0,rt1}===9'b111111111, "MOS and resistive switch paths")
    `CHECK({ground,power,default_low,default_high,wired_and,wired_or}===6'b010101, "net resolution families")
    `CHECK(scalar_bus==4'ha && vector_bus==4'h5 && open_zero===1'bz && open_one===1'bz, "advisory vector nets and highz strengths")
    en=0; #2ns;
    `CHECK({small_cap,medium_cap,large_cap}===3'b111, "trireg retains charge after disconnect")
    $display("charge: %v %v %v; weak=%v",small_cap,medium_cap,large_cap,weak_line);
    `DONE("74_charge_strength")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

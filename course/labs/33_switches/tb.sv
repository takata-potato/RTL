// 33_switches | MOS・双方向スイッチ・電荷
// 規格: 28.7 28.8 28.9 28.13 28.14 6.6
// 見るところ: スイッチは値を生成するのでなく、端子間を接続・切断する。
// 変更してみる: tranif1をrtranif1へ変え、%vで抵抗性スイッチの強度減衰を見る。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg en=0,source=1; wire left,bus,mos_out,cmos_out;
  assign left=source;
  tranif1 sw(bus,left,en);
  nmos nm(mos_out,left,en);
  cmos cm(cmos_out,left,en,!en);
  initial begin
    #1ns; `CHECK(bus===1'bz && mos_out===1'bz, "open switches disconnect")
    en=1; #1ns;
    `CHECK(bus===1'b1 && mos_out===1'b1 && cmos_out===1'b1, "closed switches conduct")
    source=0; #1ns; `CHECK(bus===1'b0, "connection passes subsequent changes")
    $display("switch strength=%v",bus);
    `DONE("33_switches")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

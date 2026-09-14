// 53_preprocessor_edges | 指令の作用範囲・暗黙の接続・行番号
// 規格: 22.3 22.5 22.9 22.10 22.11 22.12 22.14
// 見るところ: 未接続inputの既定駆動と、診断に出る論理ファイル名を操作する。
// 変更してみる: pull1をpull0へ変え、期待値も0にする。resetallはマクロのundefineallとは別。
`default_nettype none
`include "lab.svh"
`celldefine
module pin_cell(input wire pin, output wire y);
  timeunit 1ns; timeprecision 1ps;
  assign y=pin;
endmodule
`endcelldefine
`unconnected_drive pull1

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wire pulled;
  pin_cell u_pull(.pin(),.y(pulled));
  initial begin
    #1ns; `CHECK(pulled===1'b1, "unconnected input uses pull1 directive")
    `line 400 "logical_lesson.sv" 0
    $display("mapped source=%s:%0d",`__FILE__,`__LINE__);
    `DONE("53_preprocessor_edges")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire
`nounconnected_drive

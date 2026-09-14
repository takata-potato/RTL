// 37_sdf | SDFで遅延を後から差し替える
// 規格: 32
// 見るところ: 同じセルにSDFを適用すると、コード内の1nsが4nsへ置き換わる。
// 変更してみる: cell.sdfの4:4:4を6:6:6へ変え、期待値も6へ変更する。
`default_nettype none
`include "lab.svh"
module annotated_cell(input wire a, output wire y);
  timeunit 1ns; timeprecision 1ps;
  buf(y,a);
  specify (a=>y)=1; endspecify
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0; wire y; realtime changed;
  annotated_cell dut(a,y);
  initial begin
    $sdf_annotate("cell.sdf",dut);
    #10ns; changed=$realtime; a=1;
    @(posedge y);
    `CHECK($realtime-changed==4ns, "SDF overrides specify delay")
    `DONE("37_sdf")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

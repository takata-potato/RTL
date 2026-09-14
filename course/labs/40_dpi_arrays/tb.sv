// 40_dpi_arrays | DPIの配列・4値ベクトル・時間を進めるtask
// 規格: 35.5 35.6 35.8 35.9 H.8 H.11 H.12 I J
// 見るところ: C側で配列の添字範囲を調べ、4値を壊さずコピーし、SVのtaskへ制御を戻して待つ。
// 変更してみる: 配列の添字を[7:5]へ変え、Cが0始まりを仮定していないことを確かめる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  import "DPI-C" function int c_sum(input int data[]);
  import "DPI-C" function void c_copy4(input logic [7:0] a, output logic [7:0] b);
  import "DPI-C" context task c_wait(input int cycles, output int result);
  export "DPI-C" task sv_wait;
  task sv_wait(input int cycles, output int result); repeat(cycles) #1ns; result=cycles; endtask
  int data[3:5]; logic [7:0] copied; int elapsed;
  initial begin
    data='{10,20,30};
    `CHECK(c_sum(data)==60, "open array passed with original bounds")
    c_copy4(8'b10xz_0110,copied);
    `CHECK(copied===8'b10xz_0110, "aval/bval preserve all four states")
    c_wait(2,elapsed); `CHECK(elapsed==2 && $time==2, "DPI task yields into SV timing")
    `DONE("40_dpi_arrays")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

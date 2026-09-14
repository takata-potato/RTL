// 81_interconnect | interconnectとinoutの接続専用net
// 規格: 6.6.8 6.7 23.3 25
// 見るところ: interconnectは型を決めず接続だけを記述する。値を読むのは接続先の型付きnet。
// 変更してみる: interconnectを直接$displayへ渡すと使用制限に抵触する。接続先のsenseを表示する。
`default_nettype none
`include "lab.svh"
module source_endpoint(inout wire [7:0] bus); assign bus=8'ha5; endmodule
module sink_endpoint(inout wire [7:0] bus,output wire [7:0] sense); assign sense=bus; endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  interconnect link; // 幅と型は接続したnetから解決する
  wire [7:0] sense;
  source_endpoint source(link); sink_endpoint sink(link,sense);
  initial begin #1ns; `CHECK(sense==8'ha5, "typeless connection resolves through ports") `DONE("81_interconnect") end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 39_dpi | DPIでSVとCを往復する
// 規格: 35 6.14 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.9 H.10 I J
// 見るところ: 純粋なC関数、C→SVコールバック、Cが管理するハンドルを使う。
// 変更してみる: Cの加算を減算へ変えるとSVの自動照合が失敗する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  import "DPI-C" pure function int c_add(input int a,b);
  import "DPI-C" context function int c_roundtrip(input int a);
  import "DPI-C" function chandle c_create(input int value);
  import "DPI-C" function int c_read(input chandle handle);
  import "DPI-C" function void c_destroy(input chandle handle);
  export "DPI-C" function sv_double;
  function int sv_double(input int value); return value*2; endfunction
  chandle handle;
  initial begin
    `CHECK(c_add(4,5)==9, "SV calls pure C function")
    `CHECK(c_roundtrip(9)==18, "context C function calls exported SV function")
    handle=c_create(42); `CHECK(handle!=null && c_read(handle)==42, "opaque C-owned handle")
    c_destroy(handle); handle=null;
    `DONE("39_dpi")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

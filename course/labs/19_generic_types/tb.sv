// 19_generic_types | 型パラメーターとinterface class
// 規格: 6.25 8.25 8.26 8.27 8.28 13.8
// 見るところ: 同じ入れ物にint型とbyte型を渡す。interface classはメソッドの契約になる。
// 変更してみる: Holder#(byte)へ300を入れて幅による切詰めを観察する。
`default_nettype none
`include "lab.svh"
interface class Readable;
  pure virtual function int read();
endclass
class Holder #(type T=int) implements Readable;
  T value;
  function new(T value); this.value=value; endfunction
  virtual function int read(); return int'(value); endfunction
endclass
typedef class Later;
class Earlier; Later peer; endclass
class Later; Earlier peer; endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Holder #(int) wide; Holder #(byte) narrow; Readable api;
  initial begin
    wide=new(7); narrow=new(3); api=wide;
    `CHECK($bits(wide.value)==32 && $bits(narrow.value)==8, "type parameter specializes class")
    `CHECK(api.read()==7, "interface class dispatch")
    `DONE("19_generic_types")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

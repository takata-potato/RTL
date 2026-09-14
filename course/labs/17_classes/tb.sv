// 17_classes | class・ハンドル・コピー
// 規格: 8.1 8.2 8.3 8.4 8.5 8.6 8.7 8.8 8.9 8.10 8.11 8.12 8.19 8.29
// 見るところ: ハンドル代入は同じオブジェクトを指し、new 元ハンドルは浅いコピー。
// 変更してみる: childもコピーしたいときに、浅いコピーと自作deep copyの差を考える。
`default_nettype none
`include "lab.svh"
class Item;
  static int created=0;
  int value;
  function new(int value=0); this.value=value; created++; endfunction
  static function int count(); return created; endfunction
endclass
class Box;
  Item child;
  int tag;
  function new(); child=new(5); tag=1; endfunction
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Item original, alias_handle, copied; Box one,two;
  initial begin
    `CHECK(original==null, "unconstructed handle is null")
    original=new(7); alias_handle=original; alias_handle.value=8;
    `CHECK(original.value==8 && original==alias_handle, "handle assignment aliases")
    copied=new original; copied.value=9;
    `CHECK(original.value==8 && copied.value==9, "shallow copy duplicates scalar fields")
    one=new(); two=new one; two.child.value=20;
    `CHECK(one.child.value==20 && one.child==two.child, "nested handle remains shared")
    `CHECK(Item::count()==2, "copy construction does not call constructor")
    `DONE("17_classes")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

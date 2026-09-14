// 18_inheritance | 継承・多態・アクセス制御
// 規格: 8.13 8.14 8.15 8.16 8.17 8.18 8.20 8.21 8.22 8.23 8.24
// 見るところ: 基底型ハンドルからvirtualメソッドを呼ぶと実体の実装が選ばれる。
// 変更してみる: 基底クラスのvirtualを外せる非abstract例を作り、メソッド選択を比較する。
`default_nettype none
`include "lab.svh"
virtual class Shape;
  protected int scale;
  function new(int scale=1); this.scale=scale; endfunction
  pure virtual function int area();
endclass
class Square extends Shape;
  local int side;
  function new(int side); super.new(1); this.side=side; endfunction
  extern virtual function int area();
endclass
function int Square::area(); return side*side*scale; endfunction
class Other extends Shape;
  virtual function int area(); return 0; endfunction
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Shape base; Square sq,again; Other wrong;
  initial begin
    sq=new(4); base=sq;
    `CHECK(base.area()==16, "virtual dispatch through base handle")
    `CHECK($cast(again,base) && again==sq, "successful downcast")
    `CHECK(!$cast(wrong,base), "incompatible downcast is rejected")
    `DONE("18_inheritance")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

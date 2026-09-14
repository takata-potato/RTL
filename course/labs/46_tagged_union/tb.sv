// 46_tagged_union | tagged unionとパターン照合
// 規格: 7.3 11.9 12.6
// 見るところ: 値と種類を一緒に持ち、タグが一致したときだけ中身を読む。
// 変更してみる: SomeをNoneへ切り替え、不適切なメンバー読取りを避ける仕組みを見る。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  typedef union tagged {void None; int Some;} option_t;
  option_t opt; int value;
  function automatic int unwrap(option_t x);
    case(x) matches
      tagged Some .n: return n;
      tagged None: return -1;
    endcase
  endfunction
  initial begin
    opt=tagged Some 42; value=unwrap(opt);
    `CHECK(value==42, "match binds tagged payload")
    opt=tagged None;
    `CHECK(unwrap(opt)==-1, "void tagged variant")
    `DONE("46_tagged_union")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

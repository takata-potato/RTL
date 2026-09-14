// 09_expressions | 幅・符号・演算子・ストリーミング
// 規格: 11 6.24
// 見るところ: 同じビット列でも符号型と切り出しによって右シフトが変わる。
// 変更してみる: 8bitの切り出しに$signedを付けて符号付きへ戻す。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic signed [7:0] s; logic [15:0] word,swapped; logic [7:0] slice;
  let is_small(x) = x inside {[0:7]};
  initial begin
    s=-4; word=16'h1234; slice=word[4 +: 8]; swapped={<<8{word}};
    `CHECK((s>>>1)==-2 && (s[7:0]>>>1)==8'h7e, "signedness of part select")
    `CHECK(swapped==16'h3412 && slice==8'h23, "stream and indexed select")
    `CHECK({2{4'ha}}==8'haa && (&4'b1111) && (^4'b1011), "replication and reduction")
    `CHECK(is_small(7) && !is_small(8), "let expression and inside")
    `CHECK((4'b0x01 == 4'b0001)===1'bx && !(4'b0x01 === 4'b0001), "logical vs case equality")
    `CHECK((4'b1010 ==? 4'b1?1?)===1'b1, "wildcard equality uses RHS wildcard bits")
    `DONE("09_expressions")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

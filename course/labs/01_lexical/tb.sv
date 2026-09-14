// 01_lexical | 文字・数値・識別子を読む
// 規格: 5 22.13
// 見るところ: 同じ値の4通りの書き方と、空白で終わるエスケープ識別子。
// 変更してみる: 8'h2a を 8'h2b に変えると最初の照合が失敗する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  (* lesson = "lexical" *) logic [7:0] \signal.with.dot ; // 最後の空白が必要
  initial begin
    \signal.with.dot = 8'h2a;
    `CHECK(8'b0010_1010 == 8'o52 && 8'd42 == 8'h2a, "four bases = 42")
    `CHECK(\signal.with.dot == 42, "escaped identifier")
    `CHECK($bits(8'shff) == 8 && $signed(8'shff) == -1, "width and signed literal")
    $display("text=\"SV\"\nfile=%s line=%0d", `__FILE__, `__LINE__);
    #1step;
    `CHECK($realtime == 0.001, "1step = 1ps at this global precision")
    `DONE("01_lexical")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

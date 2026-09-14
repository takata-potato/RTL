// 06_arrays | 配列の向きと寸法
// 規格: 5.11 7.4 7.6 7.7 7.11 20.7
// 見るところ: 変数名の左はpacked、右はunpacked。昇順・降順でleft/rightが変わる。
// 変更してみる: unpackedの[2:4]を[4:2]にし、left/rightとlow/highを比較する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic [1:0][7:0] packed_words;
  int a [2:4];
  int matrix [0:1][0:2];
  initial begin
    packed_words = 16'h1234;
    foreach(a[i]) a[i] = i*10;
    foreach(matrix[i,j]) matrix[i][j] = i*10+j;
    `CHECK(packed_words[1]==8'h12 && packed_words[0]==8'h34, "packed bit layout")
    `CHECK($left(a)==2 && $right(a)==4 && $size(a)==3, "unpacked bounds")
    // int自身の32bitベクトル分も1次元。unpacked 2 + packed 1 = 合計3。
    `CHECK($dimensions(matrix)==3 && $unpacked_dimensions(matrix)==2, "dimension queries include int bits")
    `CHECK(matrix[1][2]==12 && a[3]==30, "foreach uses actual indices")
    `DONE("06_arrays")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

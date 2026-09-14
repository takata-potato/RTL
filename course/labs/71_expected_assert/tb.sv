// 71_expected_assert | 失敗を学ぶ：assertが動いたことを確認
// 規格: 16.3 20.10
// 見るところ: 終了コード0だけでなく、実際に照合を行っていることを確かめる。
// 変更してみる: observedを8にすると意図した失敗が起きず、ランナー側が失敗を報告する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int observed=7;
  initial begin
    assert(observed==8) else $fatal(1,"EXPECTED_ASSERT_FAILURE got=%0d expected=8",observed);
    $display("UNEXPECTED_SUCCESS"); $finish;
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

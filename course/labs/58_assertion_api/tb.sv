// 58_assertion_api | CからSVAの成功を観測する
// 規格: 39 M
// 見るところ: アサーション名のハンドルを取得し、nonvacuous成功のcallbackを登録する。
// 変更してみる: readyを0にして失敗callbackへ変更する。API初期化はstart-of-simulationと同じとは限らない。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,ready=1;
  always #5ns clk=~clk;
  a_ready: assert property(@(posedge clk) ready) else $fatal(1,"SVA_FAILURE ready");
  initial begin
    repeat(4) @(negedge clk);
    `CHECK($lab_assertion_count()>=1, "C received nonvacuous assertion success")
    `DONE("58_assertion_api")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 44_distributions | 古典的な確率分布関数
// 規格: 20.15 N
// 見るところ: seedを更新する古典RNGと、SystemVerilogのスレッドRNGを区別する。
// 変更してみる: seedを固定して2回実行する。平均の推定にはサンプル数が必要で、1回の値で分布を評価しない。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  integer seed=123,again=123; int die,copy,n,e,p,c,t,k;
  initial begin
    repeat(10) begin
      die=$dist_uniform(seed,1,6); copy=$dist_uniform(again,1,6);
      `CHECK(die>=1 && die<=6 && die==copy, "uniform bounds and deterministic seed update")
    end
    n=$dist_normal(seed,100,10); e=$dist_exponential(seed,10);
    p=$dist_poisson(seed,10); c=$dist_chi_square(seed,4);
    t=$dist_t(seed,4); k=$dist_erlang(seed,2,10);
    $display("normal=%0d exp=%0d poisson=%0d chi=%0d t=%0d erlang=%0d",n,e,p,c,t,k);
    `DONE("44_distributions")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

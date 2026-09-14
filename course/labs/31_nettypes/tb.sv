// 31_nettypes | netの解決関数と複数ドライバー
// 規格: 6.6 6.7 10.3 23.3
// 見るところ: 標準netは4値と強さを解決、ユーザー定義nettypeは独自の解決関数を使える。
// 変更してみる: sum解決を最大値へ変更して複数アナログ値の合成を試す。
`default_nettype none
`include "lab.svh"
package net_pkg;
  function automatic real sum_drivers(input real drivers[]);
    real total=0.0;
    foreach(drivers[i]) total+=drivers[i];
    return total;
  endfunction
  nettype real real_sum with sum_drivers;
endpackage

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  wand wired_and; wor wired_or;
  assign wired_and=1'b1; assign wired_and=1'b0;
  assign wired_or=1'b1; assign wired_or=1'b0;
  import net_pkg::real_sum;
  real_sum voltage;
  assign voltage=1.25; assign voltage=2.5;
  initial begin
    #1ns;
    `CHECK(wired_and===1'b0 && wired_or===1'b1, "built-in wired resolution")
    `CHECK(voltage==3.75, "user-defined net resolution")
    `DONE("31_nettypes")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

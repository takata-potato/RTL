// 13_lifetime | スコープとstatic/automatic
// 規格: 3.13 6.21 8.9 23.9 26.3
// 見るところ: staticローカルは呼出し間で残り、automaticローカルは毎回初期化される。
// 変更してみる: static関数をautomaticへ変えてカウンターが保存されなくなるのを確かめる。
`default_nettype none
`include "lab.svh"
package settings; parameter int VALUE=10; endpackage

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  function static int persistent(); int n=0; return ++n; endfunction
  function automatic int fresh(); int n=0; return ++n; endfunction
  int first,second;
  initial begin
    first=persistent(); second=persistent();
    `CHECK(first==1 && second==2, "static local survives calls")
    `CHECK(fresh()==1 && fresh()==1, "automatic local is reinitialized")
    begin : local_scope
      int VALUE; VALUE=20;
      `CHECK(VALUE==20 && settings::VALUE==10, "qualified scope lookup")
    end
    `DONE("13_lifetime")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 14_scheduling | イベント領域とNBAを目で見る
// 規格: 4 9.4 10.4 21.2
// 見るところ: #0はNBAの完了待ちにならない。値を表示する領域で見える値が変わる。
// 変更してみる: q<=1をq=1に変えるとActiveから1が見える。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int q=0, sampled=0, source=4;
  initial begin
    q<=1;
    $display("ACTIVE q=%0d",q);
    `CHECK(q==0, "NBA has not executed in Active")
    #0; $display("INACTIVE q=%0d",q);
    `CHECK(q==0, "#0 is before NBA, not after it")
    $strobe("POSTPONED q=%0d",q);
    #1ns; `CHECK(q==1, "next time slot sees the NBA update")
    sampled <= #2ns source; // 右辺を今評価し、2ns後にその値を代入
    source=9;
    #3ns; `CHECK(sampled==4, "intra-assignment delay sampled old RHS")
    `DONE("14_scheduling")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

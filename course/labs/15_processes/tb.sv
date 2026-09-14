// 15_processes | fork・join・プロセス制御
// 規格: 9.3 9.4 9.5 9.6 9.7
// 見るところ: 並列処理の待ち方と、タイムアウト時に子プロセスを止める方法。
// 変更してみる: disable forkを外すと遅い枝も完了する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int completed=0; bit slow_done=0; process child;
  initial begin
    fork
      begin #1ns; completed++; end
      begin #2ns; completed++; end
    join
    `CHECK(completed==2, "join waits for all branches")
    fork
      #1ns;
      begin #10ns; slow_done=1; end
    join_any
    disable fork;
    #11ns; `CHECK(!slow_done, "disable fork cancels remaining descendants")
    fork
      begin child=process::self(); #2ns; completed++; end
    join_none
    wait fork;
    `CHECK(child.status()==process::FINISHED && completed==3, "join_none + wait fork")
    `DONE("15_processes")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

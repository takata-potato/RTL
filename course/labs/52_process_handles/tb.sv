// 52_process_handles | processハンドルで停止・再開・kill
// 規格: 9.7
// 見るところ: 子スレッドをハンドルで操作する。killはそのプロセスの将来の仕事を止める。
// 変更してみる: killの代わりにawaitを使うと、完了を待ってフラグが1になる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  process worker; bit completed=0;
  initial begin
    fork begin worker=process::self(); #10ns; completed=1; end join_none
    wait(worker!=null);
    #1ns;
    `CHECK(worker.status()==process::WAITING, "child is waiting on delay")
    worker.suspend(); `CHECK(worker.status()==process::SUSPENDED, "suspend changes status")
    worker.resume(); worker.kill();
    `CHECK(worker.status()==process::KILLED, "kill terminates process")
    #15ns; `CHECK(!completed, "killed process cannot finish its delayed work")
    `DONE("52_process_handles")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

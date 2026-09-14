// 16_communication | event・mailbox・semaphore
// 規格: 6.17 15
// 見るところ: キューで値を渡し、セマフォで共有資源を保護し、イベントで通知する。
// 変更してみる: wait(done.triggered)と@doneで、通知前後の開始順の影響を調べる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  mailbox #(int) channel=new(1);
  semaphore mutex=new(1);
  event done;
  int received=0, total=0;
  task automatic worker();
    mutex.get(1); #1ns; total++; mutex.put(1);
  endtask
  initial begin
    fork
      begin channel.put(42); ->>done; end
      begin wait(done.triggered); channel.get(received); end
      worker(); worker();
    join
    `CHECK(received==42 && channel.num()==0, "typed mailbox and event")
    `CHECK(total==2 && mutex.try_get(1), "semaphore serializes access")
    mutex.put(1);
    `DONE("16_communication")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

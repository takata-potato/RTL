// 78_interface_broadcast | interfaceのextern forkjoin task
// 規格: 25.7.4
// 見るところ: interfaceの1回のtask呼出しで、接続された2つのmoduleの実装を並列に実行する。
// 変更してみる: 片方のsubscriberを取り除くとdone=01。共有の同一変数への競合書込みを避けて各bitを分ける。
`default_nettype none
`include "lab.svh"
interface broadcast_if;
  bit [1:0] done=0;
  extern forkjoin task notify();
  modport receiver(ref done,export notify);
endinterface
module subscriber #(parameter int ID=0)(broadcast_if.receiver bus);
  task bus.notify(); #1ns; bus.done[ID]=1; endtask
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  broadcast_if bus();
  subscriber #(.ID(0)) s0(bus); subscriber #(.ID(1)) s1(bus);
  initial begin
    #1ns; bus.notify();
    `CHECK(bus.done==2'b11, "one interface call joined both module task implementations")
    `DONE("78_interface_broadcast")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

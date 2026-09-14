// 76_control_edges | unique0・priority・casex・event順序・final
// 規格: 9 12 15.5
// 見るところ: 値の分岐とイベント順序を別々に検査する。finalは終了時の表示に使う。
// 変更してみる: イベントの順を逆にしてORDER_FAILURE、casexをcaseにして一致しないことを確認する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  event first,second; int value=0; bit ordered=0; int pulses=0;
  final $display("FINAL pulses=%0d",pulses);
  initial begin : pulse_thread
    forever begin #1ns; pulses++; end
  end
  initial begin
    unique0 case(2) 0:value=10; 1:value=20; endcase // 0個一致はunique0では許される
    `CHECK(value==0, "unique0 permits no matching arm")
    priority if(1) value=1; else if(1) value=2;
    `CHECK(value==1, "priority selects first true branch")
    casex(2'bx1) 2'b01:value=3; default:value=0; endcase
    `CHECK(value==3, "casex masks unknown input bit")
    fork
      begin wait_order(first,second) ordered=1; else $fatal(1,"ORDER_FAILURE"); end
      begin #2ns; ->first; #2ns; ->second; end
    join
    disable pulse_thread;
    `CHECK(ordered && pulses>=3, "ordered event synchronization")
    `DONE("76_control_edges")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

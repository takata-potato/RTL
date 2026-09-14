// 56_stochastic_pla | キュー解析とPLAシステムタスク
// 規格: 20.16 20.17
// 見るところ: 古典的な待ち行列解析タスクと、配列で表す論理面を試す。
// 変更してみる: 2件追加しFIFO/LIFOのqueue_typeを1/2へ切り替える。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  integer status,job,info; logic [0:1] rows[0:1]; logic [0:1] selected,result;
  initial begin
    $q_initialize(1,1,4,status); `CHECK(status==0, "initialize FIFO analysis queue")
    $q_add(1,7,42,status); `CHECK(status==0, "enqueue analysis item")
    #2ns; $q_remove(1,job,info,status);
    `CHECK(status==0 && job==7 && info==42, "dequeue job and inform id")
    rows[0]=2'b01; rows[1]=2'b10; selected=2'b11;
    $async$or$array(rows,selected,result);
    #1ns; `CHECK(result===2'b11, "PLA OR array combines selected rows")
    `DONE("56_stochastic_pla")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

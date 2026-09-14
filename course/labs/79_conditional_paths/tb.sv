// 79_conditional_paths | 条件付きパス・edge・パルス指令
// 規格: 30.4 30.5 30.6 30.7 31.5
// 見るところ: modeによってパス遅延を選び、条件に合わないときのifnoneを使う。
// 変更してみる: 入力パルスを遅延より短くして、パルス指令によるX発生時刻の違いを波形で確認する。
`default_nettype none
`include "lab.svh"
module mode_delay(input wire a,mode, output wire y,z);
  buf(y,a); buf(z,a);
  reg notifier=0;
  specify
    if(mode) (a=>y)=2;
    ifnone (a=>y)=4;
    (a=>z)=2;
    pulsestyle_ondetect y;
    pulsestyle_onevent z;
    showcancelled y;
    noshowcancelled z;
    $width(edge [01] a,1,0,notifier);
  endspecify
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  reg a=0,mode=1; wire y,z; realtime start_time;
  mode_delay dut(.*);
  initial begin
    #10ns; start_time=$realtime; a=1; @(posedge y);
    `CHECK($realtime-start_time==2ns, "conditional path delay")
    #10ns; mode=0; #1ns; start_time=$realtime; a=0; @(negedge y);
    `CHECK($realtime-start_time==4ns, "ifnone fallback delay")
    `DONE("79_conditional_paths")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

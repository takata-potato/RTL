// 57_vpi_callbacks | VPI callback・値変更・シミュレーション時刻
// 規格: 36.8 36.10 37.18 37.72 37.73 37.74 37.81 38
// 見るところ: VPIは信号の変化をコールバックで受け取れる。時刻と値をCから表示する。
// 変更してみる: cbValueChangeをcbReadOnlySynchへ変える場合に必要な登録時刻・再登録を規格で確認する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic [31:0] target=0;
  initial begin
    #2ns; target=1; #2ns; target=2; #2ns;
    `CHECK($lab_callback_count()>=2, "VPI value-change callbacks executed")
    `DONE("57_vpi_callbacks")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

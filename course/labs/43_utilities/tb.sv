// 43_utilities | 便利なシステム関数
// 規格: 20.1 20.2 20.3 20.4 20.5 20.6 20.8 20.9 20.10 20.11 20.18
// 見るところ: 幅・ビット数・数学関数・表示形式を一度に試す。
// 変更してみる: $clog2(1)の0を配列幅へ使うとどうなるか、前のsyntax_demoと比較する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  real original,restored;
  initial begin
    $timeformat(-9,3," ns",10); $printtimescale(tb);
    `CHECK($countones(4'b1011)==3 && $countbits(4'b1xz0,1'bx,1'bz)==2, "bit counting")
    `CHECK($onehot(4'b0100) && $onehot0(4'b0000) && !$onehot(4'b0011), "one-hot checks")
    `CHECK($clog2(1)==0 && $clog2(5)==3, "ceiling log2 boundary")
    original=1.25; restored=$bitstoreal($realtobits(original));
    `CHECK(restored==original && $sqrt(16.0)==4.0 && $pow(2.0,3.0)==8.0, "conversion and math")
    #1.25ns; $display("time=%t realtime=%0.3f",$realtime,$realtime);
    `CHECK($realtime==1.25, "fractional time")
    $info("severity example: informational message");
    `DONE("43_utilities")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 50_coverage_bins | 遷移bin・条件・除外bin
// 規格: 19.4 19.5 19.6 19.7 19.8 19.10 19.11
// 見るところ: 値だけでなく0→1→2という遷移も測る。除外と違反を区別する。
// 変更してみる: enable=0でsampleしてiffによる除外を試す。3を入力するとillegal_binsの診断になる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  covergroup cg with function sample(int value,bit enabled);
    option.per_instance=1;
    values: coverpoint value iff(enabled) {
      bins legal_values[]={0,1,2};
      illegal_bins invalid={3};
      ignore_bins outside_range={[4:100]};
    }
    transitions: coverpoint value iff(enabled) {bins path=(0=>1=>2);}
  endgroup
  cg cov=new;
  initial begin
    cov.set_inst_name("transition_lesson");
    cov.sample(0,1); cov.sample(1,1); cov.sample(2,1);
    `CHECK(cov.get_inst_coverage()==100.0, "value and transition bins reached")
    cov.stop(); cov.sample(3,1); cov.start(); // stop中のサンプルは計測しない
    `DONE("50_coverage_bins")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

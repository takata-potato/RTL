// 22_coverage | 何を試したかをcovergroupで測る
// 規格: 19 20.14
// 見るところ: assertは正しさ、covergroupは刺激の到達状況を測る。
// 変更してみる: 最後のsampleを省いて未到達binを作る。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit op, length;
  covergroup cg with function sample(bit o, bit l);
    option.per_instance=1;
    cp_op: coverpoint o {bins zero={0}; bins one={1};}
    cp_len: coverpoint l {bins short_len={0}; bins long_len={1};}
    pair: cross cp_op,cp_len;
  endgroup
  cg cov=new;
  initial begin
    for(int o=0;o<2;o++) for(int l=0;l<2;l++) cov.sample(1'(o),1'(l));
    $display("coverage=%0.2f%%",cov.get_inst_coverage());
    `CHECK(cov.get_inst_coverage()==100.0, "all four cross bins hit")
    `DONE("22_coverage")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

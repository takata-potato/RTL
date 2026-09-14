// 80_coverage_selection | wildcard binとcrossの選択
// 規格: 19.5 19.6
// 見るところ: bitパターンをまとめるbinと、crossの一部だけを対象にするbinを使う。
// 変更してみる: binsof値集合のintersectを変え、対象になる組合せを手書きの表で確かめる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  covergroup cg with function sample(bit [1:0] value,bit mode);
    option.per_instance=1;
    pattern: coverpoint value {wildcard bins low={2'b0?}; wildcard bins high={2'b1?};}
    cp: coverpoint value {bins zero={0}; bins one={1}; ignore_bins other={2,3};}
    mp: coverpoint mode;
    selected: cross cp,mp {bins chosen=binsof(cp) intersect {0,1};}
  endgroup
  cg cov=new;
  initial begin
    cov.sample(0,0); cov.sample(0,1); cov.sample(1,0); cov.sample(1,1); cov.sample(2,0);
    `CHECK(cov.get_inst_coverage()==100.0, "wildcard bins and selected cross")
    `DONE("80_coverage_selection")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

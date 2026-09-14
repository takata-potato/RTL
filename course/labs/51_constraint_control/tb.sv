// 51_constraint_control | 制約の継承・soft・unique・外部定義
// 規格: 18.5 18.6 18.7 18.8 18.9 18.10
// 見るところ: softは既定値、hardは必須条件。状態固定時にも制約の整合性を検査できる。
// 変更してみる: softを外してhardにするとlimit=4のinline制約と矛盾する。
`default_nettype none
`include "lab.svh"
class BaseConfig;
  rand int limit;
  constraint defaults {soft limit==2;}
endclass
class Config extends BaseConfig;
  rand int items[4];
  extern constraint limits;
  constraint distinct {unique {items}; foreach(items[i]) items[i] inside {[0:7]};}
endclass
constraint Config::limits {limit inside {[1:4]}; if(limit==4) items[0]<4;}

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Config cfg=new;
  initial begin
    `CHECK(cfg.randomize() with {limit==4;}, "inline hard constraint overrides soft default")
    `CHECK(cfg.limit==4 && cfg.items[0]<4, "extern and conditional constraints")
    foreach(cfg.items[i]) foreach(cfg.items[j])
      if(i!=j) `CHECK(cfg.items[i]!=cfg.items[j], "unique array elements")
    cfg.limit.rand_mode(0);
    cfg.limit=9;
    `CHECK(!cfg.randomize(null), "randomize(null) checks current state without changing it")
    `DONE("51_constraint_control")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

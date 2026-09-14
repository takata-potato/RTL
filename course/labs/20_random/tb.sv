// 20_random | 制約付き乱数の基本
// 規格: 18.1 18.2 18.3 18.4 18.5 18.6 18.7 18.8 18.9 18.11 18.12
// 見るところ: ランダム値の正しさは、具体的な乱数列ではなく制約を満たすかで検査する。
// 変更してみる: inlineをlen==9に変えるとrandomize()が0を返す。戻り値を無視しない。
`default_nettype none
`include "lab.svh"
class Packet;
  rand bit [3:0] addr;
  rand int unsigned len;
  rand byte unsigned payload[];
  randc bit [1:0] slot;
  constraint legal {
    len inside {[1:4]}; addr[0]==0;
    payload.size()==len;
    foreach(payload[i]) payload[i] inside {[i:15]};
    addr dist {0:=2, [2:14]:=1};
    solve len before addr;
    soft len==2;
  }
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Packet p=new; bit [3:0] seen=0; int n;
  initial begin
    repeat(4) begin
      `CHECK(p.randomize() with {len==3;}, "randomization succeeds")
      `CHECK(p.len==3 && !p.addr[0] && p.payload.size()==3, "hard and inline constraints")
      foreach(p.payload[i]) `CHECK(p.payload[i]>=i && p.payload[i]<=15, "foreach constraint")
      seen[p.slot]=1;
    end
    `CHECK(seen=='1, "randc visits four values before repeating")
    `CHECK(!p.randomize() with {len==9;}, "unsatisfiable constraint returns zero")
    `CHECK(std::randomize(n) with {n inside {[4:8]};}, "scope randomization")
    p.addr.rand_mode(0); p.legal.constraint_mode(0);
    `CHECK(!p.addr.rand_mode() && !p.legal.constraint_mode(), "random and constraint switches")
    `DONE("20_random")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 72_integrated_fifo | 総合演習：FIFOをRTL/TB/乱数/SVAで検証
// 規格: 4 7 8 14 15 16 18 19 21 23 25 26 27
// 見るところ: 深さ4のFIFOへpush/popを送り、キューを正解モデルとして毎回比較する。
// 変更してみる: ARGS=+CYCLES=1000で長く回す。RTLのread pointer更新を壊すとscoreboardが検出する。
`default_nettype none
`include "lab.svh"
class Transaction;
  rand bit push,pop;
  rand byte unsigned data;
  constraint activity {push dist {0:=1,1:=2}; pop dist {0:=1,1:=2};}
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  localparam int DEPTH=4;
  bit clk=0,rst_n=0,push=0,pop=0;
  logic [7:0] wdata=0; wire [7:0] rdata;
  wire full,empty; wire [$clog2(DEPTH+1)-1:0] count;
  byte unsigned model[$]; Transaction item=new;
  int cycles=200; int saw_full=0,saw_empty=0,saw_both=0;
  always #5ns clk=~clk;
  fifo #(.DEPTH(DEPTH)) dut(.*);
  a_range: assert property(@(posedge clk) disable iff(!rst_n) count<=DEPTH)
    else $fatal(1,"FIFO_ASSERT_COUNT");
  covergroup activity with function sample(bit p,bit r);
    option.per_instance=1;
    push_cp: coverpoint p;
    pop_cp: coverpoint r;
    pair: cross push_cp,pop_cp;
  endgroup
  activity cov=new;
  task automatic step(input bit do_push,do_pop,input byte unsigned data);
    bit accept_push,accept_pop; byte unsigned expected;
    @(negedge clk); push=do_push; pop=do_pop; wdata=data;
    accept_push=push && model.size()<DEPTH;
    accept_pop=pop && model.size()>0;
    if(accept_pop) begin
      expected=model.pop_front();
      `CHECK(rdata===expected, "FIFO oldest value before read edge")
    end
    if(accept_push) model.push_back(data);
    cov.sample(push,pop);
    @(posedge clk); #1ns;
    `CHECK(count==model.size() && empty==(model.size()==0) && full==(model.size()==DEPTH),
           "registered FIFO state matches queue model")
    if(full) saw_full++; if(empty) saw_empty++; if(accept_push && accept_pop) saw_both++;
  endtask
  initial begin
    if($value$plusargs("CYCLES=%d",cycles)) begin end
    if(cycles<1 || cycles>5000 || $isunknown(cycles)) $fatal(1,"CYCLES must be 1..5000");
    repeat(2) @(negedge clk); rst_n=1;
    step(0,0,0); step(0,1,0); // idleとempty時pop
    repeat(DEPTH) step(1,0,8'ha5); // fullへ
    step(1,1,8'h11); // fullなのでpush拒否、popだけ受理
    step(1,1,8'h22); // 両方受理
    repeat(DEPTH) step(0,1,0);
    repeat(cycles) begin `CHECK(item.randomize(), "transaction randomization") step(item.push,item.pop,item.data); end
    while(model.size()>0) step(0,1,0);
    `CHECK(saw_full>0 && saw_empty>0 && saw_both>0 && cov.get_inst_coverage()==100.0,
           "directed boundary cases and all control combinations covered")
    $display("cycles=%0d full=%0d empty=%0d simultaneous=%0d",cycles,saw_full,saw_empty,saw_both);
    `DONE("72_integrated_fifo")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

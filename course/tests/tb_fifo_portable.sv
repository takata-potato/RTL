// 総合演習72のRTLを、class/SVA非対応の検査器でも独立に確認するTB。
// 正解モデルは「pop時に配列をずらす」方式。DUTの循環ポインターを複製しない。
`default_nettype none
module tb;
  timeunit 1ns; timeprecision 1ps;
  parameter int DEPTH=4;
  bit clk=0,rst_n=0,push=0,pop=0;
  logic [7:0] wdata=0;
  wire [7:0] rdata;
  wire full,empty;
  wire [$clog2(DEPTH+1)-1:0] count;
  byte unsigned expected_data[DEPTH];
  int used=0,checks=0,seed=91;
  fifo #(.DEPTH(DEPTH)) dut(.*);
  always #5ns clk=~clk;
  task automatic step(input bit p,r,input byte unsigned value);
    bit take_push,take_pop;
    @(negedge clk);
    push=p; pop=r; wdata=value;
    take_push=p && used<DEPTH;
    take_pop=r && used>0;
    if(take_pop) begin
      if(rdata!==expected_data[0]) $fatal(1,"FIFO_DATA_FAIL");
      for(int i=1;i<used;i++) expected_data[i-1]=expected_data[i];
      used--;
    end
    if(take_push) begin expected_data[used]=value; used++; end
    @(posedge clk); #1ns;
    if(count!==used || full!==(used==DEPTH) || empty!==(used==0))
      $fatal(1,"FIFO_STATE_FAIL depth=%0d used=%0d count=%0d",DEPTH,used,count);
    checks++;
  endtask
  initial begin
    seed=$urandom(seed);
    repeat(2) @(negedge clk); rst_n=1;
    step(0,0,0); step(0,1,0);
    for(int i=0;i<DEPTH;i++) step(1,0,8'(i+10));
    step(1,0,99); step(1,1,100); step(1,1,101);
    repeat(1000) step(1'($urandom_range(0,1)),1'($urandom_range(0,1)),8'($urandom));
    while(used>0) step(0,1,0);
    step(1,0,8'h5a);
    @(negedge clk); push=0; pop=0;
    #2ns; rst_n=0; used=0; #1ns;
    if(count!==0 || empty!==1 || full!==0) $fatal(1,"FIFO_ASYNC_RESET_FAIL");
    #1ns; rst_n=1;
    step(1,0,8'h37); step(0,1,0);
    $display("FIFO_PORTABLE_PASS depth=%0d checks=%0d",DEPTH,checks);
    $finish;
  end
  initial begin #100us; $fatal(1,"FIFO_TEST_TIMEOUT"); end
endmodule
`default_nettype wire

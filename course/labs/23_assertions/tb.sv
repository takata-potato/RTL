// 23_assertions | SVAの入口：サンプル値と1サイクル後
// 規格: 16.1 16.2 16.3 16.4 16.5 16.6 16.14 16.15 16.16 20.13
// 見るところ: posedgeでサンプルするSVAと、NBA後に値を読むTBの違い。
// 変更してみる: ARGS=+BREAK_PROTOCOLで応答を壊し、SVA_FAILUREを確認する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0,rst_n=0,req=0,ack=0; int hits=0,requests=0;
  always #5ns clk=~clk;
  always_ff @(posedge clk) if(!rst_n) ack<=0; else ack<=req && !$test$plusargs("BREAK_PROTOCOL");
  a_response: assert property (@(posedge clk) disable iff(!rst_n) req |=> ack)
    hits++; else $fatal(1,"SVA_FAILURE response");
  a_past: assert property (@(posedge clk) disable iff(!rst_n) $past(rst_n) |-> ack==$past(req))
    else $fatal(1,"SVA_FAILURE past");
  c_request: cover property (@(posedge clk) rst_n && $rose(req)) requests++;
  initial begin
    repeat(2) @(negedge clk); rst_n=1; req=1;
    @(negedge clk); req=0;
    repeat(3) @(negedge clk);
    `CHECK(hits>0 && requests==1 && !$isunknown(ack), "request covered and assertions executed")
    `DONE("23_assertions")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 27_hierarchy | module・package・generate
// 規格: 3 23 26 27
// 見るところ: パラメーターで回路を展開し、階層名から各レーンを確認する。
// 変更してみる: LANESを1や8へ変え、generateの展開数と階層が変わるのを見る。
`default_nettype none
`include "lab.svh"
package math_pkg;
  parameter int BIAS=10;
  function automatic int add_bias(int x); return x+BIAS; endfunction
endpackage
module lane #(parameter int ID=0)(output wire [7:0] result);
  timeunit 1ns; timeprecision 1ps;
  localparam int VALUE=math_pkg::add_bias(ID);
  assign result=VALUE[7:0];
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  import math_pkg::*;
  localparam int LANES=4;
  wire [7:0] result[LANES];
  for(genvar i=0;i<LANES;i++) begin : g_lane
    lane #(.ID(i)) u_lane(.result(result[i]));
    if(i==0) begin : first_lane
      localparam bit IS_FIRST=1;
    end
  end
  initial begin
    #1ns;
    foreach(result[i]) `CHECK(result[i]==i+BIAS, "generated lane value")
    `CHECK(g_lane[0].first_lane.IS_FIRST, "named generate hierarchy")
    `DONE("27_hierarchy")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

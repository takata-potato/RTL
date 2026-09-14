`default_nettype none
module fifo #(parameter int WIDTH=8, DEPTH=4)(
  input wire logic clk,rst_n,push,pop,
  input wire logic [WIDTH-1:0] wdata,
  output wire logic [WIDTH-1:0] rdata,
  output wire logic full,empty,
  output logic [$clog2(DEPTH+1)-1:0] count
);
  timeunit 1ns; timeprecision 1ps;
  localparam int PTR_W=(DEPTH>1)?$clog2(DEPTH):1;
  logic [WIDTH-1:0] mem[DEPTH];
  logic [PTR_W-1:0] rd,wr;
  logic take_push,take_pop;
  assign full=(count==DEPTH);
  assign empty=(count==0);
  assign rdata=mem[rd]; // empty時は無効。TBもその時の値を比較しない。
  always_comb begin
    take_pop=pop && !empty;
    take_push=push && !full;
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin rd<='0; wr<='0; count<='0; end
    else begin
      if(take_push) begin
        mem[wr]<=wdata;
        wr<=(wr==DEPTH-1)?'0:wr+1'b1;
      end
      if(take_pop) rd<=(rd==DEPTH-1)?'0:rd+1'b1;
      case({take_push,take_pop})
        2'b10:count<=count+1'b1;
        2'b01:count<=count-1'b1;
        default:count<=count;
      endcase
    end
  end
endmodule
`default_nettype wire

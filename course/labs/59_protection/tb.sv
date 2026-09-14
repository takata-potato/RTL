`timescale 1ns/1ps
module tb;
  reg [7:0] a; wire [7:0] y;
  secret_cell dut(a,y);
  initial begin
    a=8'h12; #1;
    if(y!==8'hb7) $fatal(1,"PROTECTION_REFERENCE_FAIL");
    $display("LAB_PASS 59_protection behavior_only"); $finish;
  end
endmodule

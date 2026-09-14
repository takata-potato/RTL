// 42_fileio | ファイル・メモリー・plusargs・波形
// 規格: 21
// 見るところ: 実行時引数→変数→刺激→ファイル出力、を1本の流れで見る。
// 変更してみる: ARGS="+COUNT=2 +WAVES"で回数とVCDの有無を変更する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  logic [7:0] memory[0:3]; int count=4,fd,readback,ok;
  initial begin
    if($value$plusargs("COUNT=%d",count)) begin end
    if(count<1 || count>4 || $isunknown(count)) $fatal(1,"COUNT must be 1..4");
    $display("+COUNT -> count=%0d -> repeat count transactions",count);
    if($test$plusargs("WAVES")) begin $dumpfile("trace.vcd"); $dumpvars(0,tb); end
    $readmemh("input.hex",memory);
    `CHECK(memory[0]==8'h10 && memory[3]==8'h40, "read memory file")
    fd=$fopen("results.txt","w"); `CHECK(fd!=0, "open output file")
    for(int i=0;i<count;i++) $fdisplay(fd,"%0d",memory[i]);
    $fclose(fd);
    fd=$fopen("results.txt","r"); `CHECK(fd!=0, "reopen output file")
    ok=$fscanf(fd,"%d",readback); $fclose(fd);
    `CHECK(ok==1 && readback==16, "formatted file round trip")
    $writememh("output.hex",memory);
    #1ns; `DONE("42_fileio")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

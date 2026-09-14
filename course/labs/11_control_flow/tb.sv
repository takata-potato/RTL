// 11_control_flow | 分岐・繰返し・脱出
// 規格: 12 11.4
// 見るところ: ループの条件とbreak/continue、X/Zを含むcaseの違い。
// 変更してみる: casezをcaseに変えるとZ入力はdefaultへ行く。casexではXも無視される点を比べる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int sum, n, selected; logic [1:0] op;
  initial begin
    sum=0;
    for(int i=0;i<10;i++) begin
      if(i==8) break;
      if(i%2) continue;
      sum+=i;
    end
    `CHECK(sum==12, "break and continue")
    n=0; do n++; while(n<2); repeat(2) n++; while(n<5) n++;
    `CHECK(n==5, "do/repeat/while")
    op=2'b1z;
    casez(op) 2'b10:selected=10; default:selected=-1; endcase
    `CHECK(selected==10, "casez treats Z as wildcard")
    unique case(2'b01) 0:selected=0; 1:selected=1; default:selected=-1; endcase
    `CHECK(selected==1, "unique case selects one arm")
    begin : early_exit
      selected=3; disable early_exit; selected=99;
    end
    `CHECK(selected==3, "disable named block")
    `DONE("11_control_flow")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

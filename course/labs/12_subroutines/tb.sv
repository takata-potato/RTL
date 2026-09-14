// 12_subroutines | task/functionと引数の受渡し
// 規格: 13 6.21
// 見るところ: functionは時間を進めず、taskは待てる。refは呼出し元を直接参照する。
// 変更してみる: swapのrefをinputへ変えると呼出し元が変わらなくなる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  function automatic int factorial(input int n);
    if(n<=1) return 1;
    return n*factorial(n-1);
  endfunction
  function automatic int add(input int a, input int b=1); return a+b; endfunction
  task automatic swap(ref int a,b); int t; t=a; a=b; b=t; endtask
  task automatic delayed(input int a, output int b); #2ns; b=a*2; endtask
  int a,b,c;
  initial begin
    a=3; b=9; swap(a,b);
    `CHECK(a==9 && b==3 && factorial(5)==120, "ref and recursive automatic function")
    `CHECK(add(4)==5 && add(.b(2),.a(4))==6, "default and named arguments")
    delayed(a,c);
    `CHECK(c==18 && $time==2, "task consumes simulation time")
    `DONE("12_subroutines")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

// 08_strings | 文字列の操作と数値変換
// 規格: 6.16 11.10 21.3
// 見るところ: 文字列を組み立て、切り出し、数値を取り出す。
// 変更してみる: scan対象をaddr=oopsに変えると成功数が0になる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  string s, number, line; int n, scanned;
  initial begin
    s="sv"; s.putc(0, "S");
    `CHECK(s.len()==2 && s.getc(0)=="S" && s.toupper()=="SV", "string methods")
    `CHECK(s.substr(0,0)=="S" && s.icompare("sV")==0, "inclusive substring and comparison")
    number="2a"; n=number.atohex(); line=$sformatf("addr=%0d",n);
    scanned=$sscanf(line,"addr=%d",n);
    `CHECK(scanned==1 && n==42, "format and scan")
    number.itoa(-12); `CHECK(number=="-12" && number.atoi()==-12, "decimal conversion")
    `DONE("08_strings")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

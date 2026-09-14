// 75_declaration_forms | const/ref/type/varの違い
// 規格: 6.18 6.20 6.23 13.5 23.2 27
// 見るところ: constは変更禁止、refは参照渡し、typeは式の型。parameter typeで入出力の型を決める。
// 変更してみる: const refの引数を書き換えようとしてコンパイル診断を確認する。
`default_nettype none
`include "lab.svh"
macromodule legacy_buffer(input wire a, output wire y); assign y=a; endmodule
module typed_passthrough #(parameter type T=logic[7:0])
  (input var T a, output wire T y);
  assign y=a;
endmodule

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  const int LIMIT=3;
  var logic [7:0] source=8'h35;
  var type(source) same_type;
  wire [7:0] outputs[2]; uwire buffered;
  int values[3]='{1,2,3};
  function automatic int total(const ref int a[3]); return a[0]+a[1]+a[2]; endfunction
  generate
    for(genvar i=0;i<2;i++) begin : lanes
      typed_passthrough #(.T(type(source))) u_lane(source,outputs[i]);
    end
  endgenerate
  legacy_buffer old_cell(source[0],buffered);
  initial begin
    same_type=source; #1ns;
    `CHECK(LIMIT==3 && total(values)==6 && $bits(same_type)==8, "const, const ref and type operator")
    `CHECK(outputs[0]==8'h35 && outputs[1]==8'h35 && buffered===1'b1, "type-parameterized generate and uwire")
    `DONE("75_declaration_forms")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

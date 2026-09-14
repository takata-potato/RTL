// 暗号化対象の、こちらで作成した小さなセル。
module secret_cell(input wire [7:0] a, output wire [7:0] y);
  assign y=a^8'ha5;
endmodule

// 05_struct_union | 構造体・共用体・代入パターン
// 規格: 5.10 6.4 7.2 7.3 10.9
// 見るところ: structは並べて格納、unionは同じビットを別名で見る。
// 変更してみる: structのメンバー順を逆にしてビット配置の変化を確かめる。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  typedef struct packed {logic [3:0] kind; logic [3:0] len;} header_t;
  typedef union packed {header_t h; logic [7:0] word;} view_t;
  typedef struct {string name; int count;} record_t;
  header_t h; view_t v; record_t record;
  initial begin
    h = '{kind:4'ha, len:4'h3}; v.word = 8'ha3;
    record = '{name:"packet", count:3};
    `CHECK($bits(h)==8 && h==8'ha3, "packed struct layout")
    `CHECK(v.h.kind==10 && v.h.len==3, "packed union overlays storage")
    `CHECK(record.name=="packet" && record.count==3, "unpacked struct with string")
    h = '{default:'1};
    `CHECK(h=='1, "default assignment pattern")
    `DONE("05_struct_union")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

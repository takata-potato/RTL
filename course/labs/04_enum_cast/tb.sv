// 04_enum_cast | enumと型キャスト
// 規格: 6.18 6.19 6.24 6.25
// 見るところ: enumは名前の付いた型。$castは値が列挙子に含まれるか検査する。
// 変更してみる: $cast(state, 3) を $cast(state, 1) に変えて成功側を観察する。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  typedef enum logic [1:0] {IDLE=0, BUSY=1, COMPLETE=2} state_t;
  state_t state;
  initial begin
    state = state.first();
    `CHECK(state==IDLE && state.num()==3, "enum first and num")
    state = state.next();
    `CHECK(state==BUSY && state.name()=="BUSY", "enum next and name")
    `CHECK(!$cast(state, 3) && state==BUSY, "failed dynamic cast preserves destination")
    state = state_t'(2);
    `CHECK(state==state.last() && state.prev()==BUSY, "static cast and enum navigation")
    $display("type=%s", $typename(state));
    `DONE("04_enum_cast")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

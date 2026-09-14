// 28_interfaces | interface・modport・virtual interface
// 規格: 25
// 見るところ: 信号を束ね、modportで向きを定め、classからvirtual interface経由で駆動する。
// 変更してみる: DUT modportからinputのdataを書き換えようとすると方向違反になる。
`default_nettype none
`include "lab.svh"
interface bus_if(input wire logic clk);
  timeunit 1ns; timeprecision 1ps;
  logic [7:0] data=0, result; bit valid=0;
  modport dut(input clk,data,valid, output result);
  task automatic send(input byte unsigned v);
    @(negedge clk); data=v; valid=1;
    @(negedge clk); valid=0;
  endtask
endinterface
module responder(bus_if.dut bus);
  timeunit 1ns; timeprecision 1ps;
  always_ff @(posedge bus.clk) if(bus.valid) bus.result<=bus.data+8'd1;
endmodule
class Driver;
  virtual bus_if vif;
  function new(virtual bus_if vif); this.vif=vif; endfunction
  task run(); vif.send(7); endtask
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  bit clk=0; always #5ns clk=~clk;
  bus_if bus(clk); responder dut(bus); Driver driver;
  initial begin
    driver=new(bus); driver.run();
    `CHECK(bus.result==8, "class drives interface; RTL responds")
    `DONE("28_interfaces")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

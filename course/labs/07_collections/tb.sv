// 07_collections | 動的配列・連想配列・キュー
// 規格: 7.5 7.8 7.9 7.10 7.12
// 見るところ: 伸縮する配列、キー検索、FIFO、配列メソッドを使い分ける。
// 変更してみる: new[5](a)の(a)を外すと既存値がコピーされない。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int a[]; int lookup[string]; int q[$]; int selected[$]; string key;
  initial begin
    a = new[3]; foreach(a[i]) a[i]=i+1;
    a = new[5](a);
    `CHECK(a.size()==5 && a[2]==3 && a[4]==0, "resize and preserve")
    lookup["red"]=1; lookup["blue"]=2;
    `CHECK(lookup.num()==2 && lookup.exists("red"), "associative array")
    if (lookup.first(key)) do $display("key=%s value=%0d",key,lookup[key]); while(lookup.next(key));
    q = '{3,1,4}; q.push_back(4); q.push_front(0);
    `CHECK(q.pop_front()==0 && q.sum()==12, "queue FIFO and reduction")
    q.sort(); q.reverse(); selected=q.find() with (item>2);
    `CHECK(q[0]==4 && selected.size()==3, "sort/reverse/find with")
    selected=q.unique(); `CHECK(selected.size()==3, "unique values")
    lookup.delete("red"); a.delete(); q.delete();
    `CHECK(!lookup.exists("red") && a.size()==0 && q.size()==0, "delete")
    `DONE("07_collections")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

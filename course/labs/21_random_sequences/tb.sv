// 21_random_sequences | 乱数シード・randcase・randsequence
// 規格: 18.10 18.13 18.14 18.15 18.16 18.17 20.15 Annex N
// 見るところ: 値の乱数だけでなく、実行する処理の枝や文法的な並びも選べる。
// 変更してみる: SEED=2で全体の乱数列を変更し、チェックは特定列へ依存しないことを確認する。
`default_nettype none
`include "lab.svh"
class Generator;
  rand int unsigned n;
  int before_count=0, after_count=0;
  constraint range_c {n<100;}
  function void pre_randomize(); before_count++; endfunction
  function void post_randomize(); after_count++; endfunction
endclass

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  Generator g=new; int saved,branch=0,headers=0,bodies=0;
  initial begin
    g.srandom(123); `CHECK(g.randomize(), "first seeded randomization") saved=g.n;
    g.srandom(123); `CHECK(g.randomize() && g.n==saved, "object seed repeats sequence")
    `CHECK(g.before_count==2 && g.after_count==2, "randomization callbacks")
    randcase 1:branch=10; 2:branch=20; endcase
    `CHECK(branch inside {10,20}, "weighted procedural choice")
    randsequence(main)
      main: header body_item;
      header: {headers++;};
      body_item: {bodies++;} := 1 | {bodies++;} := 2;
    endsequence
    `CHECK(headers==1 && bodies==1, "production-based stimulus sequence")
    `DONE("21_random_sequences")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

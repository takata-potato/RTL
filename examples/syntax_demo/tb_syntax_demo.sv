// まず実行: make demo
// 回数変更: make demo XRUN_ARGS='+CYCLES=20 +VERBOSE'
// 実験だけ: make demo XRUN_ARGS='+TEST=gotchas'
// [01]〜[20] は README の構文一覧と対応。ログにも同じ番号を出す。
// 読み順: run_tests（全体の流れ）→ drive_and_check（1回の試験）→ reference_result。

`timescale 1ns/1ps                 // [01] コンパイル時の時間設定。
`default_nettype none
`include "demo_defs.svh"          // [03] ヘッダー内容をここへ挿入。
`include "demo_defs.svh"          // [04] わざと2回。include guard が重複を防ぐ。

module tb_syntax_demo;
    timeunit 1ns;                // [02] module 内で時間単位を明示。
    timeprecision 1ps;
    import syntax_demo_pkg::*;

    // [05] コンパイル時マクロ → TB の定数 → DUT の parameter という流れ。
    localparam int WIDTH = `DEMO_WIDTH;
    localparam int SHAMT_W = (WIDTH > 1) ? $clog2(WIDTH) : 1; // [17]

    // [06/10] 観測したい DUT 信号は X/Z を保持できる logic にする。
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic in_valid = 1'b0;
    logic [1:0] opcode = OP_ADD;
    logic signed [WIDTH-1:0] a = '0, b = '0;
    logic [SHAMT_W-1:0] shamt = '0;
    logic out_valid, bad_op;
    logic [WIDTH-1:0] result;

    // [20] 実行時設定。plusarg がなければ、このデフォルト値で動く。
    int cycles = 100;
    string test_name = "all";
    bit verbose = 1'b0;           // X/Z の検証が不要なオン/オフ設定は bit でよい。
    int checks = 0;
    logic [WIDTH-1:0] expected_result = '0;
    logic expected_valid = 1'b0, expected_bad = 1'b0;

    syntax_demo #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .in_valid(in_valid), .opcode(opcode),
        .a(a), .b(b), .shamt(shamt),
        .out_valid(out_valid), .result(result), .bad_op(bad_op)
    );

    // クロック周期を作っているのはこちら: 5ns ごとに反転 → 周期10ns。
    always #5ns clk = ~clk;

    initial begin : run_tests
        $timeformat(-9, 1, " ns", 10);
        if (WIDTH < 1 || WIDTH > 16)
            $fatal(1, "This tutorial TB supports DEMO_WIDTH=1..16");

        // [20] +CYCLES=5000 → CYCLES=%d → 変数 cycles に5000を入れる。
        if ($value$plusargs("CYCLES=%d", cycles)) begin
            if ($isunknown(cycles) || cycles < 1 || cycles > 100000)
                $fatal(1, "CYCLES must be 1..100000");
        end
        // %s は文字列。+TEST=smoke なら test_name が "smoke" になる。
        if ($value$plusargs("TEST=%s", test_name)) begin
            if (test_name != "all" && test_name != "smoke" &&
                test_name != "random" && test_name != "gotchas")
                $fatal(1, "TEST must be all, smoke, random or gotchas");
        end
        // 値なしのフラグ。+VERBOSE があると、検査ごとのログを出す。
        verbose = $test$plusargs("VERBOSE");

        $display("\n%s", `DEMO_TITLE);
        $display("[05/17] compile-time: WIDTH=%0d SHAMT_W=%0d", WIDTH, SHAMT_W);
        $display("[20] run-time: TEST=%s CYCLES=%0d VERBOSE=%0b", test_name, cycles, verbose);
`ifdef DEMO_DEBUG
        // [05/20] +define+DEMO_DEBUG がコンパイル時にこの行を有効にする。
        $display("[05/20] DEMO_DEBUG code was compiled in");
`endif

        if (test_name == "all" || test_name == "gotchas")
            show_gotchas();

        repeat (2) drive_and_check(0, OP_ADD, '0, '0, '0, "initial reset");
        @(negedge clk);
        rst_n = 1'b1;

        if (test_name == "all" || test_name == "smoke")
            directed_tests();
        if (test_name == "all" || test_name == "random") begin
            $display("[RTL] random transactions: %0d", cycles);
            for (int i = 0; i < cycles; i++) begin
                drive_and_check(1'($urandom_range(0, 1)), 2'($urandom_range(0, 3)),
                                WIDTH'($urandom), WIDTH'($urandom),
                                SHAMT_W'($urandom), "random");
            end
        end
        if (test_name != "gotchas")
            check_async_reset();
        drive_and_check(0, OP_ADD, '0, '0, '0, "final idle");

        // [19] 失敗検出の実験。このフラグを指定した実行は、意図的に失敗する。
        if ($test$plusargs("INJECT_FAIL")) begin
            expected_result = ~expected_result;
            check_outputs("intentional mismatch");
        end
        // [19] +PAUSE は対話GUI用。通常のバッチ実行では指定しない。
        if ($test$plusargs("PAUSE")) begin
            $display("[19] $stop: paused; resume in the simulator to finish");
            $stop;
        end
        $display("PASS: tb_syntax_demo TEST=%s WIDTH=%0d checks=%0d", test_name, WIDTH, checks);
        $finish;  // [19] 正常終了。
    end

    // おまけ: automatic function。RTLのビット演算と別に、整数で期待値を計算。
    // TB は WIDTH=1〜16 を対象にし、32bit整数の中で十分な幅を持たせる。
    function automatic logic [WIDTH-1:0] reference_result(
        input logic [1:0] op,
        input logic [WIDTH-1:0] lhs_bits, rhs_bits,
        input int shift_amount
    );
        int lhs, rhs, value;
        lhs = $signed(lhs_bits);
        rhs = $signed(rhs_bits);
        value = 0;
        case (op)
            OP_ADD: value = lhs + rhs;
            OP_SUB: value = lhs - rhs;
            OP_AND: value = lhs & rhs;
            OP_SRA: begin
                // DUT の >>> をコピーせず、負数を切り下げる整数除算で検算。
                value = lhs;
                repeat (shift_amount)
                    value = (value < 0) ? (value - 1) / 2 : value / 2;
            end
            default: value = 0;
        endcase
        return value[WIDTH-1:0];
    endfunction

    // [11/19] !== は X/Z を含めて比較。失敗したら $fatal で終了する。
    task automatic check_outputs(input string label_text);
        checks++;
        if (out_valid !== expected_valid || result !== expected_result || bad_op !== expected_bad)
            $fatal(1, "FAIL [%s] t=%0t: valid=%b/%b result=%h/%h bad=%b/%b (actual/expected)",
                   label_text, $time, out_valid, expected_valid, result, expected_result, bad_op, expected_bad);
        if (verbose)
            $display("[18] CHECK %0d: %-18s t=%0t valid=%b result=%h bad=%b",
                     checks, label_text, $time, out_valid, result, bad_op);
    endtask

    // [18] 入力は negedge で変更し、posedge の FF 更新後に読む。
    // #1ns はこの10ns周期の小さなTB用。一般には clocking block も選択肢。
    task automatic drive_and_check(
        input bit valid_value,
        input logic [1:0] op,
        input logic [WIDTH-1:0] lhs, rhs,
        input logic [SHAMT_W-1:0] shift_amount,
        input string label_text
    );
        @(negedge clk);
        in_valid = valid_value;
        opcode = op;
        a = lhs;
        b = rhs;
        shamt = shift_amount;
        @(posedge clk);
        if (verbose)
            $display("[09] posedge, before NBA: result=%h", result);
        if (!rst_n) begin
            expected_valid = 1'b0;
            expected_result = '0;
            expected_bad = 1'b0;
        end else begin
            expected_valid = valid_value;
            if (valid_value) begin
                expected_result = reference_result(op, lhs, rhs, int'(shift_amount));
                expected_bad = $isunknown(op);
            end
        end
        #1ns;
        check_outputs(label_text);
    endtask

    task automatic directed_tests;
        $display("[RTL] directed tests: ADD / SUB / AND / signed shift / hold / unknown opcode");
        drive_and_check(1, OP_ADD, WIDTH'(7), WIDTH'(3), '0, "add positive");
        drive_and_check(1, OP_ADD, WIDTH'(-4), WIDTH'(1), '0, "add negative");
        drive_and_check(1, OP_ADD, '1, WIDTH'(1), '0, "wrap around");       // [14]
        drive_and_check(1, OP_SUB, WIDTH'(3), WIDTH'(7), '0, "subtract");
        drive_and_check(1, OP_AND, '1, WIDTH'(8'h5a), '0, "AND mask");
        drive_and_check(1, OP_SRA, WIDTH'(-4), '0, SHAMT_W'(1), "signed shift");
        drive_and_check(1, OP_SRA, '1, '0, '1, "large shift");
        drive_and_check(0, OP_ADD, '0, '0, '0, "hold while idle");
        drive_and_check(1, 2'bx0, '1, '1, '0, "unknown opcode");
        drive_and_check(1, 2'bz1, '1, '1, '0, "Z opcode");
        drive_and_check(1, OP_ADD, WIDTH'(1), '0, '0, "recover from bad op");
    endtask

    task automatic check_async_reset;
        // どの WIDTH でも非ゼロの結果を作ってから、クロックの途中でリセット。
        drive_and_check(1, OP_AND, '1, '1, '0, "before async reset");
        @(negedge clk);
        in_valid = 1'b0;
        #2ns;
        rst_n = 1'b0;
        expected_valid = 1'b0;
        expected_result = '0;
        expected_bad = 1'b0;
        #1ns;  // 次の posedge より前に出力がクリアされることを確認。
        check_outputs("asynchronous reset");
        drive_and_check(0, OP_ADD, '0, '0, '0, "reset held");
        @(negedge clk);
        rst_n = 1'b1;
    endtask

    // [03] task の定義も include できる。挿入位置は module の内側。
    `include "tb_gotchas.svh"

    // 永久待ちを防止。上限100000回の10ns周期試験より十分長い時間。
    initial begin
        #5ms;
        $fatal(1, "FAIL: tutorial watchdog expired");
    end
endmodule

`default_nettype wire

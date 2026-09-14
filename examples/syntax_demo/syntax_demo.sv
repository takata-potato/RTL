// 読み順: README.md → この RTL → tb_syntax_demo.sv → tb_gotchas.svh
// [番号] は README の「前の20項目」と対応。
// 動作: a,b,opcode → 組合せ演算 (=) → クロックで保存 (<=) → result

// [01] #1 の単位は 1ns、精度は 1ps。クロック周期の指定ではない。
`timescale 1ns/1ps
`default_nettype none  // 宣言漏れ・信号名のタイプミスをエラーにする。

module syntax_demo #(
    // [05] WIDTH はインスタンスごとに変更できる parameter。
    parameter int WIDTH = 8,
    // [05/17] localparam は直接上書き不可。WIDTH=1 でも信号を1bitにする。
    localparam int SHAMT_W = (WIDTH > 1) ? $clog2(WIDTH) : 1
) (
    // none と併用する入力は net の種類 (wire) まで明示している。
    input  wire logic                      clk,
    input  wire logic                      rst_n,
    input  wire logic                      in_valid,
    input  wire logic [1:0]                opcode,
    input  wire logic signed [WIDTH-1:0]   a,
    input  wire logic signed [WIDTH-1:0]   b,
    input  wire logic [SHAMT_W-1:0]         shamt,
    output      logic                      out_valid,
    output      logic [WIDTH-1:0]          result,
    output      logic                      bad_op
);
    // [02] この module の時間設定。他ファイルの timescale に依存しない。
    timeunit 1ns;
    timeprecision 1ps;

    import syntax_demo_pkg::*;

    // [06] 同じ logic でも calc_d は組合せ信号、result は FF の出力になる。
    logic [WIDTH-1:0] calc_d;
    logic invalid_d;

    // [07/09] 組合せ部分: = はその場で代入。最初のデフォルト代入で漏れを防ぐ。
    always_comb begin
        calc_d = '0;   // [14] WIDTH が何bitでも全0。
        invalid_d = 1'b0;

        // [12/13] 通常の case の比較を使う。unique は分岐の重複なしを表す。
        // default も明示し、未知の opcode では result=0 / bad_op=1 にする。
        unique case (opcode)
            OP_ADD: calc_d = a + b;
            OP_SUB: calc_d = a - b;
            OP_AND: calc_d = a & b;
            // [16] a が signed なので >>> は上位を符号ビットで埋める。
            OP_SRA: calc_d = a >>> shamt;
            default: begin
                calc_d = '0;
                invalid_d = 1'b1;
            end
        endcase
    end

    // [08/09] FF 部分: <= は更新を予約。全 FF が更新前の入力を捕まえる。
    // リセットは非同期。解除後は posedge で in_valid を受け付ける。
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            result <= '0;
            bad_op <= 1'b0;
        end else begin
            out_valid <= in_valid;
            if (in_valid) begin
                result <= calc_d;
                bad_op <= invalid_d;
            end
            // ここで else がないのは意図どおり: FF の result/bad_op を保持。
            // always_comb の代入漏れとは違う。
        end
    end
endmodule

`default_nettype wire  // 後で読み込まれるコードへ設定を持ち越さない。

// TB の module 内から include する「小実験集」。DUT の回路には含めない。
// 観測結果を表示するだけでなく、期待した言語動作になったかも assert する。
`ifndef SYNTAX_DEMO_TB_GOTCHAS_SVH
`define SYNTAX_DEMO_TB_GOTCHAS_SVH

task automatic show_gotchas;
    reg   [3:0] legacy_variable;
    logic [3:0] four_state;
    bit   [3:0] two_state;
    logic normal_eq;
    bit strict_eq;
    bit case_match, casex_match, casez_match;
    logic [7:0] fill_ones, numeric_one;
    logic signed [7:0] negative;
    logic [7:0] whole_shift, slice_shift, fixed_shift;
    int mixed_sum;
    localparam int RAW_W = $clog2(1);
    localparam int SAFE_W = (1 > 1) ? $clog2(1) : 1;
    logic [RAW_W-1:0] naive_address;
    logic [SAFE_W-1:0] safe_address;

    $display("\n--- GOTCHAS: controlled experiments, separate from the DUT ---");

    // [06] reg と logic の4状態値を見比べる。reg 宣言だけで FF にはならない。
    four_state = 4'bx101;
    legacy_variable = four_state;
    assert (legacy_variable === four_state) else $fatal(1, "[06] reg/logic experiment failed");
    $display("[06] reg=%b; logic=%b : both retain the four-state value", legacy_variable, four_state);

    // [10] X を bit へ入れると 0 になる。RTL の未知値が隠れる例。
    two_state = four_state;
    assert (two_state === 4'b0101) else $fatal(1, "[10] X-to-bit experiment failed");
    $display("[10] logic=%b -> bit=%b : X became 0", four_state, two_state);

    // [11] == は X、=== は 0。if(X) は true にならないので検査を見逃せる。
    normal_eq = (four_state == 4'b0101);
    strict_eq = (four_state === 4'b0101);
    assert (normal_eq === 1'bx && strict_eq == 1'b0)
        else $fatal(1, "[11] equality experiment failed");
    $display("[11] x101 == 0101 -> %b; x101 === 0101 -> %b", normal_eq, strict_eq);

    // [12] casex / casez は、この意図的な小実験でのみ使用する。
    // 判定する信号側の X / Z まで「何でもよい」にされてしまう。
    case_match = 1'b0;
    casex_match = 1'b0;
    casez_match = 1'b0;
    case (four_state)
        4'b0101: case_match = 1'b1;
        default: ;
    endcase
    casex (four_state)
        4'b0101: casex_match = 1'b1;
        default: ;
    endcase
    casez (4'bz101)
        4'b0101: casez_match = 1'b1;
        default: ;
    endcase
    assert (!case_match && casex_match && casez_match)
        else $fatal(1, "[12] wildcard experiment failed");
    $display("[12] case(x101)=%0b; casex(x101)=%0b; casez(z101)=%0b",
             case_match, casex_match, casez_match);

    // [14/15] '1 は代入先の全bitを1にする。普通の 1 とは異なる。
    fill_ones = '1;
    numeric_one = 1;
    assert (fill_ones === 8'hff && numeric_one === 8'h01)
        else $fatal(1, "[14] fill experiment failed");
    assert ($bits(1) >= 32 && $bits(1'b1) == 1)
        else $fatal(1, "[15] literal-width experiment failed");
    $display("[14] 8-bit assignment: '1=%h; 1=%h", fill_ones, numeric_one);
    $display("[15] literal widths: $bits(1)=%0d; $bits(1'b1)=%0d", $bits(1), $bits(1'b1));

    // [16] a が signed でも a[7:0] は unsigned。切り出しで符号が変わる。
    negative = -8'sd4;
    whole_shift = negative >>> 1;
    slice_shift = negative[7:0] >>> 1;
    fixed_shift = $signed(negative[7:0]) >>> 1;
    mixed_sum = negative + 8'd1;
    assert (whole_shift === 8'hfe && slice_shift === 8'h7e && fixed_shift === 8'hfe)
        else $fatal(1, "[16] signed-shift experiment failed");
    assert (mixed_sum == 253) else $fatal(1, "[16] mixed-signedness experiment failed");
    $display("[16] -4 >>> 1: whole=%h; slice=%h; cast-back=%h", whole_shift, slice_shift, fixed_shift);
    $display("[16] signed(-4) + unsigned 8'd1, assigned to int -> %0d", mixed_sum);

    // [17] [-1:0] は0bitではなく2bit。DEPTH/WIDTH=1 を明示的に扱う。
    assert (RAW_W == 0 && $bits(naive_address) == 2 && $bits(safe_address) == 1)
        else $fatal(1, "[17] clog2 boundary experiment failed");
    $display("[17] clog2(1)=%0d; naive [-1:0]=%0d bits; guarded width=%0d bit",
             RAW_W, $bits(naive_address), $bits(safe_address));
    $display("--- GOTCHAS PASS ---\n");
endtask

`endif

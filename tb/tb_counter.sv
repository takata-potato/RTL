`timescale 1ns/1ps
`default_nettype none

module tb_counter;
    localparam int WIDTH = 8;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic en = 1'b0;
    logic [WIDTH-1:0] count;
    logic [WIDTH-1:0] expected = '0;
    int cycles = 1000;

    counter #(.WIDTH(WIDTH)) dut (.*);
    always #5ns clk = ~clk;

    task automatic check_count(input string context_name);
        if (count !== expected)
            $fatal(1, "FAIL: %s at %0t: expected=%0d actual=%0d",
                   context_name, $time, expected, count);
    endtask

    task automatic step(input bit next_en);
        // Drive on the falling edge and sample after the DUT's NBA updates.
        @(negedge clk);
        en = next_en;
        @(posedge clk);
        if (!rst_n)
            expected = '0;
        else if (next_en)
            expected = expected + 1'b1;
        #1ns;
        check_count("clocked update");
    endtask

    initial begin
        if ($value$plusargs("CYCLES=%d", cycles)) begin
            if (cycles < 1 || cycles > 1000000)
                $fatal(1, "CYCLES must be between 1 and 1000000");
        end

        repeat (2) step(1'b0);
        @(negedge clk);
        rst_n = 1'b1;

        // Increment through overflow, then confirm clock-enable holds the value.
        repeat (260) step(1'b1);
        repeat (5) step(1'b0);
        for (int i = 0; i < cycles; i++)
            step($urandom_range(0, 1));

        // Assert reset between clock edges and check it before the next edge.
        step(1'b1);
        // Make reset observable for every random seed, including after a wrap.
        if (expected == '0)
            step(1'b1);
        @(negedge clk);
        en = 1'b1;
        #2ns;
        rst_n = 1'b0;
        expected = '0;
        #1ns;
        check_count("asynchronous reset");
        repeat (2) step(1'b0);
        @(negedge clk);
        rst_n = 1'b1;
        repeat (4) step(1'b1);

        $display("PASS: tb_counter (%0d randomized cycles)", cycles);
        $finish;
    end

    initial begin
        #20ms;
        $fatal(1, "FAIL: simulation watchdog expired");
    end
endmodule

`default_nettype wire

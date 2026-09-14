`timescale 1ns/1ps
`default_nettype none

// おまけ: package / typedef / enum。操作番号に意味のある名前を付ける。
// files.f では、この package を使用側の RTL / TB より先に並べる。
package syntax_demo_pkg;
    typedef enum logic [1:0] {
        OP_ADD = 2'b00,  // 符号付き加算。下位 WIDTH bit を保存。
        OP_SUB = 2'b01,  // 符号付き減算。下位 WIDTH bit を保存。
        OP_AND = 2'b10,  // ビットごとの AND。
        OP_SRA = 2'b11   // 符号を保った右シフト。
    } opcode_t;
endpackage

`default_nettype wire

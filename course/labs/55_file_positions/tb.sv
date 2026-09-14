// 55_file_positions | ファイルの位置・EOF・文字I/O
// 規格: 21.3
// 見るところ: EOFは読み取りに失敗した後で分かる。位置を戻して同じ内容を読む。
// 変更してみる: EOF判定をreadより前だけに置くループと、戻り値を確認するループの差を見る。
`default_nettype none
`include "lab.svh"

module tb;
  timeunit 1ns; timeprecision 1ps;
  int checks = 0;
  int fd,ch,rc; longint position;
  initial begin
    fd=$fopen("letters.txt","w"); `CHECK(fd!=0, "open writer")
    $fwrite(fd,"ABC"); $fflush(fd); $fclose(fd);
    fd=$fopen("letters.txt","r"); `CHECK(fd!=0, "open reader")
    ch=$fgetc(fd); `CHECK(ch==65, "fgetc returns first byte")
    rc=$ungetc(ch,fd); ch=$fgetc(fd); `CHECK(ch==65, "ungetc puts back one character")
    rc=$fseek(fd,2,0); `CHECK(rc==0, "seek to absolute byte offset")
    ch=$fgetc(fd); `CHECK(ch==67, "read last byte")
    ch=$fgetc(fd); `CHECK(ch==-1 && $feof(fd), "EOF is distinct from a valid byte")
    rc=$rewind(fd); position=$ftell(fd); `CHECK(position==0, "rewind resets position")
    $fclose(fd); `DONE("55_file_positions")
  end
  initial begin #100us; $fatal(1, "LAB_TIMEOUT"); end
endmodule
`default_nettype wire

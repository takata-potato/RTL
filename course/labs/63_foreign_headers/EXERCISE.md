# ヘッダーの実物と比較

```bash
cc -I "$VPI_INCLUDE" -I "$DPI_INCLUDE" course/labs/63_foreign_headers/inspect_headers.c -o build/inspect_headers
build/inspect_headers
```

API索引では、規格に存在する名前と教材のCで呼び出す名前を区別する。
vpi_compatibility.hは古いPLIとの互換層。新しいAPIの利用例はvpi_user.hとsv_vpi_user.hを参照する。
シミュレータ付属ヘッダーを優先し、別製品のヘッダーで共有ライブラリーを作らない。

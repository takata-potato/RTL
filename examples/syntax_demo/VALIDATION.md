# 検証記録

2026-09-13、Ubuntu 22.04 / WSL2、Icarus Verilog 11.0で検証しました。

| 確認内容 | 結果 |
| --- | --- |
| WIDTH=1、3、8、16で全小実験・固定試験・各1000回のランダム試験 | 合格 |
| 既定値での全実行（ランダム100回、出力照合117回） | 合格 |
| `TEST=smoke / random / gotchas`と`+VERBOSE` | 合格 |
| 上限100000回のランダム試験とウォッチドッグの余裕 | 合格 |
| 回数0、負数、上限超過、Xを含む回数、未知のテスト名 | 意図どおり失敗 |
| `+INJECT_FAIL`による意図的な期待値不一致 | 意図どおり失敗 |
| コンパイル時の`DEMO_WIDTH`/`DEMO_DEBUG`と実行時のplusargs | 意図どおり区別 |
| TBの対応幅を超えたWIDTH=17 | 意図どおり失敗 |
| ADDをSUBに改変したRTL | 検出 |
| 符号付き右シフトを論理右シフトへ改変したRTL | 検出 |
| in_valid=0でもresultを書き換えるRTL | 検出 |
| 非同期リセットを同期リセットへ改変したRTL | 検出 |
| 不明なopcodeでbad_opを出さないRTL | 検出 |
| 不明なopcodeでresultにXを出すRTL | `!==`で検出 |
| 小実験の値を壊し、即時assertが働くことを確認 | 検出 |
| Makeのdemo用入口、波形/GUI用のコマンド生成、RUN_NAME変更 | 合格 |

RTLの故障注入は一時コピーに対して行い、配布するRTLは変更していません。

**xrun本体、ライセンス取得、SimVision、SHM出力は未検証です。** また、Icarusは`unique case`のunique検査を無視する旨を表示します。caseの選択動作は上記で検証していますが、uniqueの違反検出は実行先のXceliumでの確認が必要です。

Xcelium側での確認例:

```bash
make doctor
make demo
make demo XRUN_ARGS='+define+DEMO_WIDTH=1 +TEST=smoke'
make demo XRUN_ARGS='+TEST=smoke +INJECT_FAIL'  # この実行は非ゼロ終了が正しい
make demo-waves
```

Icarusがインストール済みなら、プロジェクトのルートから次のように再実行できます。これはXcelium固有機能の検証を代替しません。

```bash
mkdir -p build/portable-demo
iverilog -g2012 -Wall -I examples/syntax_demo -s tb_syntax_demo \
  -o build/portable-demo/demo.vvp \
  examples/syntax_demo/syntax_demo_pkg.sv \
  examples/syntax_demo/syntax_demo.sv \
  examples/syntax_demo/tb_syntax_demo.sv
vvp build/portable-demo/demo.vvp +CYCLES=1000
```

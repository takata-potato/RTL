# 見て・動かして覚える、SystemVerilogの20項目

前の会話で挙げた20項目を、**小型ALUのRTL＋自己チェック付きTB＋落とし穴の小実験**にまとめました。SystemVerilog全仕様の網羅を意味するものではありません。`[01]`〜`[20]`の番号はコード、下の早見表、実行ログで共通です。

## 最初に動かす

プロジェクトのルート（Makefileのある場所）で実行します。Linuxでxrunとライセンスが使えることが前提です。

```bash
make demo                                      # 全実験＋固定試験＋ランダム100回
make demo XRUN_ARGS='+CYCLES=5 +VERBOSE'          # 少ない回数で、1回ずつ結果を見る
make demo XRUN_ARGS='+TEST=gotchas'              # X・符号・幅などの小実験だけ
make demo-waves                                # SHM波形も保存
make demo-view                                 # 保存した波形をSimVisionで見る
```

ツールなしで実行コマンドを見たいときは`make demo-dry-run`。既存のカウンタのサンプルは`make run`で動きます。

## まず読む場所

| 順番 | ファイル | 見どころ |
| --- | --- | --- |
| 1 | [syntax_demo.sv](syntax_demo.sv) | 入力→`always_comb`で計算→`always_ff`で保存。RTLの本体 |
| 2 | [tb_syntax_demo.sv](tb_syntax_demo.sv) | 前半の`run_tests`から読む。設定→入力→期待値との比較→終了 |
| 3 | [tb_gotchas.svh](tb_gotchas.svh) | X、case、符号、幅の違いを実際に観測する小実験 |
| 4 | [demo_defs.svh](demo_defs.svh) | include guard、マクロ、コマンドラインでの上書き |
| 5 | [syntax_demo_pkg.sv](syntax_demo_pkg.sv) | package、typedef、enumで操作番号に名前を付ける |
| 6 | [files.f](files.f) | xrunへ渡すソース一覧。packageを先にコンパイルする |

```text
コマンド: +CYCLES=5 +TEST=all
             │ $value$plusargs で読む [20]
             ▼
TB: negedgeで a / b / opcode / in_valid を変更 [18]
             │
             ▼
RTL: always_comb で calc_d を計算 (=) [07/09]
             │
             ▼
RTL: posedgeで result に保存 (<=) [08/09]
             │ 更新が済むのを待つ
             ▼
TB: posedgeから1ns後、期待値と !== で照合 [11/18]
             │
             ├─ 不一致 → $fatal [19]
             └─ 全試験成功 → PASS表示 → $finish [19]
```

## RTLが行うこと

`in_valid=1`でクロックが立ち上がると、次の演算結果をレジスタへ保存します。加減算でWIDTHを超えた上位ビットは捨てます。

| opcode | 名前 | 演算 | WIDTH=8の例 |
| --- | --- | --- | --- |
| `00` | `OP_ADD` | 符号付き加算 | `7 + 3 = 10` |
| `01` | `OP_SUB` | 符号付き減算 | `3 - 7 = -4`（`8'hfc`） |
| `10` | `OP_AND` | ビットごとのAND | `8'hff & 8'h5a = 8'h5a` |
| `11` | `OP_SRA` | 符号を保った右シフト | `-4 >>> 1 = -2`（`8'hfe`） |

- `out_valid`が1のとき、`result`と`bad_op`が有効です。
- `in_valid=0`のクロックでは`out_valid=0`になり、`result`と`bad_op`は前の値を保持します。
- `rst_n=0`になると、クロックを待たずに出力を0へ戻します。
- シミュレーションでopcodeにX/Zがある場合は、通常のcaseの`default`で`result=0, bad_op=1`にします。

## 前の20項目はどこにある？

| 番号 | 構文・話題 | このサンプルでの使い方 |
| --- | --- | --- |
| 01 | `` `timescale `` | RTL/TBの先頭で`1ns/1ps`を指定 |
| 02 | `timeunit` / `timeprecision` | RTL/TBのmodule内で時間設定を明示 |
| 03 | `` `include `` | TBにマクロヘッダーと小実験のtaskを挿入 |
| 04 | `` `ifndef ``のガード | `demo_defs.svh`を意図的に2回includeしても内容を重複させない |
| 05 | `` `define `` / `parameter` / `localparam` | マクロ`DEMO_WIDTH`→TBのWIDTH→DUTのparameter。SHAMT_Wはlocalparam |
| 06 | `reg` / `logic`と実際の回路 | 小実験で4状態値を比較。DUTの`logic calc_d`は組合せ信号、`logic result`はFF出力 |
| 07 | `always_comb` | 最初にデフォルト値を入れ、caseで計算。代入漏れによるラッチを防ぐ |
| 08 | `always_ff` | クロックと非同期リセットで出力レジスタを更新 |
| 09 | `=` / `<=` | 組合せは`=`、FFは`<=`。TBはFFの更新後に比較 |
| 10 | `bit` / `logic` | TBの設定フラグはbit、DUT信号はlogic。小実験で`x101 → 0101`を観測 |
| 11 | `==` / `===` / `!==` | 小実験で比較結果のXを観測。スコアボードは`!==`を使用 |
| 12 | `case` / `casex` / `casez` | DUTは通常の比較。X/Zが一致扱いになる危険な例は小実験内でのみ実行 |
| 13 | `unique case` | DUTの4演算を重複なしとして記述。defaultも明示 |
| 14 | `'0` / `'1` | リセットとマスク入力。小実験で8bitへの`'1=ff`と`1=01`を表示 |
| 15 | 定数の幅 | 幅付き定数・サイズキャストを使用。小実験で`$bits(1)`と`$bits(1'b1)`を比較 |
| 16 | `signed` / 部分選択 / `>>>` | DUTの符号付きシフトと、小実験の「切り出すとunsigned」を比較 |
| 17 | `$clog2(1)` | シフト量の信号幅を最低1bitにする。小実験で`[-1:0]`が2bitになることを表示 |
| 18 | TBとDUTの競合回避 | negedgeで入力変更、posedgeから1ns後に比較 |
| 19 | `$finish` / `$fatal` / `$stop` | 正常終了・エラー終了・明示的に指定したときだけの対話停止 |
| 20 | plusargsとコンパイル時設定 | `+CYCLES`、`+TEST`、`+VERBOSE`と、`+define+DEMO_WIDTH`を使い分け |

⑥の意味はreg/logicの値の比較と、実際に異なる回路になる2つのlogicで示しています。Xを隠す書き方は専用の小実験で挙動を確認できます。

おまけとして、`package`、`typedef enum`、`import`、`function automatic`、`task automatic`、`assert`、`$isunknown`、`$bits`、サイズキャスト、`for`、`repeat`、`$urandom`も使っています。並行アサーション（SVA）やUVMはこのサンプルの範囲外です。

## plusargsは、この3つから試す

| 渡す文字列 | TBが行うこと | 省略したとき |
| --- | --- | --- |
| `+CYCLES=20` | `$value$plusargs("CYCLES=%d", cycles)`で回数を読む | 100回 |
| `+TEST=smoke` | `$value$plusargs("TEST=%s", test_name)`でテスト名を読む | `all` |
| `+VERBOSE` | `$test$plusargs("VERBOSE")`でフラグの有無を調べる | 詳細ログなし |

`CYCLES`はランダム試験の回数です。固定試験・リセット検査の数は含みません。指定可能な回数は1〜100000です。

| TEST | 実行する内容 |
| --- | --- |
| `all` | 小実験＋固定試験＋ランダム試験＋非同期リセット検査 |
| `smoke` | 固定試験＋非同期リセット検査 |
| `random` | ランダム試験＋非同期リセット検査 |
| `gotchas` | 小実験＋基本のリセット・アイドル確認 |

フラグ型の`+VERBOSE`は「存在したらON」です。`+VERBOSE=0`もONになり、`$test$plusargs`は前方一致で検索します。OFFにするときは引数を外してください。

## コンパイル時と実行時を見比べる

```bash
# WIDTH=16の回路をコンパイルし、ランダム試験を20回行う。
make demo XRUN_ARGS='+define+DEMO_WIDTH=16 +CYCLES=20'

# マクロで囲んだコードを、コンパイル時に有効化する。
make demo XRUN_ARGS='+define+DEMO_DEBUG +TEST=smoke'

# 幅1bitの境界条件。$clog2(1)への対策を確認できる。
make demo XRUN_ARGS='+define+DEMO_WIDTH=1 +TEST=smoke'
```

このTBで動作確認するWIDTHは1〜16です。サイズ変更後にコマンドを省略すると、ヘッダーの既定値8でコンパイルされます。xrunは必要に応じて再コンパイルします。

乱数シードは既存ランナーの`make demo SEED=42`で指定でき、xrunの`-svseed 42`になります。同じシードでの再現は、同じシミュレータ・バージョン・コード・設定が前提です。

## 失敗・一時停止も試す

```bash
# 期待値を意図的に壊す。FAILと非ゼロ終了が正しい結果。
make demo XRUN_ARGS='+TEST=smoke +INJECT_FAIL'

# GUIのRunで試験を開始し、終了直前の$stopで一時停止する。
make demo-gui XRUN_ARGS='+TEST=smoke +PAUSE'
```

`+PAUSE`は対話用です。無人のバッチ実行では指定しません。GUIで再開すると、PASSを表示して終了へ進みます。

## ログと波形の見方

ログは`build/tb_syntax_demo/run/xrun.log`、波形付きなら`build/tb_syntax_demo/waves/`です。保存先を分けるには`RUN_NAME=trial_01`を指定します。

正常な実行では、例えば次の結果を表示します。

```text
[20] run-time: TEST=all CYCLES=100 VERBOSE=0
[10] logic=x101 -> bit=0101 : X became 0
[11] x101 == 0101 -> x; x101 === 0101 -> 0
[14] 8-bit assignment: '1=ff; 1=01
[16] -4 >>> 1: whole=fe; slice=7e; cast-back=fe
[17] clog2(1)=0; naive [-1:0]=2 bits; guarded width=1 bit
PASS: tb_syntax_demo TEST=all WIDTH=8 checks=117
```

波形へ追加すると追いやすい信号は、`clk`、`rst_n`、`in_valid`、`opcode`、`a`、`b`、`shamt`、`dut.calc_d`、`out_valid`、`result`、`bad_op`です。`calc_d`は入力に応じて変化し、`result`はposedgeでだけ変化する点を見てください（非同期リセット時を除く）。

## 検証の範囲

動作検証の結果は、付属の[検証記録](VALIDATION.md)に記載しています。xrun本体は利用できないため、Linux上のIcarus Verilogで4状態の動作を確認します。**Icarusは`unique case`のunique検査を無視する**ので、その検査とxrun/SimVision固有の動作は、実行先のXceliumでの確認が必要です。

## 仕様を読みたいとき

- 時間設定と読み込み順については[Sutherlandらの解説](https://sutherland-hdl.com/papers/2007-SNUG-SanJose_gotcha_again_paper.pdf)に具体例があります。
- 型、組合せ/順序回路、unique、$clog2については[RTL向けSystemVerilogの論文](https://sutherland-hdl.com/papers/2013-SNUG-SV_Synthesizable-SystemVerilog_paper.pdf)を参照できます。
- 符号、部分選択、暗黙のnetなどの落とし穴は[Standard Gotchas](https://sutherland-hdl.com/papers/2006-SNUG-Boston_standard_gotchas_paper.pdf)で扱われています。

# Linux + xrun RTL実行環境

SystemVerilogのRTLを、Cadence Xceliumの`xrun`でコンパイル・エラボレーション・シミュレーションする最小構成です。8bitカウンタと、正常動作を自動判定するテストベンチを含みます。

**解説付きの20構文デモもあります。** `make demo`で実行できます。[RTL・TBの読み方と構文早見表](examples/syntax_demo/README.md)を見ながら、`make demo XRUN_ARGS='+CYCLES=5 +VERBOSE'`で1回ずつ動作を追えます。

**添付IEEE 1800-2017に対応する全体コースを追加しました。** [実験ノートを開く](course/index.html) / [コースの使い方](course/README.md)。81シナリオ、目次全593項目、248予約語の使用例を辿れます。`make learn LAB=42`でplusargsとファイルI/O、`make learn`でFIFO総合演習を実行します。コースにはPython 3.9以降も必要です。

## 最短で実行

Linuxへこのフォルダをコピーし、フォルダ内で実行します。すでに`xrun`とライセンスが使える端末なら、次の2コマンドだけです。

```bash
make doctor
make run
```

成功すると`PASS: tb_counter (1000 randomized cycles)`を表示します。ログは`build/tb_counter/run/xrun.log`です。`make`だけでも同じサンプルを実行します。

`make`がなくても`bash scripts/xrun.sh run`で実行できます。スクリプトをBash経由で呼ぶので、コピー後の実行権限の付け直しは不要です。

## Xceliumを設定する場合

必要なものは、Linux用Xcelium本体、利用可能なシミュレーションライセンス、Bash、`flock`（util-linux）、基本的なLinuxコマンドです。Makeの短縮コマンドを使う場合はGNU Makeも必要です。GUIにはSimVisionとX表示環境が必要です。

組織で指定されたセットアップスクリプトや`module load`があれば、まずそれを使ってください。個別指定する場合は、以下のファイルを作ります。

```bash
cp env.example.sh env.local.sh
```

`env.local.sh`のコメントを外し、実際のインストール先・ライセンスサーバーに置き換えます。

```bash
export XCELIUM_HOME="/eda/cadence/XCELIUM"
export CDS_LIC_FILE="5280@license-server.example"
```

上記は仮の値です。スクリプトが`XCELIUM_HOME/tools/bin`と`XCELIUM_HOME/bin`をPATHに追加します。既存のPATHやライセンス設定があればそのまま利用できます。`env.local.sh`はGit管理対象外です。

Xcelium本体やライセンスはこの一式には含みません。未導入の場合は組織のEDA管理者から入手し、**使用するXceliumリリースの対応Linuxと依存パッケージ**を確認してください。OS適合性は、そのXceliumに同梱された`checkSysConf`とリリース資料で確認します。Ubuntu/WSLでのスクリプト検証は、Xceliumの対応OS確認を代替しません。

`make doctor`は実行ファイル・バージョン・ライセンス環境変数の設定有無を確認します。**ライセンスを実際に取得できるかは`make run`で確認**してください。環境変数が未設定でも、組織のラッパー等でライセンスを設定している場合があります。

## 普段使うコマンド

| コマンド | 動作 |
| --- | --- |
| `make run` | コンパイルからシミュレーションまで実行。波形保存なし |
| `make waves` | 実行してSHM波形を保存 |
| `make view` | `make waves`で保存した波形をSimVisionで開く |
| `make gui` | SimVisionを時刻0で開く。GUIのRunで開始 |
| `make compile` | コンパイルだけ |
| `make elab` | コンパイルとエラボレーションだけ |
| `make dry-run` | 実行コマンドを表示。xrunやライセンスは不要 |
| `make clean` | このプロジェクトの`build/`を削除 |

GUIのないサーバーでは`make waves`を使えます。波形は`build/tb_counter/waves/waves.shm/`に保存されます。`make gui`と`make view`はX表示可能な端末から実行してください。

## 自分のRTLへ差し替える

1. RTLを`rtl/`、テストベンチを`tb/`に置きます。
2. `sim/files.f`にソースファイルを依存順で列挙します。サンプルの2ファイルは不要なら一覧から外します。
3. テストベンチの**モジュール名**をTOPに指定します。

```bash
make run TOP=tb_my_design
make waves TOP=tb_my_design
make run TOP=tb_my_design FILELIST=sim/my_design.f
```

`FILELIST`の指定はプロジェクトルート基準です。一覧の**内部**は`xrun -F`で読み込むため、一覧ファイル自身のディレクトリを基準に書きます。

```text
// sim/my_design.f の例
+incdir+../rtl/include
../rtl/my_package.sv
../rtl/my_design.sv
../tb/tb_my_design.sv
```

SystemVerilogのpackageは、それをimportするソースより前に置いてください。入れ子の一覧も、その一覧を基準に解決したい場合は`-F child.f`を使います。既存の`-f`一覧を移植する際は相対パスの基準に注意してください。

テストベンチでは成功時に`$finish`、失敗時に`$fatal(1, "理由")`を呼び、無限待ちを防ぐタイムアウトも入れてください。独自テストの合否条件はテストベンチ側で定義します。

## オプション・出力

```bash
# 再現可能な乱数シード、サンプルのランダム試験数
make run SEED=42 XRUN_ARGS='+CYCLES=5000'

# xrunオプションやテスト用plusargを追加
make run XRUN_ARGS='+define+DEBUG +MY_TEST=smoke'

# 実行ディレクトリを分けて並列実行／ログ保存
make run RUN_NAME=trial_42 SEED=42

# 空白などを含む引数は、Bashへ直接渡すと引用を保持できる
bash scripts/xrun.sh run -- '+DATA_FILE=/path/with spaces/input.hex'

# 波形保存用のコマンドだけ確認
bash scripts/xrun.sh waves --dry-run
```

出力は`build/<RUN_NAME>/<run|waves|gui|compile|elab>/`にまとめます。`RUN_NAME`の既定値はTOPです。各ディレクトリにxrunの作業データ、`xrun.log`、再現用の`command.txt`ができます。同じモードを再実行するとログ・波形は更新され、コンパイル用データはxrunが再利用できます。保存したい実行はRUN_NAMEを変えてください。

同じ出力ディレクトリへの同時実行はロックで防ぎます。`make clean`はシミュレーションとSimVisionを終了してから実行してください。

追加引数や`$readmemh`等の実行時相対パスは、**出力ディレクトリが基準**です。データファイルには絶対パスを渡すと確実です。追加の`-f`/`-F`、`-input`にも絶対パスを推奨します。ランナーは環境変数`RTL_ROOT`にプロジェクトの絶対パスを設定します。

xrunの非ゼロ終了コードは呼び出し元に返します。また、ログにCadenceの`*E,`/`*F,`があれば失敗扱いにします。これは任意のテストベンチやUVM独自の合否メッセージをすべて判定する仕組みではありません。

ログが生成されない場合も失敗扱いにします。追加引数で`-l`などのログ出力先を上書きせず、保存先は`RUN_NAME`で切り替えてください。

## 構成

```text
Makefile             よく使うコマンドの入口
env.example.sh       Xcelium・ライセンス設定の例
scripts/xrun.sh      実行・診断・出力管理
sim/files.f         コンパイル対象の一覧
sim/probe.tcl       SHMの記録設定
sim/waves.tcl       波形保存付きバッチ実行
rtl/counter.sv      サンプルRTL
tb/tb_counter.sv    自己チェック付きテストベンチ
build/              生成物（自動作成）
examples/syntax_demo/ 前の20項目をまとめた解説付きRTL/TB・小実験
```

## この一式の検証状況

2026-09-13にUbuntu 22.04 / WSL2で確認しました。

- Bashの構文、Makeからの起動、別ディレクトリからの起動、空白を含むパス・引数を検証済み。
- xrunを模擬するプログラムで、終了コードの保持、エラーログの検出、古いログの誤認防止、同時実行の排他、削除範囲を検証済み。
- サンプルRTLはIcarus Verilog 11.0で、リセット・イネーブル保持・加算・桁あふれと、1,000回／5,000回のランダム試験に合格。加算と非同期リセットを意図的に壊した場合にテストが失敗することも確認済み。
- **xrun本体・SimVision・ライセンス取得は未検証**です。検証用LinuxにはXceliumがありません。実行先で`make doctor`、`make run`、必要なら`make waves`を確認してください。

## 参考資料

- [Cadence: XceliumのPATH設定](https://community.cadence.com/cadence_technology_forums/f/functional-verification/57054/xcelium-21-09-installation-setting-and-manual/1389229)
- [Cadence: ライセンス環境変数](https://community.cadence.com/cadence_technology_forums/f/functional-verification/47926/license-search-order-in-xcelium)
- [Cadence: バッチ実行と波形保存](https://community.cadence.com/cadence_technology_forums/f/functional-verification/58992/using-xcelium-xrun--nogui-option-where-are-the-simulation-results)
- [Cadence: Tclによる波形プローブ](https://community.cadence.com/cadence_technology_forums/f/functional-verification/55541/how-to-generate-waveforms-with-1-xrun-2-xmsim-3-irun-commands)

# IEEE 1800-2017 実験ノート

[実験ノートを開く](index.html) → 目的・期待結果・変更課題・コードを同じ画面で見られます。

添付された**IEEE Std 1800-2017、1,315ページ**を対象にしています。81の学習シナリオに分け、RTL、テストベンチ、SVA、乱数、カバレッジ、ゲート・遅延、DPI/VPIを実験できます。

## まず3つ動かす

LinuxでXceliumとライセンスの設定を済ませ、プロジェクトのルートで実行します。Bash、GNU Make、Python 3.9以降、flockが必要です。

```bash
make doctor
make learn LAB=42 ARGS='+COUNT=2'       # +COUNT → 変数count → 2回出力
make learn LAB=14                      # 同じ時刻のActive / NBA / Postponed
make learn ARGS='+CYCLES=200'           # FIFO総合演習（既定LAB=72）
```

成功時は`LAB_PASS 実験ID checks=...`。ログは`build/learn-実験ID-xrun/run/`です。68〜71は**失敗することを学ぶ実験**なので、所定の診断を確認するとランナーが`EXPECTED_FAIL`と表示します。単にxrunが起動できない、ライセンスが取れない、では期待失敗に数えません。

Xcelium本体・ライセンスは同梱していません。このPCで確認できた範囲は[検証記録](VALIDATION.md)に記載しました。ライセンスのない環境でも、資料の閲覧と`make learn-dry-run`は可能です。

## 操作一覧

| やりたいこと | コマンド |
| --- | --- |
| 全シナリオを一覧 | `make learn-list` |
| 実験の説明だけ読む | `make learn-show LAB=29` |
| 1本実行 | `make learn LAB=29` |
| コマンドの下見 | `make learn-dry-run LAB=39` |
| 全体を実行し、結果を集計 | `make learn-all` |
| SHM波形も保存 | `make learn-waves LAB=72` |
| SHM波形を開く | `make view RUN_NAME=learn-72_integrated_fifo-xrun` |
| 乱数のシード変更 | `make learn LAB=72 SEED=123` |
| 壁時計の制限時間を変更 | `make learn LAB=72 TIMEOUT=300` |
| ローカルの閲覧サーバー起動 | `make learn-open` → `http://127.0.0.1:8765/course/index.html` |
| 直近の一括結果を見る | `make learn-report` |
| 仕様の節を検索 | `python3 course/learn.py ref 6.19` |
| BNFを検索 | `python3 course/learn.py grammar module_declaration` |
| 予約語のコードを探す | `python3 course/learn.py keyword forkjoin` |
| C APIを探す | `python3 course/learn.py api vpi_get_value` |

`ARGS`はxrunに渡す追加引数です。`+CYCLES=...`を読む実験、`+COUNT=...`を読む実験など、実験ごとに入口が異なります。各READMEを先に確認してください。`+define+...`はコンパイル時、`+NAME=value`は実行時の指定です。通常のソース更新は再実行時に再コンパイルされます。

## 読む順番

| コース | シナリオ | 内容 |
| --- | --- | --- |
| 言語の基本 | 01〜14 | リテラル、型、配列、構造体、演算、代入、関数、スケジューリング |
| 検証の道具 | 15〜26 | 並列処理、通信、class、制約付き乱数、coverage、SVA、checker |
| 回路の構成 | 27〜38 | package、generate、interface、clocking、program、net、UDP、遅延、config |
| C・入出力・応用 | 39〜58 | DPI/VPI、ファイル、システム関数、発展SVA/coverage、古典的機能 |
| 規格の読み解き | 59〜67 | 保護envelope、BNF、予約語、標準package、Cヘッダー、廃止項目、形式的意味 |
| 失敗と総合演習 | 68〜72 | 名前・型・refのエラー、意図したassert失敗、FIFO総合検証 |
| 隅の文法まで | 73〜81 | 全ゲート系、強度・電荷、宣言形式、forkjoin、条件付きパス、interconnect |

各実験は`labs/実験ID/`にあります。主に`tb.sv`を開き、`CHECK`の式と説明を読むと観察点が分かります。総合演習72では、[fifo.sv](labs/72_integrated_fifo/fifo.sv)がRTL、[tb.sv](labs/72_integrated_fifo/tb.sv)がクラス・乱数・正解モデル・SVA・coverageを組み合わせたTBです。FIFOはfull時のpushを拒否し、empty時のpopを拒否します。同時push/popも**エッジ前のfull/empty**で受理を判断します。

`+INJECT_FAIL`を通常の実験に渡すと、終了直前に意図的に失敗させられます。例: `make learn LAB=42 ARGS='+INJECT_FAIL'`。23の`+BREAK_PROTOCOL`、36の`+VIOLATE`など、機能固有の故障・違反実験も用意しました。

## 「全体を辿れる」の範囲

- 全41章・17付録、目次にある全593項目を索引化しています。さらに本文の小節見出し、付録Aと本文追加のBNF、C API、全ページの本文を検索できます。
- 付録Bの**248予約語すべてに、コード上の使用例**があります。条件付き分岐も含み、全分岐をこのPCで実行済みという意味ではありません。
- [全節の対応表](COVERAGE_MAP.md)で、明示的な参照と「関連する章の実験への入口」を区別しています。1つの例がその節のすべての意味規則や境界条件を検証するわけではありません。
- 37章の全オブジェクトモデルや38章の全VPIルーチンは索引・発展課題でも扱います。実装したCの呼出し例は別表示です。全APIを自動実行する適合性試験ではありません。
- 41章は、この2017版では**廃止の注記のみ**です。存在しないAPI説明を補っていません。付録D/Eのoptional機能、保護envelopeの暗号方式・鍵、ツール独自CLIも別扱いです。

本文とBNFの抽出では脚注・改行・表の並びに組版差が出ます。図、太字の終端記号、文法上の細かい条件は、索引からPDF原本の該当ページを開いて確認してください。

## C連携・外部機能

39/40のDPIは、Cファイルもxrunへ渡して一緒にビルドします。導入版が要求するCコンパイラを利用してください。41/57/58のVPIは`cc -fPIC -shared`でプラグインを作り、`-loadvpi`でロードします。

```bash
export CC=/path/to/supported/cc
export VPI_INCLUDE=/path/to/xcelium/tools/include
export DPI_INCLUDE=/path/to/xcelium/tools/include
make learn LAB=39
make learn LAB=41
```

ヘッダーの位置は`XCELIUM_HOME`やxrunの場所からも探します。58は`sv_vpi_user.h`とAssertion APIの実装、45はコードカバレッジの計測機能、36は有効なタイミングチェックが必要です。見つからない機能を合格扱いにしません。38はconfig/library mapの専用起動です。

59の保護envelopeは[手順書](labs/59_protection/GUIDE.md)に従います。平文比較は`make learn LAB=59 ARGS=+PLAIN`、保護済み入力は`PROTECTED_SOURCE=/absolute/path/protected.sv`を指定します。暗号化ツールと鍵がない状態で保護・復号の成功を装うダミーは含めていません。

77の明示的な`untyped`形式は`ARGS=+define+EXPLICIT_UNTYPED`で選びます。pyslang 11.0.0ではその形式を解析できなかったため、既定の等価な暗黙形式とは検証状況を区別しています。

## 結果の読み方

| 表示 | 意味 |
| --- | --- |
| `PASS` | 実行して自動照合と完走マーカーを確認 |
| `EXPECTED_FAIL` | 意図したエラーの実験で、指定の診断を確認 |
| `FAIL` | 予期しない失敗、必要な診断なし、完走なし、またはタイムアウト |
| `BLOCKED` | ツール・ヘッダーなど実行条件が不足 |
| `SKIP` | 選んだエンジンの検証対象外。成功ではない |
| `READING` | 仕様書を読む課題。実行合格ではない |
| `EXTERNAL_REQUIRED` | 暗号化など外部の準備が必要 |
| `STATIC_OK` | pyslangによる静的検査。実行合格ではない |

一括実行は`build/course-results/xrun.json`または`icarus.json`へ保存します。単独実行は別名で保存するため、一括記録を消しません。ソースのハッシュも記録しています。画面のチェックボックスは、自分の学習進捗をブラウザー内に保存するだけです。

索引のPDF参照と検証記録の出力先は、プロジェクトを基準とする相対パスで保存します。共有する教材の中では、ユーザー名や個人フォルダー名を含まない表記になります。

## Icarusで確認できる部分

```bash
make learn-all ENGINE=icarus
```

Icarus、vvp、VPI実験にはccとIcarus付属ヘッダーが必要です。必要なら`IVERILOG`、`IVERILOG_BASE`、`VVP`、`VPI_INCLUDE`を指定します。Icarus対象外のclass、SVA、clockingなどは明示的にSKIPします。Icarusの成功はXceliumでの成功を保証しません。

`SEED`はxrunの`-svseed`に渡す設定です。Icarus側へは適用しません。44の古典的分布関数はコード内のseed変数を明示的に変更します。

## PDFを持ち運ぶ

配布用アーカイブには元PDFと全文のローカルコピーを含めません。自分のLinux環境に同じPDFを置き、次で索引と原本へのリンクを作り直せます。

```bash
python3 -m venv build/pdf-index-env
build/pdf-index-env/bin/pip install pypdfium2
build/pdf-index-env/bin/python course/tools/index_reference.py /absolute/path/to/SystemVerilog.pdf
```

`reference.local.pdf/json/js`はローカル専用です。PDFのない状態でも、実験・BNF・節・予約語・C APIの索引は利用できます。画面を直接開いて検索・コピーが制限される場合は`make learn-open`を使ってください。

CLIについて確認した一次情報: [slangのコマンド仕様](https://www.sv-lang.com/command-line-ref.html)、[CadenceのDPI説明](https://community.cadence.com/cadence_technology_forums/f/functional-verification/16408/importing-c-function-into-system-verilog-using-incisive-dpi)、[Cadenceのcoverage説明](https://community.cadence.com/cadence_technology_forums/f/functional-verification/62425/xcelium-dump-coverage-information-in-the-middle-of-a-simulation)。言語の意味は添付2017版を基準にしています。

# 作成時の検証記録

記録日: 2026-09-14。検証したソースのSHA-256と各実験の結果は[verification.json](verification.json)に保存しています。画面のバッジもこの記録を表示します。編集後の再検証結果は`build/course-results/`に別途保存されます。

## 確認できたこと

| 検査 | 結果 |
| --- | --- |
| pyslang 11.0.0 / IEEE 1800-2017 | 68件で文法・型検査のエラーなし、3件で期待した拒否、10件は静的検査の対象外 |
| Icarus Verilog 11.0 / Ubuntu 22.04 / WSL2 | 正常実験19件がPASS、意図した失敗3件がEXPECTED_FAIL。読解8件、対象外51件は実行合格に含めない |
| FIFOの実RTL | 深さ1・3・4・5で各1000回のランダム刺激、full/empty、回り込み、非同期リセットを照合 |
| FIFO検査の故障検出力 | データ反転、write/read pointer停止、full/empty保護除去、reset不良の6種類をすべて検出 |
| 実行環境 | 9検証グループが合格。ログ欠落、無関係な失敗、ライセンスエラー、時間切れを成功扱いしない |
| 追加の実行条件 | COUNT=2で出力が16/32の2行、VCD生成、COUNT=0と故障注入の拒否、min=1ns / max=5nsを確認 |
| 仕様の索引 | 全41章・17付録、目次593項目、合計1670見出し、BNF 867規則、248予約語のコード使用例 |
| ブラウザー | plusargs・節番号・予約語・BNF・C API・PDF全文の検索、コード表示、引数編集とコピー、検証バッジを操作確認。確認中のコンソールエラーなし |
| Linuxへの持ち運び | 配布アーカイブを空白入りの別パスへ展開し、実際のIcarus実行、xrun引数生成、予約語・節の検索を確認 |

実行時の判定は`LAB_PASS`と各自動照合に基づきます。期待した失敗の実験には対応する診断が必要です。Icarusの正常19件には、実際のCコンパイルとVPIロードを行った41/57、specify遅延の35、SDFで4nsへ変更した37も含まれます。

## 未検証の範囲

このPCにはxrun本体・利用できるライセンスがありません。Xceliumでの全体実行、SimVision、SHM、CのDPI連携、config、Assertion/coverage API、保護envelopeは実行未確認です。xrun起動引数の検査はスタブで行い、実機検証とは区別しています。

pyslangの静的検査はタイミング・SVAの実行結果やcoverage到達率を検証しません。独自VPIシステム関数のC ABIも検証しません。警告がある教育用コードを含み、「エラーなし」は「警告ゼロ」ではありません。73等の古典的ゲート機能のIcarus対応も、全シミュレーターとの等価性を意味しません。

77の`+define+EXPLICIT_UNTYPED`分岐はpyslang 11.0.0が解析できず、既定の暗黙untyped形式だけを静的検査しました。68/69/70はコンパイル拒否を学ぶ実験です。Icarus実行での失敗確認は68/69/71であり、静的検査の3件とは一致しません。

72のクラス・乱数・SVA・coverageを含む総合TBは静的検査までです。FIFOの実行検査には別の[独立TB](tests/tb_fifo_portable.sv)を用い、RTLの循環ポインターとは異なる、配列を詰める正解モデルでデータ順序を照合しています。

全248予約語の「コードあり」には条件付き分岐やlibrary/configも含みます。各節の全意味規則、全C API、全BNFの組合せを実行した適合性試験ではありません。原文の索引・実験・発展課題を組み合わせて全体を辿る教材です。

## 同じ検査を実行する

LinuxにIcarus/vvp、Cコンパイラ、VPIヘッダーを設定して実行します。ローカルに展開したツールには`IVERILOG`、`IVERILOG_BASE`、`VVP`、`VPI_INCLUDE`を指定できます。

```bash
make learn-all ENGINE=icarus
python3 course/tests/validate_environment.py
python3 course/tests/validate_variants.py
```

静的検査は任意のPython仮想環境に`pyslang==11.0.0`を入れて`python3 course/tools/lint_slang.py`を実行します。別ディレクトリに導入した場合は`--python-path /path/to/packages`を付けます。

本来の対象環境では`make doctor`、`make learn LAB=42`、`make learn-all`の順で実行してください。ログは`build/learn-実験ID-xrun/`、集計は`build/course-results/xrun.json`へ保存します。必要なライセンスや機能がないものは結果を確認し、SKIPやBLOCKEDをPASSに読み替えないでください。

## 実験ごとの記録

| 実験 | 静的検査 | Icarus実行 |
| --- | --- | --- |
| [01_lexical](labs/01_lexical/README.md) | STATIC_OK | SKIP |
| [02_directives](labs/02_directives/README.md) | STATIC_OK | PASS |
| [03_types](labs/03_types/README.md) | STATIC_OK | PASS |
| [04_enum_cast](labs/04_enum_cast/README.md) | STATIC_OK | SKIP |
| [05_struct_union](labs/05_struct_union/README.md) | STATIC_OK | SKIP |
| [06_arrays](labs/06_arrays/README.md) | STATIC_OK | PASS |
| [07_collections](labs/07_collections/README.md) | STATIC_OK | SKIP |
| [08_strings](labs/08_strings/README.md) | STATIC_OK | SKIP |
| [09_expressions](labs/09_expressions/README.md) | STATIC_OK | SKIP |
| [10_assignments](labs/10_assignments/README.md) | STATIC_OK | PASS |
| [11_control_flow](labs/11_control_flow/README.md) | STATIC_OK | SKIP |
| [12_subroutines](labs/12_subroutines/README.md) | STATIC_OK | SKIP |
| [13_lifetime](labs/13_lifetime/README.md) | STATIC_OK | SKIP |
| [14_scheduling](labs/14_scheduling/README.md) | STATIC_OK | PASS |
| [15_processes](labs/15_processes/README.md) | STATIC_OK | SKIP |
| [16_communication](labs/16_communication/README.md) | STATIC_OK | SKIP |
| [17_classes](labs/17_classes/README.md) | STATIC_OK | SKIP |
| [18_inheritance](labs/18_inheritance/README.md) | STATIC_OK | SKIP |
| [19_generic_types](labs/19_generic_types/README.md) | STATIC_OK | SKIP |
| [20_random](labs/20_random/README.md) | STATIC_OK | SKIP |
| [21_random_sequences](labs/21_random_sequences/README.md) | STATIC_OK | SKIP |
| [22_coverage](labs/22_coverage/README.md) | STATIC_OK | SKIP |
| [23_assertions](labs/23_assertions/README.md) | STATIC_OK | SKIP |
| [24_sequences](labs/24_sequences/README.md) | STATIC_OK | SKIP |
| [25_properties](labs/25_properties/README.md) | STATIC_OK | SKIP |
| [26_checker_bind](labs/26_checker_bind/README.md) | STATIC_OK | SKIP |
| [27_hierarchy](labs/27_hierarchy/README.md) | STATIC_OK | PASS |
| [28_interfaces](labs/28_interfaces/README.md) | STATIC_OK | SKIP |
| [29_clocking](labs/29_clocking/README.md) | STATIC_OK | SKIP |
| [30_program](labs/30_program/README.md) | STATIC_OK | SKIP |
| [31_nettypes](labs/31_nettypes/README.md) | STATIC_OK | SKIP |
| [32_gates](labs/32_gates/README.md) | STATIC_OK | PASS |
| [33_switches](labs/33_switches/README.md) | STATIC_OK | PASS |
| [34_udp](labs/34_udp/README.md) | STATIC_OK | PASS |
| [35_specify](labs/35_specify/README.md) | STATIC_OK | PASS |
| [36_timing_checks](labs/36_timing_checks/README.md) | STATIC_OK | SKIP |
| [37_sdf](labs/37_sdf/README.md) | STATIC_OK | PASS |
| [38_config](labs/38_config/README.md) | NOT_CHECKED | SKIP |
| [39_dpi](labs/39_dpi/README.md) | STATIC_OK | SKIP |
| [40_dpi_arrays](labs/40_dpi_arrays/README.md) | STATIC_OK | SKIP |
| [41_vpi](labs/41_vpi/README.md) | STATIC_OK | PASS |
| [42_fileio](labs/42_fileio/README.md) | STATIC_OK | PASS |
| [43_utilities](labs/43_utilities/README.md) | STATIC_OK | PASS |
| [44_distributions](labs/44_distributions/README.md) | STATIC_OK | PASS |
| [45_coverage_api](labs/45_coverage_api/README.md) | STATIC_OK | SKIP |
| [46_tagged_union](labs/46_tagged_union/README.md) | STATIC_OK | SKIP |
| [47_alias_ports](labs/47_alias_ports/README.md) | STATIC_OK | SKIP |
| [48_sva_operators](labs/48_sva_operators/README.md) | STATIC_OK | SKIP |
| [49_multiclock](labs/49_multiclock/README.md) | STATIC_OK | SKIP |
| [50_coverage_bins](labs/50_coverage_bins/README.md) | STATIC_OK | SKIP |
| [51_constraint_control](labs/51_constraint_control/README.md) | STATIC_OK | SKIP |
| [52_process_handles](labs/52_process_handles/README.md) | STATIC_OK | SKIP |
| [53_preprocessor_edges](labs/53_preprocessor_edges/README.md) | STATIC_OK | SKIP |
| [54_legacy_storage](labs/54_legacy_storage/README.md) | STATIC_OK | PASS |
| [55_file_positions](labs/55_file_positions/README.md) | STATIC_OK | PASS |
| [56_stochastic_pla](labs/56_stochastic_pla/README.md) | STATIC_OK | SKIP |
| [57_vpi_callbacks](labs/57_vpi_callbacks/README.md) | STATIC_OK | PASS |
| [58_assertion_api](labs/58_assertion_api/README.md) | STATIC_OK | SKIP |
| [59_protection](labs/59_protection/README.md) | NOT_CHECKED | SKIP |
| [60_bnf](labs/60_bnf/README.md) | NOT_CHECKED | READING |
| [61_keywords](labs/61_keywords/README.md) | NOT_CHECKED | READING |
| [62_standard_package](labs/62_standard_package/README.md) | NOT_CHECKED | READING |
| [63_foreign_headers](labs/63_foreign_headers/README.md) | NOT_CHECKED | READING |
| [64_deprecated_api](labs/64_deprecated_api/README.md) | NOT_CHECKED | READING |
| [65_formal_semantics](labs/65_formal_semantics/README.md) | NOT_CHECKED | READING |
| [66_vpi_object_model](labs/66_vpi_object_model/README.md) | NOT_CHECKED | READING |
| [67_reading_map](labs/67_reading_map/README.md) | NOT_CHECKED | READING |
| [68_bad_implicit](labs/68_bad_implicit/README.md) | EXPECTED_REJECT | EXPECTED_FAIL |
| [69_bad_enum](labs/69_bad_enum/README.md) | EXPECTED_REJECT | EXPECTED_FAIL |
| [70_bad_ref](labs/70_bad_ref/README.md) | EXPECTED_REJECT | SKIP |
| [71_expected_assert](labs/71_expected_assert/README.md) | STATIC_OK | EXPECTED_FAIL |
| [72_integrated_fifo](labs/72_integrated_fifo/README.md) | STATIC_OK | SKIP |
| [73_gate_families](labs/73_gate_families/README.md) | STATIC_OK | PASS |
| [74_charge_strength](labs/74_charge_strength/README.md) | STATIC_OK | SKIP |
| [75_declaration_forms](labs/75_declaration_forms/README.md) | STATIC_OK | SKIP |
| [76_control_edges](labs/76_control_edges/README.md) | STATIC_OK | SKIP |
| [77_property_forms](labs/77_property_forms/README.md) | STATIC_OK | SKIP |
| [78_interface_broadcast](labs/78_interface_broadcast/README.md) | STATIC_OK | SKIP |
| [79_conditional_paths](labs/79_conditional_paths/README.md) | STATIC_OK | SKIP |
| [80_coverage_selection](labs/80_coverage_selection/README.md) | STATIC_OK | SKIP |
| [81_interconnect](labs/81_interconnect/README.md) | STATIC_OK | SKIP |

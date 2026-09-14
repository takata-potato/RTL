# 41_vpi — VPIで回路を探索しシステム関数を追加

$lab_peek("tb.target")をCで定義し、指定された信号を階層名で読む。

```bash
make learn LAB=41_vpi
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | SVのtarget=42をVPIで読み、続いて99へ変えて再び読む。 |
| 1か所変える実験 | 階層名を存在しないものへ変えると、未取得を値0として扱わず失敗する。 |
| 文法 | vpi_register_systf / vpiSysFunc / vpiIntFunc / calltf / compiletf / vpi_handle / vpi_iterate / vpi_scan / vpi_get_value / vpi_put_value / vpi_handle_by_name |
| 仕様書 | §36、§37、§38、§K、§L、§M（詳細なページは索引から開く） |
| 実験形式 | vpi |
| Icarus対象 | あり |

VPI用共有ライブラリーをLinuxのccと実行するシミュレータの付属ヘッダーでビルドする。VPI_INCLUDEでヘッダーの場所を指定可能。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

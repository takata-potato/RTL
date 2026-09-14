# 63_foreign_headers — DPI/VPIヘッダーとAPI索引

PDFのC宣言を、実行先ツールのヘッダーと比べる。

```bash
make learn LAB=63_foreign_headers
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 索引から全vpi_*/sv*宣言へ移動できる。39/40/41/57/58のCコードが利用例。 |
| 1か所変える実験 | sizeof(svLogicVecVal)、sizeof(PLI_INT32)、配列APIの返却型を実際のCコンパイラで調べる。 |
| 文法 | svdpi.h / vpi_user.h / vpi_compatibility.h / sv_vpi_user.h / PLI_INT32 / vpiHandle / svLogic / svBitVecVal / svLogicVecVal / ABI |
| 仕様書 | §35、§36、§37、§38、§39、§40、§H、§I、§J、§K、§L、§M（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

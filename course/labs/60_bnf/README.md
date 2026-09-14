# 60_bnf — BNFからコードを組み立てる

付録Aの全生成規則を索引で検索し、実際のコードへ辿る。

```bash
make learn LAB=60_bnf
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 索引でmodule_declaration→module_ansi_header→parameter_port_listを辿り、27_hierarchyと対応する。 |
| 1か所変える実験 | 同じmoduleをANSI形式と非ANSI形式で2通り記述し、ポートの同値性を確認する。 |
| 文法 | source_text / library_text / ::= / alternative / optional / repetition / terminal / nonterminal |
| 仕様書 | §1.6、§A（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

BNFだけでは型・スコープ・時間の意味は決まらない。索引には付録Aの生成規則に加え、本文の「not in Annex A」のシステムタスク文法も収録。各ページの原文を同じ画面で読める。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

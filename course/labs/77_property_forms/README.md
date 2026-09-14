# 77_property_forms — assume/restrict・expect・残りのproperty形式

assert以外の検証文と、終了条件を含むpropertyの形式を試す。

```bash
make learn LAB=77_property_forms
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | goの次サイクルにdone。expectが完了するまで待ち、検査後に終了する。 |
| 1か所変える実験 | 仮定assumeは形式検証では入力条件、シミュレーションでは検査となる点を区別する。 |
| 文法 | assume / restrict / expect / weak / strong / nexttime / eventually / always / s_always / until / until_with / s_until_with / implies / iff / untyped |
| 仕様書 | §16.12、§16.14、§16.17、§11.12（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

restrictは形式検証向けでシミュレーションの動作を拘束しない。`ARGS=+define+EXPLICIT_UNTYPED`でuntypedを明記する形式も試せる。既定は意味が同じ暗黙形式。pyslang 11.0.0は明示untyped形式を解析できなかったため、その分岐はXceliumでの確認が必要。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

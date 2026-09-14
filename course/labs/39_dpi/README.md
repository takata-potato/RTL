# 39_dpi — DPIでSVとCを往復する

純粋なC関数、C→SVコールバック、Cが管理するハンドルを使う。

```bash
make learn LAB=39_dpi
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | C add(4,5)=9、CからSVのdoubleを呼んで18、chandle経由で42を保存。 |
| 1か所変える実験 | Cの加算を減算へ変えるとSVの自動照合が失敗する。 |
| 文法 | DPI-C / import pure function / import context function / export function / C linkage / chandle / svdpi.h |
| 仕様書 | §35、§6.14、§H.1、§H.2、§H.3、§H.4、§H.5、§H.6、§H.7、§H.9、§H.10、§I、§J（詳細なページは索引から開く） |
| 実験形式 | dpi |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

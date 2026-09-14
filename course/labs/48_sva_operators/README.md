# 48_sva_operators — SVA演算子を同じ波形で比べる

a→b→b→cの有限トレースを複数の書き方で検査する。

```bash
make learn LAB=48_sva_operators
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | gotoで2回目のbへ到達し、その次にc。accept/reject条件は普段0。 |
| 1か所変える実験 | 中断信号abort_signalを1にし、acceptとrejectの結論の差を見る。 |
| 文法 | nonconsecutive repetition [=] / goto repetition [->] / within / or / and / iff / implies / nexttime / s_nexttime / eventually / s_eventually / accept_on / reject_on / sync_accept_on / sync_reject_on |
| 仕様書 | §16.9、§16.12（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

# 57_vpi_callbacks — VPI callback・値変更・シミュレーション時刻

VPIは信号の変化をコールバックで受け取れる。時刻と値をCから表示する。

```bash
make learn LAB=57_vpi_callbacks
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | targetを0→1→2に変更し、callbackの回数をシステム関数で取得する。 |
| 1か所変える実験 | cbValueChangeをcbReadOnlySynchへ変える場合に必要な登録時刻・再登録を規格で確認する。 |
| 文法 | cbStartOfSimulation / cbValueChange / cbReadOnlySynch / cbAfterDelay / vpi_register_cb / vpi_get_time / vpi_get_str / vpi_put_value / vpi_chk_error |
| 仕様書 | §36.8、§36.10、§37.18、§37.72、§37.73、§37.74、§37.81、§38（詳細なページは索引から開く） |
| 実験形式 | vpi |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

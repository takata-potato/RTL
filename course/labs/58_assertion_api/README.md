# 58_assertion_api — CからSVAの成功を観測する

アサーション名のハンドルを取得し、nonvacuous成功のcallbackを登録する。

```bash
make learn LAB=58_assertion_api
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | a_readyの成功回数をCで数え、SVの$lab_assertion_count()から確認する。 |
| 1か所変える実験 | readyを0にして失敗callbackへ変更する。API初期化はstart-of-simulationと同じとは限らない。 |
| 文法 | vpiAssertion / cbAssertionSysInitialized / vpi_register_assertion_cb / cbAssertionSuccess / vpi_control / assertion attempt information |
| 仕様書 | §39、§M（詳細なページは索引から開く） |
| 実験形式 | vpi |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

sv_vpi_user.hとAssertion APIの実装が必要。ヘッダーや関数がない場合は未対応として記録し、通常のSVA実験23で動作を別途確認する。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。

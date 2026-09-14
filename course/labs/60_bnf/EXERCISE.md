# BNFを使った実験

- `python3 course/learn.py grammar module_declaration` で規則を探す。
- `[...]`は任意、`{...}`は0回以上、`|`は選択。太字で表す実トークンとの違いはPDF原本で確認する。
- 27_hierarchyのlaneへparameterを1個追加し、named/ordered両形式で指定する。
- 47_alias_portsの非ANSI形式と比較する。
- 68_bad_implicitのように「文法は通るが名前解決で失敗する」例を作る。

合格条件: 生成規則のどの枝を使ったか説明でき、実行結果を変更前と比較できる。

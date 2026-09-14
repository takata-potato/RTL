# この実験の完了条件

1. `make learn LAB=59_protection ARGS=+PLAIN` で平文の結果を記録する。
2. Xceliumに付属する暗号化ツールのヘルプで、鍵名・暗号方式・入力形式を確認する。規格34章は特定ツールのCLIを規定しない。
3. `source.sv`を保護し、生成物を自分のファイルとして保存する。
4. `python3 course/tools/protect_inspect.py /path/to/protected.sv`でenvelopeを確認する。この操作は復号しない。
5. `make learn LAB=59_protection PROTECTED_SOURCE=/absolute/path/protected.sv`で同じTBを実行する。

比較項目は「正常時のy=0xb7」「必要な鍵」「コンパイル診断」「階層やソース閲覧の制限」。
`+PLAIN`の成功は保護機能の成功ではない。規格のx-caesar/rot13例は構造説明用で、実用的な秘匿方式の選択例にはしない。

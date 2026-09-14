# オブジェクトモデルを読む順序

1. 37.2の凡例で関係の向きと1対多を確認する。
2. 41_vpiのvpi_handle_by_nameでtb.targetを取得する。
3. vpi_get(vpiType,handle)、vpi_get(vpiSize,handle)、vpi_get_str(vpiFullName,handle)を比べる。
4. 規格の図で合法なiterateのtypeとreference handleの組を探す。
5. int、packed struct、unpacked array、interfaceを27/28の階層に足して同じ操作を比較する。

vpi_iterateがNULLを返すのは「子が0件」でも起こる。vpi_chk_errorでAPIエラーと区別する。
vpi_scanは列挙完了でiteratorを解放する。途中で中断する場合は対応する解放APIを使う。
全83小節の対象図と、38章の全ルーチンは別々に索引化してある。1個の信号read成功を全モデル対応とはみなさない。

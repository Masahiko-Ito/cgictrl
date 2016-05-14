#! /usr/bin/ruby
# coding: utf-8
#
# cgictrl ver.0.2 2012.12.17 Masahiko Ito <m-ito@myh.no-ip.org>
#
#   ユーザコーディングサンプルスクリプト
#
require "cgi"
require "uri"
require "nkf"
require "cgictrl_common"
#--- user coding start ---
#--- user coding end   ---
#
# メイン処理
#
def main()
	cc = Cgictrl.new
	cc.start(cc.default_nkf_param)
	sub_open(cc)
	if (cc.is_send())
		next_tran = sub_send(cc)
	else
		next_tran = sub_recieve(cc)
	end
	sub_close(cc)
	cc.end(next_tran)
	exit 0
end
#
# オープン処理
#
#    o DB接続 etc
#
def sub_open(cc)
#--- user coding start ---
#--- user coding end   ---
end
#
# 画面編集処理
#
#   o spaにより渡されたデータを元に画面を編集する
#   o 次に起動するトランザクション(通常は自トランザクションと同じ)を返す
#
def sub_send(cc)
#--- user coding start ---
	pi = 3.14
	html_param = {}
	html_param["hankei"] = cc.get_spa("hankei")
	html_param["menseki"] = pi * cc.get_spa("hankei").to_f ** 2
	html_param["taiseki"] = 4.0 / 3.0 * pi * cc.get_spa("hankei").to_f ** 3

	cc.out_html("samp_calc_result", html_param)

	return "SAMP_CALC_RESULT"
#--- user coding end   ---
end
#
# 入力データ処理
#
#   o 入力データを処理する
#   o 次のトランザクションに渡すデータをspaにセットする
#   o 次に起動するトランザクションを返す
#
def sub_recieve(cc)
#--- user coding start ---
	cc.set_spa("err_sw", "")

	return "SAMP_CALC_ENTRY"
#--- user coding end   ---
end
#
# クローズ処理
#
#    o DB切断 etc
#
def sub_close(cc)
#--- user coding start ---
#--- user coding end   ---
end
#
# その他のユーザ関数定義
#
#--- user coding start ---
#--- user coding end   ---
#
# メイン処理開始
#
main()

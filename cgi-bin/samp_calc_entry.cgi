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
	html_param = {}

	html_param["hankei"] = cc.get_spa("hankei")

	if (cc.get_spa("err_sw") == "ER01")
		html_param["msg_color"] = "red"
		html_param["msg"] = "数字を入力して下さい"
	end

	cc.out_html("samp_calc_entry", html_param)

	return "SAMP_CALC_ENTRY"
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

	r = cc.get_input("hankei") 
	r.strip!
	if (/^[+-]*[0-9\.]+$/ !~ r)
		cc.set_spa("err_sw", "ER01")
	end

	cc.set_spa("hankei", r)

	if (cc.get_spa("err_sw") == "")
		return "SAMP_CALC_RESULT"
	else
		return "SAMP_CALC_ENTRY"
	end
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

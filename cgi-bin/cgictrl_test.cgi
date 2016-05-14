#! /usr/bin/ruby -I.
# coding: utf-8
#
# cgictrl by Masahiko Ito <m-ito@myh.no-ip.org>
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
	html_param["param"] = "setted_param"
	html_param["input_text"] = cc.get_spa("input_text")
	html_param["input_file"] = cc.get_spa("input_file")
	html_param["input_file_data"] = cc.get_spa("input_file_data")
	html_param["textarea"] = cc.get_spa("textarea")
	html_param["referer"] = ENV['HTTP_REFERER'].gsub(/cgi-bin\/.*/, "")
	cc.out_html("sample1", html_param)

	return "TEST"
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
	cc.set_spa("input_text", "==" + cc.get_input("input_text") + "==")
	cc.set_spa("input_file", "==" + cc.get_input("input_file") + "==")
	cc.set_spa("input_file_data", "==" + cc.get_input_file("input_file") + "==")
	cc.set_spa("textarea", "==" + cc.get_input("textarea") + "==")

	return "TEST"
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

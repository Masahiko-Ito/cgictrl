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
require "csvutil"
$csv = ""
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
	$csv = Csvutil.new(cc.get_realres("RES_ADDR"))
#--- user coding end   ---
end
#
# 画面編集処理
#
#   o spaにより渡されたデータ(cc.get_spa("...."))を元に画面を編集する
#   o 次に起動するトランザクション(通常は自トランザクションと同じ)を返す
#
def sub_send(cc)
#--- user coding start ---
	html_param = {}
	cc.out_html("samp_addr_view_head", html_param)

	hash_key = {}
	if (cc.get_spa("name") != "")
		hash_key["name"] = cc.get_spa("name")
	end
	if (cc.get_spa("zipcode") != "")
		hash_key["zipcode"] = cc.get_spa("zipcode")
	end
	if (cc.get_spa("address") != "")
		hash_key["address"] = cc.get_spa("address")
	end
	if (cc.get_spa("birthday") != "")
		hash_key["birthday"] = cc.get_spa("birthday")
	end
	if (hash_key.size == 0)
		hash_key["name"] = "^.*$"
	end
	msg = "データが見つかりませんでした"
	$csv.read_each(hash_key) {|hash_rec|
		msg = ""
		html_param = {}
		html_param["name"] = hash_rec["name"]
		html_param["zipcode"] = hash_rec["zipcode"]
		html_param["address"] = hash_rec["address"]
		html_param["birthday"] = hash_rec["birthday"]
		cc.out_html("samp_addr_view_body", html_param)
		msg = ""
	}

	html_param = {}
	html_param["msg"] = msg
	if (msg != "")
		html_param["msg_color"] = "red"
	end
	cc.out_html("samp_addr_view_tail", html_param)

	return "SAMP_ADDR_READ"
#--- user coding end   ---
end
#
# 入力データ処理
#
#   o 入力データ(cc.get_input("...."))を処理する
#   o 次のトランザクションに渡すデータをspaにセットする
#   o 次に起動するトランザクションを返す
#
def sub_recieve(cc)
#--- user coding start ---
	cc.set_spa("err_sw", "")

	if (cc.get_spa("err_sw") == "")
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		return "SAMP_ADDR_READ"
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

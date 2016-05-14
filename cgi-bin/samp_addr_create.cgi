#! /usr/bin/ruby
#
# cgictrl ver.0.1 2009.07.07 Masahiko Ito <m-ito@myh.no-ip.org>
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

	html_param["name"] = cc.get_spa("name")
	html_param["zipcode"] = cc.get_spa("zipcode")
	html_param["address"] = cc.get_spa("address")
	html_param["birthday"] = cc.get_spa("birthday")

	cc.out_html("samp_addr_entry", html_param)

	return "SAMP_ADDR_CREATE"
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

	if (cc.get_input("ok") != "")
		hash_rec = {}
		hash_rec["name"] = cc.get_spa("name")
		hash_rec["zipcode"] = cc.get_spa("zipcode")
		hash_rec["address"] = cc.get_spa("address")
		hash_rec["birthday"] = cc.get_spa("birthday")
		$csv.create(hash_rec)
		$csv.vacuum()
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("ok") != "")
			cc.set_spa("err_sw", "OK_ADD")
		end
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		return "SAMP_ADDR_CREATE"
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

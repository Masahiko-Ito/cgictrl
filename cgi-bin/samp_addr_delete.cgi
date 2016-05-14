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
	msg = "データが見つかりませんでした"
	if (cc.get_spa("err_sw") == "ER_NOSEL")
		msg = "削除を選択して下さい"
	end

	html_param = {}
	cc.out_html("samp_addr_delete_head", html_param)

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
	number = 0
	$csv.read_each(hash_key) {|hash_rec|
		html_param = {}
		html_param["number"] = number
		html_param["name"] = hash_rec["name"]
		html_param["zipcode"] = hash_rec["zipcode"]
		html_param["address"] = hash_rec["address"]
		html_param["birthday"] = hash_rec["birthday"]
		cc.out_html("samp_addr_delete_body", html_param)

		cc.set_spa("#{number}_name", hash_rec["name"])
		cc.set_spa("#{number}_zipcode", hash_rec["zipcode"])
		cc.set_spa("#{number}_address", hash_rec["address"])
		cc.set_spa("#{number}_birthday", hash_rec["birthday"])

		if (cc.get_spa("err_sw") == "")
			msg = ""
		end

		number += 1
	}
	cc.set_spa("record_number", number)

	html_param = {}
	html_param["msg"] = msg
	if (msg != "")
		html_param["msg_color"] = "red"
	end
	cc.out_html("samp_addr_delete_tail", html_param)

	return "SAMP_ADDR_DELETE"
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
		cc.set_spa("err_sw", "ER_NOSEL")
		number = 0
		while (number < cc.get_spa("record_number").to_i)
			if (cc.get_input("ck_#{number}") != "")
				cc.set_spa("err_sw", "")
			end
			number += 1
		end

		if (cc.get_spa("err_sw") == "")
			number = 0
			while (number < cc.get_spa("record_number").to_i)
				if (cc.get_input("ck_#{number}") != "")
					hash_key = {}
					hash_key["name"] = cc.get_spa("#{number}_name")
					hash_key["zipcode"] = cc.get_spa("#{number}_zipcode")
					hash_key["address"] = cc.get_spa("#{number}_address")
					hash_key["birthday"] = cc.get_spa("#{number}_birthday")

					$csv.delete(hash_key)
				end
				number += 1
			end

			$csv.vacuum()
		end
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("ok") != "")
			cc.set_spa("err_sw", "OK_DEL")
		end
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		return "SAMP_ADDR_DELETE"
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

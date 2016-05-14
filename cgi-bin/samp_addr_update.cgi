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
require "samp_addr"
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
	msg = ""
	html_param = {}
	cc.out_html("samp_addr_update_head", html_param)

	if (cc.get_spa("from_tran") == "SAMP_ADDR_UPDATE")
		number = 0
		while (number < cc.get_spa("record_number").to_i)
			html_param = {}
			html_param["number"] = number
			html_param["name"] = cc.get_spa("#{number}_name")
			html_param["zipcode"] = cc.get_spa("#{number}_zipcode")
			html_param["address"] = cc.get_spa("#{number}_address")
			html_param["birthday"] = cc.get_spa("#{number}_birthday")

			if (cc.get_spa("err_sw") == "ER_#{number}_NAME")
				html_param["name_color"] = "red"
				if (msg == "")
					msg = "氏名を入力し直して下さい"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_ZIPCODE")
				html_param["zipcode_color"] = "red"
				if (msg == "")
					msg = "郵便番号(999 又は 999-9999)を入力し直して下さい"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_ADDRESS")
				html_param["address_color"] = "red"
				if (msg == "")
					msg = "住所を入力し直して下さい"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_BIRTHDAY")
				html_param["birthday_color"] = "red"
				if (msg == "")
					msg = "誕生日(YYYYMMDD)を入力し直して下さい"
				end
			end

			cc.out_html("samp_addr_update_body", html_param)

			number += 1
		end
	else
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
		number = 0
		$csv.read_each(hash_key) {|hash_rec|
			html_param = {}
			html_param["number"] = number
			html_param["name"] = hash_rec["name"]
			html_param["zipcode"] = hash_rec["zipcode"]
			html_param["address"] = hash_rec["address"]
			html_param["birthday"] = hash_rec["birthday"]
			cc.out_html("samp_addr_update_body", html_param)

			cc.set_spa("#{number}_old_name", hash_rec["name"])
			cc.set_spa("#{number}_old_zipcode", hash_rec["zipcode"])
			cc.set_spa("#{number}_old_address", hash_rec["address"])
			cc.set_spa("#{number}_old_birthday", hash_rec["birthday"])

			msg = ""

			number += 1
		}
		cc.set_spa("record_number", number)
	end

	html_param = {}
	html_param["msg"] = msg
	if (msg != "")
		html_param["msg_color"] = "red"
	end
	cc.out_html("samp_addr_update_tail", html_param)

	return "SAMP_ADDR_UPDATE"
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
		number = 0
		while (number < cc.get_spa("record_number").to_i)

			name = Name.new(cc.get_input("#{number}_name"))
			if (cc.get_input("ok") != "")
				if (!name.check)
					cc.set_spa("err_sw", "ER_#{number}_NAME")
				end
			end
			cc.set_spa("#{number}_name", name.value)

			zipcode = Zipcode.new(cc.get_input("#{number}_zipcode"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!zipcode.check)
						cc.set_spa("err_sw", "ER_#{number}_ZIPCODE")
					end
				end
			end
			cc.set_spa("#{number}_zipcode", zipcode.value)

			address = Address.new(cc.get_input("#{number}_address"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!address.check)
						cc.set_spa("err_sw", "ER_#{number}_ADDRESS")
					end
				end
			end
			cc.set_spa("#{number}_address", address.value)

			birthday = Birthday.new(cc.get_input("#{number}_birthday"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!birthday.check)
						cc.set_spa("err_sw", "ER_#{number}_BIRTHDAY")
					end
				end
			end
			cc.set_spa("#{number}_birthday", birthday.value)

			number += 1
		end

		if (cc.get_spa("err_sw") == "")
			number = 0
			while (number < cc.get_spa("record_number").to_i)
				hash_key = {}
				hash_key["name"] = cc.get_spa("#{number}_old_name")
				hash_key["zipcode"] = cc.get_spa("#{number}_old_zipcode")
				hash_key["address"] = cc.get_spa("#{number}_old_address")
				hash_key["birthday"] = cc.get_spa("#{number}_old_birthday")

				hash_rec = {}
				hash_rec["name"] = cc.get_input("#{number}_name")
				hash_rec["zipcode"] = cc.get_input("#{number}_zipcode")
				hash_rec["address"] = cc.get_input("#{number}_address")
				hash_rec["birthday"] = cc.get_input("#{number}_birthday")

				$csv.update(hash_key, hash_rec)
				number += 1
			end

			$csv.vacuum()
		end
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("ok") != "")
			cc.set_spa("err_sw", "OK_UPDATE")
		end
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		cc.set_spa("from_tran", "SAMP_ADDR_UPDATE")
		return "SAMP_ADDR_UPDATE"
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

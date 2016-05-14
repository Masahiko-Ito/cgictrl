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
#   o spaにより渡されたデータ(cc.get_spa("..."))を元に画面を編集する
#   o 次に起動するトランザクション(通常は自トランザクションと同じ)を返す
#
def sub_send(cc)
#--- user coding start ---
	html_param = {}
	html_param["name"] = cc.get_spa("name")
	html_param["zipcode"] = cc.get_spa("zipcode")
	html_param["address"] = cc.get_spa("address")
	html_param["birthday"] = cc.get_spa("birthday")

	if (cc.get_spa("err_sw") == "ER_NAME")
		html_param["name_color"] = "red"
		html_param["msg"] = "氏名を入力し直して下さい"
	elsif (cc.get_spa("err_sw") == "ER_ZIPCODE")
		html_param["zipcode_color"] = "red"
		html_param["msg"] = "郵便番号(999 又は 999-9999)を入力し直して下さい"
	elsif (cc.get_spa("err_sw") == "ER_ADDRESS")
		html_param["address_color"] = "red"
		html_param["msg"] = "住所を入力し直して下さい"
	elsif (cc.get_spa("err_sw") == "ER_BIRTHDAY")
		html_param["birthday_color"] = "red"
		html_param["msg"] = "誕生日(YYYYMMDD)を入力し直して下さい"
	elsif (cc.get_spa("err_sw") == "OK_ADD")
		html_param["msg"] = "登録しました"
	elsif (cc.get_spa("err_sw") == "OK_UPDATE")
		html_param["msg"] = "更新しました"
	elsif (cc.get_spa("err_sw") == "OK_DEL")
		html_param["msg"] = "削除しました"
	elsif (cc.get_spa("err_sw") != "")
		html_param["msg"] = "エラー発生！"
	end

	if (cc.get_spa("err_sw") != "")
		html_param["msg_color"] = "red"
	end

	cc.out_html("samp_addr_top", html_param)

	return "SAMP_ADDR_TOP"
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

	name = Name.new(cc.get_input("name"))
	cc.set_spa("name", name.value)
	if (cc.get_input("entry") != "")
		if (!name.check)
			cc.set_spa("err_sw", "ER_NAME")
		end
	end

	zipcode = Zipcode.new(cc.get_input("zipcode"))
	cc.set_spa("zipcode", zipcode.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!zipcode.check)
				cc.set_spa("err_sw", "ER_ZIPCODE")
			end
		end
	end

	address = Address.new(cc.get_input("address"))
	cc.set_spa("address", address.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!address.check)
				cc.set_spa("err_sw", "ER_ADDRESS")
			end
		end
	end

	birthday = Birthday.new(cc.get_input("birthday"))
	cc.set_spa("birthday", birthday.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!birthday.check)
				cc.set_spa("err_sw", "ER_BIRTHDAY")
			end
		end
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("view") != "")
			return "SAMP_ADDR_READ"
		elsif (cc.get_input("entry") != "")
			return "SAMP_ADDR_CREATE"
		elsif (cc.get_input("update") != "")
			return "SAMP_ADDR_UPDATE"
		elsif (cc.get_input("delete") != "")
			return "SAMP_ADDR_DELETE"
		end
	else
		return "SAMP_ADDR_TOP"
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

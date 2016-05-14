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
##require 'rubygems'
require 'dbi'
$dbh = ""
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
	$dbh = DBI.connect("dbi:SQLite3:" + cc.get_realres("RES_DATABASE"))
	$dbh['AutoCommit'] = false
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
#
# テーブル名称(トランザクションコード)設定
	html_param = {}
	html_param["table_name"] = cc.get_spa("table_name")

#
# 画面ヘッダー部表示
	cc.out_html("tment_insert_head", html_param)

#
# SQL文実行
#
	sql = "select * from #{cc.get_spa('table_name')} limit 1"
	sth = $dbh.prepare(sql)
	sth.execute()
	for i in 1..cc.get_spa("insert_count").to_i
		html_param = {}
		cc.out_html("common_tr_start", html_param)
		html_param = {}
		cc.out_html("common_td", html_param)
		html_param = {}
		cc.out_html("common_td", html_param)
		html_param = {}
		cc.out_html("common_tr_end", html_param)

		html_param = {}
		cc.out_html("common_tr_start", html_param)
		html_param = {}
		html_param["value"] = "Column name"
		cc.out_html("common_th", html_param)
		html_param = {}
		html_param["value"] = "Value"
		cc.out_html("common_th", html_param)
		html_param = {}
		cc.out_html("common_tr_end", html_param)

		for j in 0..(sth.column_names.size - 1)
			html_param = {}
			html_param["col_name"] = sth.column_names[j]
			html_param["index"] = i
			html_param["value"] = cc.get_spa("insert_#{sth.column_names[j]}_#{i}")
			cc.out_html("tment_insert_body", html_param)
		end
	end
	sth.finish

#
# エラーメッセージ設定
	html_param = {}
	if (cc.get_spa("err_sw") != "")
		html_param["msg_color"] = "red"
		html_param["msg"] = cc.get_spa("err_sw").gsub(/^.*:[0-9][0-9]*:/, "")
	end
#
# 画面テイル部表示
	cc.out_html("tment_insert_tail", html_param)

#
# エラースイッチクリア
	cc.set_spa("err_sw", "")
	return cc.get_tran()
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
#
# [戻る]でなければ
	if (cc.get_input("ng") == "")
		sql = "select * from #{cc.get_spa('table_name')} limit 1"
		sth = $dbh.prepare(sql)
		sth.execute()

		for i in 1..cc.get_spa("insert_count").to_i
			sql_ins = "insert into #{cc.get_spa('table_name')} ("
			first_col_sw = true
			for j in 0..(sth.column_names.size - 1)
				if (!first_col_sw)
					sql_ins += ","
				else
					first_col_sw = false
				end
				sql_ins += sth.column_names[j]
			end
			sql_ins += ") values ("

			first_col_sw = true
			for j in 0..(sth.column_names.size - 1)
				if (!first_col_sw)
					sql_ins += ","
				else
					first_col_sw = false
				end
				sql_ins += "?"
			end
			sql_ins += ")"

			sthexec = "sth_ins.execute("
			first_col_sw = true
			for j in 0..(sth.column_names.size - 1)
				if (!first_col_sw)
					sthexec += ","
				else
					first_col_sw = false
				end
				sthexec += 'cc.get_spa("insert_' + "#{sth.column_names[j]}_#{i}" + '")'
			end
			sthexec += ")"

			begin
				sth_ins = $dbh.prepare(sql_ins)
				eval(sthexec)
			rescue => e
				cc.set_spa("err_sw", "ERROR_#{e}")
			end
			if (sth_ins)
				sth_ins.finish
			end
		end
		sth.finish
	end

	if (cc.get_input("ng") != "")
		return cc.get_spa("from_tran_to_insert")
	else
		if (cc.get_spa("err_sw") == "")
			cc.set_spa("select_inputed_sw", "off")
			return cc.get_spa("from_tran_to_insert")
		else
			return cc.get_tran()
		end
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
	if ($dbh['AutoCommit'] == false)
		if (cc.get_spa("err_sw") == "")
			$dbh.commit
		else
			$dbh.rollback
		end
	end
	$dbh.disconnect
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

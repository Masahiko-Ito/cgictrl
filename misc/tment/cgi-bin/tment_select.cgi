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
	cc.out_html("tment_select_head", html_param)

#
# SQL文組み立て
#
	sql = "select * from #{cc.get_spa('table_name')} limit 1"
	sth = $dbh.prepare(sql)
	sth.execute()

	sql2 = "select distinct * from #{cc.get_spa('table_name')}"
	sthexec = "sth.execute("

	first_col_sw = true
	sth.column_names.each {|name|
		if (cc.get_spa(name) != "")
			if (!first_col_sw)
				sql2 += " and"
				sthexec += ","
			else
				sql2 += " where"
				first_col_sw = false
			end
			if (/%/ =~ cc.get_spa(name))
				sql2 += " #{name} like ?"
			else
				sql2 += " #{name} = ?"
			end
			sthexec += 'cc.get_spa("' + "#{name}" + '")'
		end
	}
	sql2 += " limit ? offset ?"
	if (sthexec == "sth.execute(")
		sthexec += "#{cc.get_spa('limit')},#{cc.get_spa('offset')})"
	else
		sthexec += ",#{cc.get_spa('limit')},#{cc.get_spa('offset')})"
	end
	sth.finish

#
# SQL文実行
#
	sth = $dbh.prepare(sql2)
	eval(sthexec)
	i = 1
	while (row = sth.fetch)
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

		sth.column_names.each {|name|
			html_param = {}
			html_param["col_name"] = name
			html_param["index"] = i
			if (cc.get_spa("select_inputed_sw") == "on")
				html_param["value"] = cc.get_spa("select_#{name}_#{i}")
			else
				html_param["value"] = row[name]
			end
			html_param["size"] = "100"
			cc.out_html("tment_select_body", html_param)
		}
		cc.set_spa("select_count", i)
		i += 1
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
	cc.out_html("tment_select_tail", html_param)

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
	if (cc.get_input("return") == "")
		cc.set_spa("select_inputed_sw", "on")
		sql = "select * from #{cc.get_spa('table_name')} limit 1"
		sth = $dbh.prepare(sql)
		sth.execute()

		k = 0
		for i in 1..cc.get_spa("select_count").to_i
			insert_sw = false
			for j in 0..(sth.column_names.size - 1)
				cc.set_spa("select_#{sth.column_names[j]}_#{i}", cc.get_input("#{sth.column_names[j]}_#{i}"))
				if (insert_sw == false)
					if (cc.get_input("#{sth.column_names[j]}_#{i}") != "")
						insert_sw = true
					end
				end
			end

			if (insert_sw)
				k += 1
				for j in 0..(sth.column_names.size - 1)
					cc.set_spa("insert_#{sth.column_names[j]}_#{k}", cc.get_input("#{sth.column_names[j]}_#{i}"))
				end
				cc.set_spa("insert_count", k)
			end
		end
		sth.finish

		if (cc.get_input("insert") != "" && k == 0)
			cc.set_spa("err_sw", "ERROR_NODATA")
		end
	end

	if (cc.get_input("return") != "")
		cc.set_spa("select_inputed_sw", "off")
		return cc.get_spa('table_name')
	else
		if (cc.get_spa("err_sw") == "")
			cc.set_spa("from_tran_to_insert", cc.get_tran())
			return "TMENT_INSERT"
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

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
	cc.out_html("tment_update_head", html_param)

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
			if (cc.get_spa("update_inputed_sw") == "on")
				html_param["value"] = cc.get_spa("update_#{name}_#{i}")
			else
				html_param["value"] = row[name]
				cc.set_spa("update_row_#{name}_#{i}", row[name])
			end
			html_param["size"] = "100"
			cc.out_html("tment_update_body", html_param)
		}
		cc.set_spa("update_count", i)
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
	cc.out_html("tment_update_tail", html_param)

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
		cc.set_spa("update_inputed_sw", "on")
		sql = "select * from #{cc.get_spa('table_name')} limit 1"
		sth = $dbh.prepare(sql)
		sth.execute()

		for i in 1..cc.get_spa("update_count").to_i
			for j in 0..(sth.column_names.size - 1)
				cc.set_spa("update_#{sth.column_names[j]}_#{i}", cc.get_input("#{sth.column_names[j]}_#{i}"))
			end

			update_sw = false
			for j in 0..(sth.column_names.size - 1)
				if (cc.get_input("#{sth.column_names[j]}_#{i}") != "")
					update_sw = true
					break
				end
			end

			if (update_sw)
				sql_update = "update #{cc.get_spa('table_name')} set"
				sthexec = "sth_upd.execute("

				first_col_sw = true
				for j in 0..(sth.column_names.size - 1)
					if (!first_col_sw)
						sql_update += ","
						sthexec += ","
					else
						first_col_sw = false
					end
					sql_update += " #{sth.column_names[j]} = ?"
					sthexec += 'cc.get_input("' + "#{sth.column_names[j]}_#{i}" + '")'
				end
				sql_update += " where"

				first_col_sw = true
				for j in 0..(sth.column_names.size - 1)
					if (!first_col_sw)
						sql_update += " and"
					else
						first_col_sw = false
					end
					sql_update += " #{sth.column_names[j]} = ?"
					sthexec += ',cc.get_spa("update_row_' + "#{sth.column_names[j]}_#{i}" + '")'
				end
				sthexec += ")"

				begin
					sth_upd = $dbh.prepare(sql_update)
					eval(sthexec)
				rescue => e
					cc.set_spa("err_sw", "ERROR_#{e}")
				end
				if (sth_upd)
					sth_upd.finish
				end
			end
		end
		sth.finish
	end

	if (cc.get_input("ng") != "")
		cc.set_spa("update_inputed_sw", "off")
		return cc.get_spa('table_name')
	else
		if (cc.get_spa("err_sw") == "")
			cc.set_spa("update_inputed_sw", "off")
			return cc.get_spa('table_name')
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

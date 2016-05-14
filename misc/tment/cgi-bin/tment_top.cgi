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
# トランザクションコード取り込み
	if (cc.get_tran() == "")
		tran = cc.get_init_tran()
	else
		tran = cc.get_tran()
	end

#
# テーブル名称(トランザクションコード)設定
	html_param = {}
	html_param["table_name"] = tran
	if (cc.get_spa('limit') != "")
		html_param["limit"] = cc.get_spa('limit')
	end
	if (cc.get_spa('offset') != "")
		html_param["offset"] = cc.get_spa('offset')
	end

#
# 画面ヘッダー部表示
	cc.out_html("tment_top_head", html_param)

#
# 項目名称取得
#
	sql = "select * from #{tran} limit 1"
	sth = $dbh.prepare(sql)
	sth.execute()
	sth.column_names.each {|name|
		html_param = {}
		html_param["col_name"] = name
		html_param["value"] = cc.get_spa(name)
		html_param["size"] = "100"
# 画面ボディー部表示
		cc.out_html("tment_top_body", html_param)
	}
	sth.finish

	html_param = {}
#
# エラーメッセージ設定
	if (cc.get_spa("err_sw") != "")
		html_param["msg_color"] = "red"
		html_param["msg"] = cc.get_spa("err_sw").gsub(/^.*:[0-9][0-9]*:/, "")
	end
#
# 画面テイル部表示
	cc.out_html("tment_top_tail", html_param)

#
# エラースイッチクリア
	cc.set_spa("err_sw", "")
	return tran
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
		if(/^[0-9]+$/=~cc.get_input("limit"))
			cc.set_spa("limit",cc.get_input("limit"))
		else
			cc.set_spa("limit","0")
		end
		if(/^[0-9]+$/=~cc.get_input("offset"))
			cc.set_spa("offset",cc.get_input("offset"))
		else
			cc.set_spa("offset","0")
		end

		cc.set_spa("table_name", cc.get_tran())

		sql = "select * from #{cc.get_tran()} limit 1"
		sth = $dbh.prepare(sql)
		sth.execute()
		sth.column_names.each {|name|
			cc.set_spa(name, cc.get_input(name))
		}
		sth.finish

		if (cc.get_input("select") != "")
		elsif (cc.get_input("insert") != "")
			sql = "select * from #{cc.get_spa('table_name')} limit 1"
			sth = $dbh.prepare(sql)
			sth.execute()
			insert_sw = false
			sth.column_names.each {|name|
				cc.set_spa("insert_#{name}_1", cc.get_input(name))
				if (cc.get_input(name) != "")
					insert_sw = true
				end
			}
			cc.set_spa("insert_count", 1)
			sth.finish

			if (!insert_sw)
				cc.set_spa("err_sw", "ERROR_NODATA")
			end
		elsif (cc.get_input("update") != "")
		elsif (cc.get_input("delete") != "")
		end
	end

	if (cc.get_input("return") != "")
		return "__YOU_MUST_DEFINE__"
	else
		if (cc.get_spa("err_sw") == "")
			if (cc.get_input("select") != "")
				return "TMENT_SELECT"
			elsif (cc.get_input("insert") != "")
				cc.set_spa("from_tran_to_insert", cc.get_tran())
				return "TMENT_INSERT"
			elsif (cc.get_input("update") != "")
				return "TMENT_UPDATE"
			elsif (cc.get_input("delete") != "")
				return "TMENT_DELETE"
			end
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

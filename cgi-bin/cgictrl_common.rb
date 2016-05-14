#----------------------------------------------------------------------
# Copyright (C) 2009 Masahiko Ito
#     
# These programs is free software; you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 2 of the License, or (at  
# your option) any later version.
#    
# These programs is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
# for more details.
#    
# You should have received a copy of the GNU General Public License along 
# with these programs; if not, write to the Free Software Foundation, Inc., 
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#    
# Mail suggestions and bug reports for these programs to
# "Masahiko Ito" <m-ito@myh.no-ip.org>
#----------------------------------------------------------------------
#
# cgictrl ver.0.1 2009.07.07 Masahiko Ito <m-ito@myh.no-ip.org>
#
#   Cgictrl class 定義
#
#============================================================
#
# Cgictrl class
#
#============================================================
class Cgictrl
#------------------------------------------------------------
#
# インスタンス変数アクセスメソッド定義
#
#------------------------------------------------------------
	attr_accessor :force_https
	attr_accessor :backward_deny
	attr_accessor :default_nkf_param
	attr_accessor :get_log_input_flag
	attr_accessor :get_log_send_flag
	attr_accessor :get_log_deny_flag
	attr_accessor :get_log_error_flag
	attr_accessor :cgictrl_data_dir
	attr_accessor :tran2pgm_file
	attr_accessor :usertran_file
	attr_accessor :resource_file
	attr_accessor :html_dir
	attr_accessor :error_msg_id
	attr_accessor :error_msg_string
	attr_accessor :lock_parent_dir
	attr_accessor :lock_dir_format
	attr_accessor :lock_file
	attr_accessor :lock_sleep_sec
	attr_accessor :lock_retry_max
	attr_accessor :sweep_time_before
	attr_accessor :html_start_param
	attr_accessor :html_end_param
	attr_accessor :html_start_default
	attr_accessor :html_end_default
	attr_accessor :start_str_hex
	attr_accessor :end_str_hex
	attr_accessor :log_file_res
	attr_accessor :log_dir
	attr_accessor :log_file
	attr_accessor :spa_dir_res
	attr_accessor :spa_dir
#
	attr_accessor :raw_param
	attr_accessor :input
	attr_accessor :input_file
	attr_accessor :spa
	attr_accessor :userid
	attr_accessor :remote_addr
#
	attr_accessor :init_tran_key
	attr_accessor :sessionid_key
#
	attr_accessor :checkseq_key
	attr_accessor :next_tran_key
	attr_accessor :first_tran_flag_key
#------------------------------------------------------------
#
# 初期化
#
#------------------------------------------------------------
	def initialize
#
# !! 既定値を修正する場合は、よく理解した上で行いましょう。ここから〜 !!
#
# https(ssl)通信を強制する場合は `y' をセットする。
#
		@force_https = "n"
#
# [戻る]ボタンで遡ったページからの処理継続を禁止する場合は `y' をセットする。
#
		@backward_deny = "y"
#
# 標準のnkf変換パラメータをセットする。
#
# デフォルトのパラメータに関して
#  o 入力のhtmlがcharset=EUC-JPで作成されている事が前提となる(-E)。
#  o 半角カナは全角カナへ変換する(-X)。
#  o 全角英数字は半角英数字へ変換する(-Z1)。
#  o 漢字はEUCに変換する(-e)。
#
		@default_nkf_param = "-E -X -Z1 -e"
#
# <form>からの入力データをログファイルに残す場合は `y' をセットする。
#
		@get_log_input_flag = "y"
#
# stdoutに出力したデータをログファイルに残す場合は `y' をセットする。
#
		@get_log_send_flag = "y"
#
# トランザクションの実行拒否をログファイルに残す場合は `y' をセットする。
#
		@get_log_deny_flag = "y"
#
# トランザクションを中断するエラーメッセージをログファイルに残す場合は `y' をセットする。
#
		@get_log_error_flag = "y"
#
# cgictrlが利用するデータディレクトリの指定(httpサーバの実効ユーザが書き込み出来る事)。
#
		@cgictrl_data_dir = "/home/m-ito/cgictrl"
#
# トランザクション to プログラム変換テーブルファイルの指定。
#
		@tran2pgm_file = @cgictrl_data_dir + "/" + "tran2pgm.txt"
#
# ユーザ to トランザクション許可ファイルの指定。
#
		@usertran_file = @cgictrl_data_dir + "/" + "usertran.txt"
#
# 排他対象リソース登録ファイルの指定。
#
		@resource_file = @cgictrl_data_dir + "/" + "resource.txt"
#
# htmlファイル格納ディレクトリの指定(httpサーバの実効ユーザが読み込み出来る事)。
#
		@html_dir = @cgictrl_data_dir + "/" + "html"
#
# cgictrlシステムエラー画面htmlファイルのIDを指定。
#
		@error_msg_id = "cgictrl_error"
#
# cgictrlシステムエラー画面htmlファイル中のメッセージ項目名称を指定。
#
		@error_msg_string = "error_message"
#
# 排他制御用の親ディレクトリの指定(httpサーバの実効ユーザが書き込み出来る事)。
#
		@lock_parent_dir = @cgictrl_data_dir + "/" + "lock"
#
# 排他制御ディレクトリのフォーマットを指定(`%s'部分にはリソースIDが入る)。
#
		@lock_dir_format = "%s.dir"
#
# 排他制御ファイルを指定。
#
		@lock_file = "lock.txt"
#
# 排他リトライ時の間隔(秒)を指定。
#
		@lock_sleep_sec = 1
#
# 排他リトライの回数を指定。
#
		@lock_retry_max = 60
#
# 指定時間(秒)より古いSPAファイルを削除対象とする。
#
		@sweep_time_before = 2 * 24 * 60 * 60
#
# htmlファイル中の項目開始文字列名称、終了文字列名称の既定値を指定。
#
		@html_start_param = "START"
		@html_end_param = "END"
#
# htmlファイル中の項目開始文字列、終了文字列の既定値を指定。
#
		@html_start_default = "@\\{"
		@html_end_default = "\\}@"
#
# htmlファイル中の項目開始文字列、終了文字列の最終的な値の16進文字列。
#
		@start_str_hex = "01"
		@end_str_hex = "02"
#
# ログ記録ファイルのリソースID、格納ディレクトリ、ファイル実体の指定。
#
		@log_file_res = "LOGFILE"
		@log_dir = @cgictrl_data_dir + "/" + "log"
		(stat, @log_file) = check_res(@log_file_res)
		if (!stat)
			@log_file = @log_dir + "/" + "log.txt"
		end
#
# SPA(Scratch Pad Area)ファイル格納ディレクトリ、リソースIDの指定(httpサーバの実効ユーザが書き込み出来る事)。
#
		@spa_dir_res = "SPADIR"
		(stat, @spa_dir) = check_res(@spa_dir_res)
		if (!stat)
			@spa_dir = @cgictrl_data_dir + "/" + "spa"
		end
#
# !! 既定値を修正する場合は、よく理解した上で行いましょう。〜ここまで !!
#
		@raw_param = ""
		@input = {}
		@input_file = {}
		@spa = {}
		if ((@userid = ENV["REMOTE_USER"].to_s) == "")
			@userid = "anonymous"
		end
		@remote_addr = ENV["REMOTE_ADDR"].to_s
#
		@init_tran_key = "SYS_init_tran"
		@sessionid_key = "SYS_sessionid"
#
# for special spa
		@checkseq_key = "SYS_checkseq"
		@next_tran_key = "SYS_next_tran"
		@first_tran_flag_key = "SYS_first_tran_flag"
	end
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
# 主にコントロールプログラム(cgictrl.cgi)で使用するメソッド
#
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#------------------------------------------------------------
#
# CGI rawパラメータ取得
#
# 引  数：無し
# 戻り値：ブラウザからCGIに渡される(生状態の)パラメータ
#
#------------------------------------------------------------
	def get_raw_param()
		if (/^[0-9]+$/ =~ ENV["CONTENT_LENGTH"])
			@raw_param = $stdin.read(ENV["CONTENT_LENGTH"].to_i)
		else
			@raw_param = ENV["QUERY_STRING"]
		end
	end
#------------------------------------------------------------
#
# CGIパラメータ覗き見
#
# 引  数：name ... <form>内の入力項目名(<input name="ここ" ...> etc)
#         nkf_param ... 入力項目をnkfで変換する際のオプション
# 戻り値：デコードおよびnkfによる変換後の入力項目(String)
#
#------------------------------------------------------------
	def peek_param(name, nkf_param)
#
		ret = ""
#
		if (/^-/ =~ @raw_param)
			(sep1, tmp) = @raw_param.split(/\r\n/, 2)
			sep2 = "\r\n" + sep1 + "--\r\n"
			sep1 += "\r\n"
			(tmp, dummy) = tmp.split(sep2, 2)
			tmp.split(sep1).each do |kv|
				k = ""
				if (/^Content-Type:/ =~ kv)
				else
					(tmp2, other) = kv.split("\r\n", 2)
					while (true)
						if (/^Content-Disposition:/ =~ tmp2)
							tmp2.split(/; */).each do |kv2|
								if (/^name=/ =~ kv2)
									k = kv2.gsub(/^name="/, "")
									k.gsub!(/"$/, "")
									break
								end
							end
						elsif (/^$/ =~  tmp2)
							break
						end
						(tmp2, other) = other.split("\r\n", 2)
					end
					other.gsub!(/\r\n$/, "")
					if (NKF.nkf(nkf_param, k) == name)
						ret = NKF.nkf(nkf_param, other)
						break;
					end
				end
			end
		else
			@raw_param.split("&").each do |kv|
				(k, v) = kv.split("=", 2)
				if (decode_charconv(k, nkf_param) == name)
					ret = decode_charconv(v, nkf_param)
					break;
				end
			end
		end
#
		return ret.to_s
	end
#------------------------------------------------------------
#
# CGIパラメータ取得
#    @input[項目名称] ... 入力内容の取り込み先
#    @input_file[項目名称] ... アップロードファイルの取り込み先
#
# 引  数：nkf_param ... 入力項目をnkfで変換する際のオプション
# 戻り値：無し
#
#------------------------------------------------------------
	def get_param(nkf_param)
#
		get_raw_param()
#
		if (/^-/ =~ @raw_param)
			(sep1, tmp) = @raw_param.split(/\r\n/, 2)
			sep2 = "\r\n" + sep1 + "--\r\n"
			sep1 += "\r\n"
			(tmp, dummy) = tmp.split(sep2,2 )
			tmp.split(sep1).each do |kv|
				k = ""
				if (/^Content-Type:/ =~ kv)
					(tmp2, other) = kv.split("\r\n", 2)
					while (true)
						if (/^Content-Disposition:/ =~ tmp2)
							tmp2.split(/; */).each do |kv2|
								if (/^name=/ =~ kv2)
									k = kv2.gsub(/^name="/, "")
									k.gsub!(/"$/, "")
								elsif (/^filename=/ =~ kv2)
									v = kv2.gsub(/^filename="/, "")
									v.gsub!(/"$/, "")
									@input[NKF.nkf(nkf_param, k)] = NKF.nkf(nkf_param, v)
									break;
								end
							end
						elsif (/^[A-z]/ =~ tmp2)
						elsif (/^$/ =~ tmp2)
							break
						end
						(tmp2, other) = other.split("\r\n", 2)
					end
					other.gsub!(/\r\n$/, "")
					@input_file[NKF.nkf(nkf_param, k)] = other
				else
					(tmp2, other) = kv.split("\r\n", 2)
					while (true)
						if (/^Content-Disposition:/ =~ tmp2)
							tmp2.split(/; */).each do |kv2|
								if (/^name=/ =~ kv2)
									k = kv2.gsub(/^name="/, "")
									k.gsub!(/"$/, "")
									break
								end
							end
						elsif (/^$/ =~  tmp2)
							break
						end
						(tmp2, other) = other.split("\r\n", 2)
					end
					other.gsub!(/\r\n$/, "")
					@input[NKF.nkf(nkf_param, k)] = NKF.nkf(nkf_param, other)
				end
			end
		else
			@raw_param.split("&").each do |kv|
				(k, v) = kv.split("=", 2)
				@input[decode_charconv(k, nkf_param)] = decode_charconv(v, nkf_param)
			end
		end
	end
#------------------------------------------------------------
#
# URLデコード＆文字コード変換
#
# 引  数：str ... URLエンコードされた文字列
#         nkf_param ... nkfで変換する際のオプション
# 戻り値：変換後の文字列
#
#------------------------------------------------------------
	def decode_charconv(str, nkf_param)
		tmp = str.to_s
		tmp.tr!("+", " ")
		tmp.gsub!(/%([0-9a-zA-Z][0-9a-zA-Z])/){$1.hex.chr}
		tmp = NKF.nkf(nkf_param, tmp)
		return tmp.to_s
	end
#------------------------------------------------------------
#
# トランザクションコードからCGIプログラム取得
#
# 引  数：tran ... トランザクションコード
# 戻り値：CGIプログラムへのパス
#
#------------------------------------------------------------
	def get_pgm_from_tran(tran)
		ret = ""
		fp = open(@tran2pgm_file, "r")
		while(rec = fp.gets)
			if (/^#/ !~ rec)
				(intran, inpgmres) = rec.split("=", 2)
				if (intran == tran)
					(inpgm, res_modes) = inpgmres.split(":", 2)
					ret = inpgm.chomp
					break
				end
			end
		end
		fp.close
		return ret.to_s
	end
#------------------------------------------------------------
#
# トランザクションコードからリソースID取得
#
# 引  数：tran ... トランザクションコード
# 戻り値：[リソースID/アクセスモード, ...] (配列)
#
#------------------------------------------------------------
	def get_res_from_tran(tran)
		array_ret = []
		fp = open(@tran2pgm_file, "r")
		while(rec = fp.gets)
			if (/^#/ !~ rec)
				(intran, inpgmres) = rec.split("=", 2)
				if (intran == tran)
					(inpgm, res_modes) = inpgmres.split(":", 2)
					res_modes.to_s.chomp!
					array_ret = res_modes.to_s.split(",")
					break
				end
			end
		end
		fp.close
		return array_ret
	end
#------------------------------------------------------------
#
# リソースID実在チェック&リソース実体取得
#
# 引  数：res ... リソースID
# 戻り値：[ステータス, リソースの実体を表す文字列] (配列)
#          ステータス ... true  : 取得OK
#                         false : 取得NG
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def check_res(res)
		inres = ""
		inrealres = ""
		ret = []
		fp = open(@resource_file, "r")
		while (rec = fp.gets)
			rec.chomp!
			(inres, inrealres) = rec.split("=", 2)
			if (res == inres)
				ret[0] = true
				ret[1] = inrealres
				return ret
			end
		end
		fp.close
		if (res != @log_file_res && res != @spa_dir_res)
			show_error_msg("unknown_tran", 
					"Resource(" +
					CGI.escapeHTML(res) +
					") is not unknown.")
		end
		ret[0] = false
		ret[1] = inrealres
		return ret
	end
#------------------------------------------------------------
#
# sessionIDファイルよりSPA取得
#    @spa[項目名] ... SPA項目取り込み先
# 
# 引  数：sessionid ... セッションID
# 戻り値：無し
#
#------------------------------------------------------------
	def get_spa_all(sessionid)
		@spa = {}
		(fixsessionid, dummy) = sessionid.split("/", 2)
		fp = open(@spa_dir + "/" + fixsessionid, "r")
		while(rec = fp.gets)
			(inkey, inval) = rec.split("=", 2)
			@spa[inkey] = CGI.unescape(inval.chomp)
		end
		fp.close
	end
#------------------------------------------------------------
#
# SPAをsessionIDファイルに保存
#
# 引  数：sessionid ... セッションID
# 戻り値：無し
#
#   o 内容確認は以下のワンライナーで...
#
#     ruby -e 'require "cgi";while (gets) do print CGI.unescape($_); end'
#
#------------------------------------------------------------
	def set_spa_all(sessionid)
		(fixsessionid, dummy) = sessionid.split("/", 2)
	        fp = open(@spa_dir + "/" + fixsessionid, "w")
	        @spa.each do |key, val|
	                fp.write(key + "=" + CGI.escape(@spa[key]) + "\n")
	        end
	        fp.close
	end
#------------------------------------------------------------
#
# トランザクション起動判定
#
# 引  数：tran ... トランザクションコード
# 戻り値：ステータス ... true  : 起動OK
#                        false : 起動NG
#
#------------------------------------------------------------
	def is_permitted(tran)
		fp = open(@usertran_file, "r")
		while(rec = fp.gets)
			if (/^#/ !~ rec)
				rec.chomp!
				(in_userid, in_tran) = rec.split("=", 2)
				if (/^#{in_userid}$/ =~ @userid)
					if (/^#{in_tran}$/ =~ tran)
						return true
					end
				end
			end
		end
		return false
	end
#------------------------------------------------------------
#
# useridチェック後にCGI起動
#
# 引  数：tran ... トランザクションコード
# 戻り値：ステータス ... true  : 起動成功
#                        false : 起動失敗
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def spawn_cgi_with_check(tran)
		if (is_permitted(tran))
			if (/^y$/i =~ @get_log_input_flag)
				if (!log(tran, @raw_param))
					return false
				end
			end
			IO.popen(get_pgm_from_tran(tran), "r+") do |io|
				io.write @raw_param
				send_data = io.read
				print send_data
				if (/^y$/i =~ @get_log_send_flag)
					if (!log(tran, send_data))
						return false
					end
				end
			end
		else                     
			show_error_msg(tran,
					CGI.escapeHTML(@userid) +
					" is not permitted to execute " +
					CGI.escapeHTML(tran) + ".")
			if (/^y$/i =~ @get_log_deny_flag)
				if (!log(tran, "DENIED"))
					return false
				end
			end
			return false
		end
		return true
	end
#------------------------------------------------------------
#
# 稼働ログ記録
#
# 引  数：tran ... トランザクションコード
#         msg ... 記録するメッセージ
# 戻り値：ステータス ... true  : 取得OK
#                        false : 取得NG
#
#   o 内容確認は以下のワンライナーで...
#
#     ruby -e 'require "cgi";while (gets) do print CGI.unescape($_); end'
#
#------------------------------------------------------------
	def log(tran, msg)
		if (!lock_res("#{@log_file_res}/A"))
			return false
		end
#
		day = Time.now
		fp = open(@log_file, "a")
		fp.printf("%04d/%02d/%02d\t%02d:%02d:%02d\t%-s\t%-s\t%-s\t%-s\n", day.year, day.month, day.day, day.hour, day.min, day.sec, CGI.escape(@remote_addr), CGI.escape(@userid), CGI.escape(tran), CGI.escape(msg))
		fp.close
#
		unlock_res(@log_file_res)
		return true
	end
#------------------------------------------------------------
#
# 排他をかけているプロセスIDが非稼働である事のチェック
#
# 引  数：res ... リソースID
# 戻り値：ステータス ... true  : 非稼働である
#                        false : 稼働中である
#
#------------------------------------------------------------
	def lock_process_is_dead(res)
		lock_dir = @lock_parent_dir + "/" + sprintf(@lock_dir_format, CGI.escape(res))
#
		fp = ""
		begin
			fp = open(lock_dir + "/" + @lock_file, "r")
		rescue Errno::ENOENT
			return false
		end
		pid = fp.read
		pid.chomp!
		fp.close
#
		begin
			Process.kill(0, pid.to_i)
		rescue Errno::ESRCH
			return true
		else
			return false
		end
	end
#------------------------------------------------------------
#
# 排他ON
#
# 引  数：array_res_mode ... [リソースID/アクセスモード, ...] (配列)
# 戻り値：ステータス ... true  : 排他取得完了
#                        false : 排他取得失敗
#
# 注意 : 本ルーチンではアクセスモードは意味を持たない(未実装)。
#        将来的には
#
#             A : 更新モード
#             G : 参照モード
#
#         の、2レベルロックを実装したい...
#
#------------------------------------------------------------
	def lock(array_res_mode)
		array_res_mode.sort.each do |res|
			if (!lock_res(res))
				unlock(array_res_mode)
				return false
			end
		end
		return true
	end
#------------------------------------------------------------
#
# 排他OFF
#
# 引  数：array_res_mode ... [リソースID[/アクセスモード], ...] (配列)
# 戻り値：ステータス ... true  : 排他開放完了
#                        false : 排他開放失敗
#
# 本ルーチンではアクセスモードは意味を持たない。仮に指定しても無視される。
#
#------------------------------------------------------------
	def unlock(array_res_mode)
		ret = true
		array_res_mode.sort.each do |res_mode|
			(res, dummy_mode) = res_mode.split("/", 2)
			ret_tmp = unlock_res(res)
			if (ret == true && ret_tmp == false)
				ret = ret_tmp
			end
		end
		return ret
	end
#------------------------------------------------------------
#
# 排他ON(単一リソース)
#
# 引  数：res_mode ... リソースID/アクセスモード
# 戻り値：ステータス ... true  : 排他取得完了
#                        false : 排他取得失敗
#
# 注意 : 本ルーチンではアクセスモードは意味を持たない(未実装)。
#        将来的には
#
#             A : 更新モード
#             G : 参照モード
#
#         の、2レベルロックを実装したい...
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def lock_res(res_mode)
		(res, mode) = res_mode.split("/" , 2)
#
		retry_cnt = 0
		lock_dir = @lock_parent_dir + "/" + sprintf(@lock_dir_format, CGI.escape(res.to_s))
#
		begin
			Dir.mkdir(lock_dir, 0755)
		rescue Errno::EEXIST
			sleep(@lock_sleep_sec)
			if (retry_cnt < @lock_retry_max)
				if (lock_process_is_dead(res.to_s))
					unlock_force(res.to_s)
				end
				retry_cnt += 1
				retry
			end
#
			fp = ""
			lock_pid = ""
			begin
				fp = open(lock_dir + "/" + @lock_file, "r")
			rescue Errno::ENOENT
				lock_pid = "unknown"
			end
			if (lock_pid == "")
				lock_pid = fp.read
				lock_pid.chomp!
				fp.close
			end
			show_error_msg("unknown_tran",
					"process(" + CGI.escapeHTML(lock_pid) + ")" +
					" is running, so your request can not be available.")
			return false
		else
			fp = open(lock_dir + "/" + @lock_file, "w")
			fp.write($$)
			fp.close
		end
		return true
	end
#------------------------------------------------------------
#
# 強制排他OFF
#
# 引  数：res ... リソースID
# 戻り値：ステータス ... true  : 排他開放完了
#                        false : 排他開放失敗
#
#------------------------------------------------------------
	def unlock_force(res)
		ret = true
		lock_dir = @lock_parent_dir + "/" + sprintf(@lock_dir_format, CGI.escape(res.to_s))
		begin
			File.unlink(lock_dir + "/" + @lock_file)
		rescue Errno::ENOENT
			ret = false
		end
#
		begin
			Dir.rmdir(lock_dir)
		rescue Errno::ENOENT
			ret = false
		end
		return ret
	end
#------------------------------------------------------------
#
# 排他OFF(単一リソース)
#
# 引  数：res ... リソースID
# 戻り値：ステータス ... true  : 排他開放完了
#                        false : 排他開放失敗
#
#------------------------------------------------------------
	def unlock_res(res)
		lock_dir = @lock_parent_dir + "/" + sprintf(@lock_dir_format, CGI.escape(res.to_s))
		fp = ""
		in_pid = ""
		begin
			fp = open(lock_dir + "/" + @lock_file, "r")
		rescue Errno::ENOENT
			in_pid = "unknown"
		end
		if (in_pid == "")
			in_pid = fp.read
			in_pid.chomp!
			fp.close
		end
#
		if ($$.to_i != in_pid.to_i)
			return false
		end
		return unlock_force(res.to_s)
	end
#------------------------------------------------------------
#
# httpsチェック
#
# 引  数：無し
# 戻り値：ステータス ... true  : httpsチェックOK
#                        false : httpsチェックNG(httpsが要求されているのにhttps通信でない)
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def check_https()
		if (/^y$/i =~ @force_https && /^on$/i !~ ENV["HTTPS"])
			show_error_msg("unknown_tran",
					"You must use HTTPS to execute this transaction.")
			return false
		end
		return true
	end
#------------------------------------------------------------
#
# 汎用エラーメッセージ出力(ただしメッセージがHTTPステータスレス
# ポンスの形式の場合はhtmlファイルを介さず直接出力する)
#
# 引  数：tran ... トランザクションコード
#         msg  ... 表示メッセージ
# 戻り値：無し
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def show_error_msg(tran, msg)
		if (/^[A-Za-z]+: .*\n\n$/ =~ msg)
			print CGI.escapeHTML(msg)
		else
			out_html(@error_msg_id, {@error_msg_string => msg})
		end
#
		if (/^y$/i =~ @get_log_error_flag)
			if (tran.to_s == "")
				tran = "null_tran"
			end
			log(tran.to_s, msg)
		end
	end
#------------------------------------------------------------
#
# トランザクション、セッションID正当性チェック
#
# 引  数：tran ... 表示メッセージ
#         sessionid ... セッションID
# 戻り値：ステータス ... true  : チェックOK
#                        false : チェックNG
#
# 注意 : ユーザプログラムで本ルーチン使用時に false が返された
#        場合は out_html() を呼び出す事無く、処理を終了しなけ
#        ればならない(通常は使わない)。
#
#------------------------------------------------------------
	def check_tran_sessionid(tran, sessionid)
		(fixsessionid, checkseq) = sessionid.to_s.split("/", 2)
		if (sessionid.to_s != "")
			msg = "Your sessionid is invalid."
			if (/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{14}\.0\.[0-9]{16}\/0\.[0-9]{16}/ !~ sessionid)
				show_error_msg(tran, msg)
				return false
			end
			if (!File.exist?(@spa_dir + "/" + fixsessionid))
				show_error_msg(tran, msg)
				return false
			end
#
			if (/^y$/i =~ @backward_deny)
##				msg = "Your session sequence is invalid."
##				msg = "Location: http://foo/bar.html\n\n"
				msg = "Status: 204 No Response\n\n"
				fp = open(@spa_dir + "/" + fixsessionid, "r")
				spa_checkseq = ""
				while(rec = fp.gets)
					(inkey, inval) = rec.split("=", 2)
					if (inkey == @checkseq_key)
						spa_checkseq = CGI.unescape(inval.chomp)
						break;
					end
				end
				fp.close
				if (checkseq.to_s != spa_checkseq.to_s)
					show_error_msg(tran, msg)
					return false
				end
			end
		end
#
		if (tran.to_s == "" && sessionid.to_s == "")
			msg = "Both tran and sessionid should not be null."
			show_error_msg(tran, msg)
			return false
		end
#
		if (tran.to_s != "" && sessionid.to_s != "")
			msg = "Both tran and sessionid should not be setted."
			show_error_msg(tran, msg)
			return false
		end
		return true
	end
#------------------------------------------------------------
#
# SPAの掃除
#
# 引  数：無し
# 戻り値：無し
#
#------------------------------------------------------------
	def sweep_spa()
		sweep_time = Time.now
		sweep_time -= @sweep_time_before
		sweep_time_str = sprintf("%04d%02d%02d%02d%02d%02d", sweep_time.year,
						sweep_time.month,
						sweep_time.day,
						sweep_time.hour,
						sweep_time.min,
						sweep_time.sec)
		if (!lock_res("#{@spa_dir_res}/A"))
			return false
		end
		dir = Dir.open(@spa_dir)
		while (file = dir.read)
			if (/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{14}\.0\.[0-9]{16}/ =~ file)
				(ip1, ip2, ip3, ip4, daytime,dummy) = file.split(".", 6)
				if (daytime.to_s < sweep_time_str.to_s)
					File.unlink(@spa_dir + "/" + file)
				end
			end
		end
		dir.close
		unlock_res(@spa_dir_res)
	end
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
# 主にユーザプログラムで使用するメソッド
#
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#------------------------------------------------------------
#
# クライアント開始処理
#
# 引  数：nkf_param ... 入力項目をnkfで変換する際のオプション
# 戻り値：セッションID
#
#------------------------------------------------------------
	def start(nkf_param)
		get_param(nkf_param)
		if (@input[@sessionid_key].to_s == "")
			day = Time.now
			@input[@sessionid_key] = sprintf("%-s.%04d%02d%02d%02d%02d%02d.%.16f/%.16f", ENV["REMOTE_ADDR"], day.year, day.month, day.day, day.hour, day.min, day.sec, rand, rand)
			@spa = {}
			(dummy, @spa[@checkseq_key]) = @input[@sessionid_key].split("/", 2)
		else
			(fixsessionid, dummy) = @input[@sessionid_key].split("/", 2)
			@input[@sessionid_key] = sprintf("%-s/%.16f", fixsessionid, rand)
			get_spa_all(@input[@sessionid_key])
			(dummy, @spa[@checkseq_key]) = @input[@sessionid_key].split("/", 2)
		end
		return @input[@sessionid_key].to_s
	end
#------------------------------------------------------------
#
# クライアント終了処理
#
# 引  数：tran ... 次回に起動するトランザクションを指定
# 戻り値：無し
#
#------------------------------------------------------------
	def end(tran)
		@spa[@next_tran_key] = tran
		set_spa_all(@input[@sessionid_key])
	end
#------------------------------------------------------------
#
# コントロール条件(送信トランザクション)取得
#
# 引  数：無し
# 戻り値：ステータス ... true  : 送信トランザクションである
#                        false : 受信トランザクションである
#
#------------------------------------------------------------
	def is_send()
		if (@spa[@first_tran_flag_key].to_s == "" || @spa[@first_tran_flag_key] == "y")
			return true
		else
			return false
		end
	end
#------------------------------------------------------------
#
# コントロール条件(受信トランザクション)取得
#
# 引  数：無し
# 戻り値：ステータス ... true  : 受信トランザクションである
#                        false : 送信トランザクションである
#
#------------------------------------------------------------
	def is_receive()
		if (is_send())
			return false
		else
			return true
		end
	end
#------------------------------------------------------------
#
# リソース実体取得
#
# 引  数：res ... リソースID
# 戻り値：リソースの実体を表す文字列
#
#------------------------------------------------------------
	def get_realres(res)
		inres = ""
		inrealres = ""
		ret = ""
		fp = open(@resource_file, "r")
		while (rec = fp.gets)
			rec.chomp!
			(inres, inrealres) = rec.split("=", 2)
			if (res == inres)
				ret = inrealres
				break
			end
		end
		fp.close
		return ret.to_s
	end
#------------------------------------------------------------
#
# インプットデータ取得
#
# 引  数：key ... 項目名称
# 戻り値：項目に対する値(数値データも含めて全て文字列として返ります)
#
#------------------------------------------------------------
	def get_input(key)
		return @input[key.to_s].to_s
	end
#------------------------------------------------------------
#
# インプットデータ設定
#
# 引  数：key ... 項目名称
#         value ... 項目に対して設定する値
# 戻り値：無し
#
#------------------------------------------------------------
	def set_input(key, value)
		@input[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# インプットファイルデータ取得
#
# 引  数：key ... 項目名称
# 戻り値：項目に対する値
#
#------------------------------------------------------------
	def get_input_file(key)
		return @input_file[key.to_s].to_s
	end
#------------------------------------------------------------
#
# インプットファイルデータ設定
#
# 引  数：key ... 項目名称
#         value ... 項目に対して設定する値
# 戻り値：無し
#
#------------------------------------------------------------
	def set_input_file(key, value)
		@input_file[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# SPAデータ取得
#
# 引  数：key ... 項目名称
# 戻り値：項目に対する値(数値データも含めて全て文字列として返ります)
#
#------------------------------------------------------------
	def get_spa(key)
		return @spa[key.to_s].to_s
	end
#------------------------------------------------------------
#
# SPAデータ設定
#
# 引  数：key ... 項目名称
#         value ... 項目に対して設定する値
# 戻り値：無し
#
#------------------------------------------------------------
	def set_spa(key, value)
		@spa[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# SPAクリアー
#
# 引  数：無し
# 戻り値：無し
#
#------------------------------------------------------------
	def clear_spa()
		tmp_spa = {}
		@spa.each {|k, v|
			if (/^SYS_/ =~ k.to_s)
				tmp_spa[k.to_s] = v.to_s
			end
		}
		@spa = {}
		tmp_spa.each {|k, v|
			@spa[k.to_s] = v.to_s
		}
	end
#------------------------------------------------------------
#
# SPA完全クリアー
#
# 引  数：無し
# 戻り値：無し
#
#------------------------------------------------------------
	def destroy_spa()
		@spa = {}
	end
#------------------------------------------------------------
#
# html出力処理
#
# 引  数：id ... htmlファイルID
#         hash_param ... { 項目 => 値, ...} (htmlに埋め込む値)
# 戻り値：ステータス ... true  : 成功
#                        false : 失敗
#
#   ex. hash_param = { "key" => "value" } の場合
#       `#{id}.html' 中の `#{start_str}key#{end_str}' を `value' に置き換える。
#
#------------------------------------------------------------
	def out_html(id, hash_param)
		html = ""
		start_str_org = ""
		end_str_org = ""
#
		if (!File.exist?(@html_dir + "/" + id + ".html"))
			return false
		end
		fp = open(@html_dir + "/" + id + ".html", "r")
		while (rec = fp.gets)
			if (/^#/ !~ rec)
				if (start_str_org == "" && /^#{@html_start_param}=/ =~ rec)
					(dummy, start_str_org) = rec.split("=", 2)
					start_str_org.chomp!
				elsif (end_str_org == "" && /^#{@html_end_param}=/ =~ rec)
					(dummy, end_str_org) = rec.split("=", 2)
					end_str_org.chomp!
				else
					html += rec
				end
			end
		end
		fp.close
#
		if (start_str_org == "")
			start_str_org = @html_start_default
		end
#
		if (end_str_org == "")
			end_str_org = @html_end_default
		end
#
		i = 0
		while (i < @start_str_hex.length)
			start_str = @start_str_hex[i,2].hex.chr
			i += 2
		end
#
		i = 0
		while (i < @start_str_hex.length)
			end_str = @end_str_hex[i,2].hex.chr
			i += 2
		end
#
		html.gsub!(/#{start_str_org}/, start_str)
		html.gsub!(/#{end_str_org}/, end_str)
#
		hash_param.each do |key, val|
			html.gsub!(/#{start_str}#{key}#{end_str}/, CGI.escapeHTML(val.to_s))
			html.gsub!(/#{start_str}#{key}=[^#{end_str}]*#{end_str}/, CGI.escapeHTML(val.to_s))
		end
#
		html.gsub!(/#{start_str}#{@sessionid_key}#{end_str}/, CGI.escapeHTML(@input[@sessionid_key].to_s))
#
		html.gsub!(/#{start_str}[^#{end_str}=]*#{end_str}/, "")
		html.gsub!(/#{start_str}[^#{end_str}]*=/, "")
		html.gsub!(/#{end_str}/, "")
#
		print html
#
		return true
	end
end
#============================================================
#
# for debug
#
#============================================================
class Debug
#------------------------------------------------------------
#
# デバッグファイルクリアー
#
#------------------------------------------------------------
	def clear_debug()
		fp = open("/tmp/debug.txt", "w")
		fp.puts("")
		fp.close
	end
#------------------------------------------------------------
#
# デバッグ出力
#
#------------------------------------------------------------
	def debug(str)
		fp = open("/tmp/debug.txt", "a")
		fp.puts(str)
		fp.close
	end
end

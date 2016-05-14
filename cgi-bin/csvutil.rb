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
# CSV操作クラス Ver 0.1 2009.07.07 by Masahiko Ito <m-ito@myh.no-ip.org>
#
# このクラスで扱うCSVファイルは以下の形式である。イメージとしては数百件から
# 数千件程度のデータを扱うものとする。
#
#    項目名称=その値[セパレータ] ... [セパレータ]項目名称=その値[改行文字]
#
# [セパレータ]の既定値は "\t" とする。
#
# 追加処理
#
#	def create(hash_rec, vacuum_sw = false, uniq_sw = true)
#
# 削除処理(正規表現)
#
#	def delete(hash_key, vacuum_sw = false, uniq_sw = true)
#
# 更新処理(hash_keyは正規表現)
#
#	def update(hash_key, hash_item, vacuum_sw = false, uniq_sw = true)
#
# 取得処理(イテレータ版)(hash_keyは正規表現)
#
#	def read_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# 取得処理(配列版)(hash_keyは正規表現)
#
#	def read_array(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# 指定キー以降取得処理(イテレータ版)
#
#	def read_ge_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# バキューム処理
#
#	def vacuum(uniq_sw = true)
#
class Csvutil
#----------------------------------------------------------------------
# インスタンス変数
#----------------------------------------------------------------------
	attr_accessor :csv_path
	attr_accessor :csv_sep
#----------------------------------------------------------------------
# 初期化処理
#----------------------------------------------------------------------
	def initialize(path, sep = "\t")
		@csv_path = path
		@csv_sep = sep
	end
#======================================================================
# 内部利用メソッド
#======================================================================
#----------------------------------------------------------------------
# レコードをハッシュに変換
#----------------------------------------------------------------------
	def rec2hash(rec)
		hash_rec = {}
		rec.split(/#{@csv_sep}/).each {|kv|
			(k, v) = kv.split(/=/, 2)
			hash_rec[k.to_s] = v.to_s
		}
		return hash_rec
	end
#----------------------------------------------------------------------
# ハッシュをレコードに変換
#----------------------------------------------------------------------
	def hash2rec(hash)
		outrec = ""
		hash.each {|k, v|
			outrec += (k.to_s + "=" + v.to_s + @csv_sep)
		}
		outrec.gsub!(/#{@csv_sep}$/, "")
		return outrec
	end
#----------------------------------------------------------------------
# ハッシュ(正規表現)とハッシュを比較(hash_regexがhashにマッチすれば true)
#----------------------------------------------------------------------
	def hash_match_hash(hash_regex, hash)
		match_sw = true
		hash_regex.each {|k, v|
			if (/#{v.to_s}/ !~ hash[k.to_s].to_s)
				match_sw = false
				break
			end
		}
		return match_sw
	end
#----------------------------------------------------------------------
# 取得条件合致レコードをテンポラリに出力する
#----------------------------------------------------------------------
	def get_outtmp(hash_key)
		cp = open(@csv_path, "r")
		op = open(@csv_path + ".tmp", "w")
		while (rec = cp.gets)
			rec.chomp!
			hash_rec = rec2hash(rec)
			if (hash_match_hash(hash_key, hash_rec))
				op.write(rec + "\n")
			end
		end
		cp.close
		op.close
	end
#----------------------------------------------------------------------
# キーが指定値以上のレコードをテンポラリに出力する
#----------------------------------------------------------------------
	def get_ge_outtmp(hash_key)
		inkey = ""
		hash_key.each {|k, v|
			inkey += v
		}
#
		cp = open(@csv_path, "r")
		op = open(@csv_path + ".tmp", "w")
		while (rec = cp.gets)
			rec.chomp!
			hash_rec = rec2hash(rec)
#
			reckey = ""
			hash_key.each {|k, v|
				reckey += hash_rec[k]
			}
#
			if (reckey >= inkey)
				op.write(rec + "\n")
			end
		end
		cp.close
		op.close
	end
#----------------------------------------------------------------------
# 取得条件合致レコードを返すイテレータ
#----------------------------------------------------------------------
	def get_outraw_each(hash_key)
		cp = open(@csv_path, "r")
		while (rec = cp.gets)
			rec.chomp!
			hash_rec = rec2hash(rec)
			if (hash_match_hash(hash_key, hash_rec))
				yield rec
			end
		end
		cp.close
	end
#----------------------------------------------------------------------
# キーが指定値以上のレコードを返すイテレータ
#----------------------------------------------------------------------
	def get_ge_outraw_each(hash_key)
		inkey = ""
		hash_key.each {|k, v|
			inkey += v
		}
#
		cp = open(@csv_path, "r")
		while (rec = cp.gets)
			rec.chomp!
			hash_rec = rec2hash(rec)
#
			reckey = ""
			hash_key.each {|k, v|
				reckey += hash_rec[k]
			}
#
			if (reckey >= inkey)
				yield rec
			end
		end
		cp.close
	end
#----------------------------------------------------------------------
# 取得コマンド編集
#----------------------------------------------------------------------
	def get_command(input, sort_sw, uniq_sw)
		input = sh_esc(input)
		command = ""
		if (sort_sw)
			if (uniq_sw)
				command = "sort #{input} | uniq"
			else
				command = "sort #{input}"
			end
		else
			command = "cat #{input}"
		end
		return command
	end
#----------------------------------------------------------------------
# レコードが取得対称範囲であればハッシュで返す
#----------------------------------------------------------------------
	def get_hash(rec, start, total, rec_count, out_count)
		hash_rec = {}
		status = "no"
		rec_count += 1
		if (rec_count >= start)
			if (total == -1)
				hash_rec = rec2hash(rec)
				status = "yes"
			else
				out_count += 1
				if (out_count <= total)
					hash_rec = rec2hash(rec)
					status = "yes"
				else
					status = "end"
				end
			end
		end
		return [status, hash_rec, rec_count, out_count]
	end
#----------------------------------------------------------------------
# ファイルの移動
#----------------------------------------------------------------------
	def move_file(from, to)
		File.rename(to, to + ".ORG")
		File.rename(from, to)
		File.unlink(to + ".ORG")
	end
#----------------------------------------------------------------------
# シェルに渡すパラメータのエスケープ
#----------------------------------------------------------------------
	def sh_esc(str)
		str.to_s.gsub(/(.)/){'\\' + $1}
	end
#======================================================================
# 公開メソッド
#======================================================================
#----------------------------------------------------------------------
# 追加処理
#----------------------------------------------------------------------
	def create(hash_rec, vacuum_sw = false, uniq_sw = true)
#
# 単純に後方追加
#
		outrec = hash2rec(hash_rec)
		op = open(@csv_path, "a")
		op.write(outrec + "\n")
		op.close
#
# バキューム処理
#
		if (vacuum_sw)
			vacuum(uniq_sw)
		end
	end
#----------------------------------------------------------------------
# 削除処理(正規表現)
#----------------------------------------------------------------------
	def delete(hash_key, vacuum_sw = false, uniq_sw = true)
		if (File.exist?(@csv_path))
#
# 削除しながらテンポラリに出力
#
			cp = open(@csv_path, "r")
			op = open(@csv_path + ".tmp", "w")
			while (rec = cp.gets)
				rec.chomp!
				hash_rec = rec2hash(rec)
				del_sw = hash_match_hash(hash_key, hash_rec)
				if (!del_sw)
					op.write(rec + "\n")
				end
			end
			cp.close
			op.close
#
# テンポラリから元のファイルに書き戻し
#
			move_file(@csv_path + ".tmp", @csv_path)
#
# バキューム処理
#
			if (vacuum_sw)
				vacuum(uniq_sw)
			end
		end
	end
#----------------------------------------------------------------------
# 更新処理(hash_keyは正規表現)
#----------------------------------------------------------------------
	def update(hash_key, hash_item, vacuum_sw = false, uniq_sw = true)
		if (File.exist?(@csv_path))
#
# 更新しながらテンポラリに出力
#
			cp = open(@csv_path, "r")
			op = open(@csv_path + ".tmp", "w")
			while (rec = cp.gets)
				rec.chomp!
				hash_rec = rec2hash(rec)
				update_sw = hash_match_hash(hash_key, hash_rec)
				if (update_sw)
					hash_item.each {|k, v|
						hash_rec[k.to_s] = v.to_s
					}
				end
				outrec = hash2rec(hash_rec)
				op.write(outrec + "\n")
			end
			cp.close
			op.close
#
# テンポラリから元のファイルに書き戻し
#
			move_file(@csv_path + ".tmp", @csv_path)
#
# バキューム処理
#
			if (vacuum_sw)
				vacuum(uniq_sw)
			end
		end
	end
#----------------------------------------------------------------------
# 取得処理(イテレータ版)(hash_keyは正規表現)
#----------------------------------------------------------------------
	def read_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# 指定条件に合致するレコードをテンポラリに出力
#
				get_outtmp(hash_key)
#
# 取得コマンドを得る
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# 検索結果を返す
#
				rec_count = 0
				out_count = 0
				for rec in `#{command}`
					rec.chomp!
					(status, return_hash, rec_count, out_count) =  get_hash(rec, start, total, rec_count, out_count)
					if (status == "yes")
						yield return_hash
					elsif (status == "end")
						break
					end
				end
#
# テンポラリの削除
#
				File.unlink(@csv_path + ".tmp")
			else
#
# 未加工状態で返す(テンポラリを介さないので高速)
#
				get_outraw_each(hash_key) {|rec|
					yield rec2hash(rec)
				}
			end
		end
	end
#----------------------------------------------------------------------
# 取得処理(配列版)(hash_keyは正規表現)
#----------------------------------------------------------------------
	def read_array(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		array_return = []
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# 指定条件に合致するレコードをテンポラリに出力
#
				get_outtmp(hash_key)
#
# 取得コマンドを得る
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# 検索結果を返す
#
				rec_count = 0
				out_count = 0
				for rec in `#{command}`
					rec.chomp!
					(status, return_hash, rec_count, out_count) =  get_hash(rec, start, total, rec_count, out_count)
					if (status == "yes")
						array_return.push(return_hash)
					elsif (status == "end")
						break
					end
				end
#
# テンポラリの削除
#
				File.unlink(@csv_path + ".tmp")
			else
#
# 未加工状態で返す(テンポラリを介さないので高速)
#
				get_outraw_each(hash_key) {|rec|
					array_return.push(rec2hash(rec))
				}
			end
		end
#
# 結果を返す
#
		return array_return
	end
#----------------------------------------------------------------------
# 指定キー以降取得処理(イテレータ版)
#----------------------------------------------------------------------
	def read_ge_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# 指定条件に合致するレコードをテンポラリに出力
#
				get_ge_outtmp(hash_key)
#
# 取得コマンドを得る
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# 検索結果を返す
#
				rec_count = 0
				out_count = 0
				for rec in `#{command}`
					rec.chomp!
					(status, return_hash, rec_count, out_count) =  get_hash(rec, start, total, rec_count, out_count)
					if (status == "yes")
						yield return_hash
					elsif (status == "end")
						break
					end
				end
#
# テンポラリの削除
#
				File.unlink(@csv_path + ".tmp")
			else
#
# 未加工状態で返す(テンポラリを介さないので高速)
#
				get_ge_outraw_each(hash_key) {|rec|
					yield rec2hash(rec)
				}
			end
		end
	end
#----------------------------------------------------------------------
# バキューム処理
#----------------------------------------------------------------------
	def vacuum(uniq_sw = true)
		if (File.exist?(@csv_path))
#
# バキュームしながらテンポラリに出力
#
			outfile = sh_esc(@csv_path + ".tmp")
			system("#{get_command(@csv_path, true, uniq_sw)} >#{outfile}")
#
# テンポラリから元のファイルに書き戻し
#
			move_file(@csv_path + ".tmp", @csv_path)
		end
	end
end

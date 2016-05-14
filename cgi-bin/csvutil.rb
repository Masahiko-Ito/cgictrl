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
# CSV���饹 Ver 0.1 2009.07.07 by Masahiko Ito <m-ito@myh.no-ip.org>
#
# ���Υ��饹�ǰ���CSV�ե�����ϰʲ��η����Ǥ��롣���᡼���Ȥ��ƤϿ�ɴ�狼��
# ��������٤Υǡ����򰷤���ΤȤ��롣
#
#    ����̾��=������[���ѥ졼��] ... [���ѥ졼��]����̾��=������[����ʸ��]
#
# [���ѥ졼��]�δ����ͤ� "\t" �Ȥ��롣
#
# �ɲý���
#
#	def create(hash_rec, vacuum_sw = false, uniq_sw = true)
#
# �������(����ɽ��)
#
#	def delete(hash_key, vacuum_sw = false, uniq_sw = true)
#
# ��������(hash_key������ɽ��)
#
#	def update(hash_key, hash_item, vacuum_sw = false, uniq_sw = true)
#
# ��������(���ƥ졼����)(hash_key������ɽ��)
#
#	def read_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# ��������(������)(hash_key������ɽ��)
#
#	def read_array(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# ���ꥭ���ʹ߼�������(���ƥ졼����)
#
#	def read_ge_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
#
# �Х��塼�����
#
#	def vacuum(uniq_sw = true)
#
class Csvutil
#----------------------------------------------------------------------
# ���󥹥����ѿ�
#----------------------------------------------------------------------
	attr_accessor :csv_path
	attr_accessor :csv_sep
#----------------------------------------------------------------------
# ���������
#----------------------------------------------------------------------
	def initialize(path, sep = "\t")
		@csv_path = path
		@csv_sep = sep
	end
#======================================================================
# �������ѥ᥽�å�
#======================================================================
#----------------------------------------------------------------------
# �쥳���ɤ�ϥå�����Ѵ�
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
# �ϥå����쥳���ɤ��Ѵ�
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
# �ϥå���(����ɽ��)�ȥϥå�������(hash_regex��hash�˥ޥå������ true)
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
# ���������ץ쥳���ɤ�ƥ�ݥ��˽��Ϥ���
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
# �����������Ͱʾ�Υ쥳���ɤ�ƥ�ݥ��˽��Ϥ���
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
# ���������ץ쥳���ɤ��֤����ƥ졼��
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
# �����������Ͱʾ�Υ쥳���ɤ��֤����ƥ졼��
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
# �������ޥ���Խ�
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
# �쥳���ɤ������о��ϰϤǤ���Хϥå�����֤�
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
# �ե�����ΰ�ư
#----------------------------------------------------------------------
	def move_file(from, to)
		File.rename(to, to + ".ORG")
		File.rename(from, to)
		File.unlink(to + ".ORG")
	end
#----------------------------------------------------------------------
# ��������Ϥ��ѥ�᡼���Υ���������
#----------------------------------------------------------------------
	def sh_esc(str)
		str.to_s.gsub(/(.)/){'\\' + $1}
	end
#======================================================================
# �����᥽�å�
#======================================================================
#----------------------------------------------------------------------
# �ɲý���
#----------------------------------------------------------------------
	def create(hash_rec, vacuum_sw = false, uniq_sw = true)
#
# ñ��˸����ɲ�
#
		outrec = hash2rec(hash_rec)
		op = open(@csv_path, "a")
		op.write(outrec + "\n")
		op.close
#
# �Х��塼�����
#
		if (vacuum_sw)
			vacuum(uniq_sw)
		end
	end
#----------------------------------------------------------------------
# �������(����ɽ��)
#----------------------------------------------------------------------
	def delete(hash_key, vacuum_sw = false, uniq_sw = true)
		if (File.exist?(@csv_path))
#
# ������ʤ���ƥ�ݥ��˽���
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
# �ƥ�ݥ�꤫�鸵�Υե�����˽��ᤷ
#
			move_file(@csv_path + ".tmp", @csv_path)
#
# �Х��塼�����
#
			if (vacuum_sw)
				vacuum(uniq_sw)
			end
		end
	end
#----------------------------------------------------------------------
# ��������(hash_key������ɽ��)
#----------------------------------------------------------------------
	def update(hash_key, hash_item, vacuum_sw = false, uniq_sw = true)
		if (File.exist?(@csv_path))
#
# �������ʤ���ƥ�ݥ��˽���
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
# �ƥ�ݥ�꤫�鸵�Υե�����˽��ᤷ
#
			move_file(@csv_path + ".tmp", @csv_path)
#
# �Х��塼�����
#
			if (vacuum_sw)
				vacuum(uniq_sw)
			end
		end
	end
#----------------------------------------------------------------------
# ��������(���ƥ졼����)(hash_key������ɽ��)
#----------------------------------------------------------------------
	def read_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# ������˹��פ���쥳���ɤ�ƥ�ݥ��˽���
#
				get_outtmp(hash_key)
#
# �������ޥ�ɤ�����
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# ������̤��֤�
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
# �ƥ�ݥ��κ��
#
				File.unlink(@csv_path + ".tmp")
			else
#
# ̤�ù����֤��֤�(�ƥ�ݥ���𤵤ʤ��Τǹ�®)
#
				get_outraw_each(hash_key) {|rec|
					yield rec2hash(rec)
				}
			end
		end
	end
#----------------------------------------------------------------------
# ��������(������)(hash_key������ɽ��)
#----------------------------------------------------------------------
	def read_array(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		array_return = []
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# ������˹��פ���쥳���ɤ�ƥ�ݥ��˽���
#
				get_outtmp(hash_key)
#
# �������ޥ�ɤ�����
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# ������̤��֤�
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
# �ƥ�ݥ��κ��
#
				File.unlink(@csv_path + ".tmp")
			else
#
# ̤�ù����֤��֤�(�ƥ�ݥ���𤵤ʤ��Τǹ�®)
#
				get_outraw_each(hash_key) {|rec|
					array_return.push(rec2hash(rec))
				}
			end
		end
#
# ��̤��֤�
#
		return array_return
	end
#----------------------------------------------------------------------
# ���ꥭ���ʹ߼�������(���ƥ졼����)
#----------------------------------------------------------------------
	def read_ge_each(hash_key, start = 1, total = -1, sort_sw = true, uniq_sw = true)
		if (File.exist?(@csv_path))
			if (sort_sw)
#
# ������˹��פ���쥳���ɤ�ƥ�ݥ��˽���
#
				get_ge_outtmp(hash_key)
#
# �������ޥ�ɤ�����
#
				command = get_command(@csv_path + ".tmp", sort_sw, uniq_sw)
#
# ������̤��֤�
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
# �ƥ�ݥ��κ��
#
				File.unlink(@csv_path + ".tmp")
			else
#
# ̤�ù����֤��֤�(�ƥ�ݥ���𤵤ʤ��Τǹ�®)
#
				get_ge_outraw_each(hash_key) {|rec|
					yield rec2hash(rec)
				}
			end
		end
	end
#----------------------------------------------------------------------
# �Х��塼�����
#----------------------------------------------------------------------
	def vacuum(uniq_sw = true)
		if (File.exist?(@csv_path))
#
# �Х��塼�ष�ʤ���ƥ�ݥ��˽���
#
			outfile = sh_esc(@csv_path + ".tmp")
			system("#{get_command(@csv_path, true, uniq_sw)} >#{outfile}")
#
# �ƥ�ݥ�꤫�鸵�Υե�����˽��ᤷ
#
			move_file(@csv_path + ".tmp", @csv_path)
		end
	end
end

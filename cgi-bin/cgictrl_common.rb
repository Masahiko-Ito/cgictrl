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
#   Cgictrl class ���
#
#============================================================
#
# Cgictrl class
#
#============================================================
class Cgictrl
#------------------------------------------------------------
#
# ���󥹥����ѿ����������᥽�å����
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
# �����
#
#------------------------------------------------------------
	def initialize
#
# !! �����ͤ���������ϡ��褯���򤷤���ǹԤ��ޤ��礦����������� !!
#
# https(ssl)�̿������������ `y' �򥻥åȤ��롣
#
		@force_https = "n"
#
# [���]�ܥ�����̤ä��ڡ�������ν�����³��ػߤ������ `y' �򥻥åȤ��롣
#
		@backward_deny = "y"
#
# ɸ���nkf�Ѵ��ѥ�᡼���򥻥åȤ��롣
#
# �ǥե���ȤΥѥ�᡼���˴ؤ���
#  o ���Ϥ�html��charset=EUC-JP�Ǻ�������Ƥ����������Ȥʤ�(-E)��
#  o Ⱦ�ѥ��ʤ����ѥ��ʤ��Ѵ�����(-X)��
#  o ���ѱѿ�����Ⱦ�ѱѿ������Ѵ�����(-Z1)��
#  o ������EUC���Ѵ�����(-e)��
#
		@default_nkf_param = "-E -X -Z1 -e"
#
# <form>��������ϥǡ�������ե�����˻Ĥ����� `y' �򥻥åȤ��롣
#
		@get_log_input_flag = "y"
#
# stdout�˽��Ϥ����ǡ�������ե�����˻Ĥ����� `y' �򥻥åȤ��롣
#
		@get_log_send_flag = "y"
#
# �ȥ�󥶥������μ¹Ե��ݤ���ե�����˻Ĥ����� `y' �򥻥åȤ��롣
#
		@get_log_deny_flag = "y"
#
# �ȥ�󥶥����������Ǥ��륨�顼��å���������ե�����˻Ĥ����� `y' �򥻥åȤ��롣
#
		@get_log_error_flag = "y"
#
# cgictrl�����Ѥ���ǡ����ǥ��쥯�ȥ�λ���(http�����Фμ¸��桼�����񤭹��߽�����)��
#
		@cgictrl_data_dir = "/home/m-ito/cgictrl"
#
# �ȥ�󥶥������ to �ץ�����Ѵ��ơ��֥�ե�����λ��ꡣ
#
		@tran2pgm_file = @cgictrl_data_dir + "/" + "tran2pgm.txt"
#
# �桼�� to �ȥ�󥶥��������ĥե�����λ��ꡣ
#
		@usertran_file = @cgictrl_data_dir + "/" + "usertran.txt"
#
# ��¾�оݥ꥽������Ͽ�ե�����λ��ꡣ
#
		@resource_file = @cgictrl_data_dir + "/" + "resource.txt"
#
# html�ե������Ǽ�ǥ��쥯�ȥ�λ���(http�����Фμ¸��桼�����ɤ߹��߽�����)��
#
		@html_dir = @cgictrl_data_dir + "/" + "html"
#
# cgictrl�����ƥ२�顼����html�ե������ID����ꡣ
#
		@error_msg_id = "cgictrl_error"
#
# cgictrl�����ƥ२�顼����html�ե�������Υ�å���������̾�Τ���ꡣ
#
		@error_msg_string = "error_message"
#
# ��¾�����Ѥοƥǥ��쥯�ȥ�λ���(http�����Фμ¸��桼�����񤭹��߽�����)��
#
		@lock_parent_dir = @cgictrl_data_dir + "/" + "lock"
#
# ��¾����ǥ��쥯�ȥ�Υե����ޥåȤ����(`%s'��ʬ�ˤϥ꥽����ID������)��
#
		@lock_dir_format = "%s.dir"
#
# ��¾����ե��������ꡣ
#
		@lock_file = "lock.txt"
#
# ��¾��ȥ饤���δֳ�(��)����ꡣ
#
		@lock_sleep_sec = 1
#
# ��¾��ȥ饤�β������ꡣ
#
		@lock_retry_max = 60
#
# �������(��)���Ť�SPA�ե���������оݤȤ��롣
#
		@sweep_time_before = 2 * 24 * 60 * 60
#
# html�ե�������ι��ܳ���ʸ����̾�Ρ���λʸ����̾�Τδ����ͤ���ꡣ
#
		@html_start_param = "START"
		@html_end_param = "END"
#
# html�ե�������ι��ܳ���ʸ���󡢽�λʸ����δ����ͤ���ꡣ
#
		@html_start_default = "@\\{"
		@html_end_default = "\\}@"
#
# html�ե�������ι��ܳ���ʸ���󡢽�λʸ����κǽ�Ū���ͤ�16��ʸ����
#
		@start_str_hex = "01"
		@end_str_hex = "02"
#
# ����Ͽ�ե�����Υ꥽����ID����Ǽ�ǥ��쥯�ȥꡢ�ե�������Τλ��ꡣ
#
		@log_file_res = "LOGFILE"
		@log_dir = @cgictrl_data_dir + "/" + "log"
		(stat, @log_file) = check_res(@log_file_res)
		if (!stat)
			@log_file = @log_dir + "/" + "log.txt"
		end
#
# SPA(Scratch Pad Area)�ե������Ǽ�ǥ��쥯�ȥꡢ�꥽����ID�λ���(http�����Фμ¸��桼�����񤭹��߽�����)��
#
		@spa_dir_res = "SPADIR"
		(stat, @spa_dir) = check_res(@spa_dir_res)
		if (!stat)
			@spa_dir = @cgictrl_data_dir + "/" + "spa"
		end
#
# !! �����ͤ���������ϡ��褯���򤷤���ǹԤ��ޤ��礦���������ޤ� !!
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
# ��˥���ȥ���ץ����(cgictrl.cgi)�ǻ��Ѥ���᥽�å�
#
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#------------------------------------------------------------
#
# CGI raw�ѥ�᡼������
#
# ��  ����̵��
# ����͡��֥饦������CGI���Ϥ����(�����֤�)�ѥ�᡼��
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
# CGI�ѥ�᡼��������
#
# ��  ����name ... <form>������Ϲ���̾(<input name="����" ...> etc)
#         nkf_param ... ���Ϲ��ܤ�nkf���Ѵ�����ݤΥ��ץ����
# ����͡��ǥ����ɤ����nkf�ˤ���Ѵ�������Ϲ���(String)
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
# CGI�ѥ�᡼������
#    @input[����̾��] ... �������Ƥμ�������
#    @input_file[����̾��] ... ���åץ��ɥե�����μ�������
#
# ��  ����nkf_param ... ���Ϲ��ܤ�nkf���Ѵ�����ݤΥ��ץ����
# ����͡�̵��
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
# URL�ǥ����ɡ�ʸ���������Ѵ�
#
# ��  ����str ... URL���󥳡��ɤ��줿ʸ����
#         nkf_param ... nkf���Ѵ�����ݤΥ��ץ����
# ����͡��Ѵ����ʸ����
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
# �ȥ�󥶥�����󥳡��ɤ���CGI�ץ�������
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
# ����͡�CGI�ץ����ؤΥѥ�
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
# �ȥ�󥶥�����󥳡��ɤ���꥽����ID����
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
# ����͡�[�꥽����ID/���������⡼��, ...] (����)
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
# �꥽����ID�ºߥ����å�&�꥽�������μ���
#
# ��  ����res ... �꥽����ID
# ����͡�[���ơ�����, �꥽�����μ��Τ�ɽ��ʸ����] (����)
#          ���ơ����� ... true  : ����OK
#                         false : ����NG
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# sessionID�ե�������SPA����
#    @spa[����̾] ... SPA���ܼ�������
# 
# ��  ����sessionid ... ���å����ID
# ����͡�̵��
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
# SPA��sessionID�ե��������¸
#
# ��  ����sessionid ... ���å����ID
# ����͡�̵��
#
#   o ���Ƴ�ǧ�ϰʲ��Υ��饤�ʡ���...
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
# �ȥ�󥶥������ưȽ��
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
# ����͡����ơ����� ... true  : ��ưOK
#                        false : ��ưNG
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
# userid�����å����CGI��ư
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
# ����͡����ơ����� ... true  : ��ư����
#                        false : ��ư����
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# ��Ư����Ͽ
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
#         msg ... ��Ͽ�����å�����
# ����͡����ơ����� ... true  : ����OK
#                        false : ����NG
#
#   o ���Ƴ�ǧ�ϰʲ��Υ��饤�ʡ���...
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
# ��¾�򤫤��Ƥ���ץ���ID�����Ư�Ǥ�����Υ����å�
#
# ��  ����res ... �꥽����ID
# ����͡����ơ����� ... true  : ���Ư�Ǥ���
#                        false : ��Ư��Ǥ���
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
# ��¾ON
#
# ��  ����array_res_mode ... [�꥽����ID/���������⡼��, ...] (����)
# ����͡����ơ����� ... true  : ��¾������λ
#                        false : ��¾��������
#
# ��� : �ܥ롼����Ǥϥ��������⡼�ɤϰ�̣������ʤ�(̤����)��
#        ����Ū�ˤ�
#
#             A : �����⡼��
#             G : ���ȥ⡼��
#
#         �Ρ�2��٥��å������������...
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
# ��¾OFF
#
# ��  ����array_res_mode ... [�꥽����ID[/���������⡼��], ...] (����)
# ����͡����ơ����� ... true  : ��¾������λ
#                        false : ��¾��������
#
# �ܥ롼����Ǥϥ��������⡼�ɤϰ�̣������ʤ������˻��ꤷ�Ƥ�̵�뤵��롣
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
# ��¾ON(ñ��꥽����)
#
# ��  ����res_mode ... �꥽����ID/���������⡼��
# ����͡����ơ����� ... true  : ��¾������λ
#                        false : ��¾��������
#
# ��� : �ܥ롼����Ǥϥ��������⡼�ɤϰ�̣������ʤ�(̤����)��
#        ����Ū�ˤ�
#
#             A : �����⡼��
#             G : ���ȥ⡼��
#
#         �Ρ�2��٥��å������������...
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# ������¾OFF
#
# ��  ����res ... �꥽����ID
# ����͡����ơ����� ... true  : ��¾������λ
#                        false : ��¾��������
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
# ��¾OFF(ñ��꥽����)
#
# ��  ����res ... �꥽����ID
# ����͡����ơ����� ... true  : ��¾������λ
#                        false : ��¾��������
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
# https�����å�
#
# ��  ����̵��
# ����͡����ơ����� ... true  : https�����å�OK
#                        false : https�����å�NG(https���׵ᤵ��Ƥ���Τ�https�̿��Ǥʤ�)
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# ���ѥ��顼��å���������(��������å�������HTTP���ơ������쥹
# �ݥ󥹤η����ξ���html�ե������𤵤�ľ�ܽ��Ϥ���)
#
# ��  ����tran ... �ȥ�󥶥�����󥳡���
#         msg  ... ɽ����å�����
# ����͡�̵��
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# �ȥ�󥶥�����󡢥��å����ID�����������å�
#
# ��  ����tran ... ɽ����å�����
#         sessionid ... ���å����ID
# ����͡����ơ����� ... true  : �����å�OK
#                        false : �����å�NG
#
# ��� : �桼���ץ������ܥ롼������ѻ��� false ���֤��줿
#        ���� out_html() ��ƤӽФ���̵����������λ���ʤ�
#        ��Фʤ�ʤ�(�̾�ϻȤ�ʤ�)��
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
# SPA���ݽ�
#
# ��  ����̵��
# ����͡�̵��
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
# ��˥桼���ץ����ǻ��Ѥ���᥽�å�
#
#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#------------------------------------------------------------
#
# ���饤����ȳ��Ͻ���
#
# ��  ����nkf_param ... ���Ϲ��ܤ�nkf���Ѵ�����ݤΥ��ץ����
# ����͡����å����ID
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
# ���饤����Ƚ�λ����
#
# ��  ����tran ... ����˵�ư����ȥ�󥶥����������
# ����͡�̵��
#
#------------------------------------------------------------
	def end(tran)
		@spa[@next_tran_key] = tran
		set_spa_all(@input[@sessionid_key])
	end
#------------------------------------------------------------
#
# ����ȥ�����(�����ȥ�󥶥������)����
#
# ��  ����̵��
# ����͡����ơ����� ... true  : �����ȥ�󥶥������Ǥ���
#                        false : �����ȥ�󥶥������Ǥ���
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
# ����ȥ�����(�����ȥ�󥶥������)����
#
# ��  ����̵��
# ����͡����ơ����� ... true  : �����ȥ�󥶥������Ǥ���
#                        false : �����ȥ�󥶥������Ǥ���
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
# �꥽�������μ���
#
# ��  ����res ... �꥽����ID
# ����͡��꥽�����μ��Τ�ɽ��ʸ����
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
# ����ץåȥǡ�������
#
# ��  ����key ... ����̾��
# ����͡����ܤ��Ф�����(���ͥǡ�����ޤ������ʸ����Ȥ����֤�ޤ�)
#
#------------------------------------------------------------
	def get_input(key)
		return @input[key.to_s].to_s
	end
#------------------------------------------------------------
#
# ����ץåȥǡ�������
#
# ��  ����key ... ����̾��
#         value ... ���ܤ��Ф������ꤹ����
# ����͡�̵��
#
#------------------------------------------------------------
	def set_input(key, value)
		@input[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# ����ץåȥե�����ǡ�������
#
# ��  ����key ... ����̾��
# ����͡����ܤ��Ф�����
#
#------------------------------------------------------------
	def get_input_file(key)
		return @input_file[key.to_s].to_s
	end
#------------------------------------------------------------
#
# ����ץåȥե�����ǡ�������
#
# ��  ����key ... ����̾��
#         value ... ���ܤ��Ф������ꤹ����
# ����͡�̵��
#
#------------------------------------------------------------
	def set_input_file(key, value)
		@input_file[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# SPA�ǡ�������
#
# ��  ����key ... ����̾��
# ����͡����ܤ��Ф�����(���ͥǡ�����ޤ������ʸ����Ȥ����֤�ޤ�)
#
#------------------------------------------------------------
	def get_spa(key)
		return @spa[key.to_s].to_s
	end
#------------------------------------------------------------
#
# SPA�ǡ�������
#
# ��  ����key ... ����̾��
#         value ... ���ܤ��Ф������ꤹ����
# ����͡�̵��
#
#------------------------------------------------------------
	def set_spa(key, value)
		@spa[key.to_s] = value.to_s
	end
#------------------------------------------------------------
#
# SPA���ꥢ��
#
# ��  ����̵��
# ����͡�̵��
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
# SPA�������ꥢ��
#
# ��  ����̵��
# ����͡�̵��
#
#------------------------------------------------------------
	def destroy_spa()
		@spa = {}
	end
#------------------------------------------------------------
#
# html���Ͻ���
#
# ��  ����id ... html�ե�����ID
#         hash_param ... { ���� => ��, ...} (html����������)
# ����͡����ơ����� ... true  : ����
#                        false : ����
#
#   ex. hash_param = { "key" => "value" } �ξ��
#       `#{id}.html' ��� `#{start_str}key#{end_str}' �� `value' ���֤������롣
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
# �ǥХå��ե����륯�ꥢ��
#
#------------------------------------------------------------
	def clear_debug()
		fp = open("/tmp/debug.txt", "w")
		fp.puts("")
		fp.close
	end
#------------------------------------------------------------
#
# �ǥХå�����
#
#------------------------------------------------------------
	def debug(str)
		fp = open("/tmp/debug.txt", "a")
		fp.puts(str)
		fp.close
	end
end

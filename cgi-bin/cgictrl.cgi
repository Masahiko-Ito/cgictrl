#! /usr/bin/ruby -I.
# coding: utf-8
#
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
# cgictrl by Masahiko Ito <m-ito@myh.no-ip.org>
# 
#   cgictrl.cgi : CGI control script
#
#   ex. <a href="http://foo.org/cgi-bin/cgictrl.cgi?SYS_init_tran=トランザクション名">ラベル</a>
#
require "cgi"
require "uri"
require "nkf"
require "cgictrl_common"
#============================================================
#
# 主処理 定義
#
def	main()
	cc = Cgictrl.new
#
	File.umask(cc.umask)
#
	cc.sweep_spa()
#
	if (!cc.check_https())
		exit 1
	end
#
	cc.get_raw_param()
	init_tran = cc.peek_param(cc.init_tran_key, cc.default_nkf_param)
	sessionid = cc.peek_param(cc.sessionid_key, cc.default_nkf_param)
	if (!cc.check_tran_sessionid(init_tran, sessionid))
		exit 1
	end
#------------------------------------------------------------
	if (init_tran == "" && sessionid != "")
		next_tran = pre_exec(cc, sessionid, "n")
		exec(cc, next_tran)
	end
#------------------------------------------------------------
	if (init_tran == "" && sessionid != "")
		next_tran = pre_exec(cc, sessionid, "y")
		exec(cc, next_tran)
	else
		exec(cc, init_tran)
	end
end
#------------------------------------------------------------
#
# トランザクション起動前処理 定義
#
def pre_exec(cc, sessionid, flag)
	cc.get_spa_all(sessionid)
	tran = cc.spa[cc.next_tran_key]
	cc.spa[cc.first_tran_flag_key] = flag
	cc.set_spa_all(sessionid)
	return tran
end
#------------------------------------------------------------
#
# トランザクション起動処理 定義
#
def exec(cc, tran)
	array_res_mode = cc.get_res_from_tran(tran)
	array_res_mode.sort.each do |res_mode|
		(res, mode) = res_mode.split("/", 2)
		(stat, realres) = cc.check_res(res)
		if (!stat)
			exit 1
		end
	end
	if (!cc.lock(array_res_mode))
		exit 1
	end
	if (!cc.spawn_cgi_with_check(tran))
		exit 1
	end
	cc.unlock(array_res_mode)
end
#============================================================
#
# 主処理 呼出し
#
main()
#
exit 0

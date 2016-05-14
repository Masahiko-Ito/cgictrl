#! /usr/bin/ruby
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
# cgictrl ver.0.1 2009.07.07 Masahiko Ito <m-ito@myh.no-ip.org>
#
#   �桼�������ǥ��󥰥���ץ륹����ץ�
#
require "cgi"
require "uri"
require "nkf"
require "cgictrl_common"
#--- user coding start ---
#--- user coding end   ---
#
# �ᥤ�����
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
# �����ץ����
#
#    o DB��³ etc
#
def sub_open(cc)
#--- user coding start ---
#--- user coding end   ---
end
#
# �����Խ�����
#
#   o spa�ˤ���Ϥ��줿�ǡ���(cc.get_spa("...."))�򸵤˲��̤��Խ�����
#   o ���˵�ư����ȥ�󥶥������(�̾�ϼ��ȥ�󥶥�������Ʊ��)���֤�
#
def sub_send(cc)
#--- user coding start ---

	return "���ȥ�󥶥�����󥳡���"
#--- user coding end   ---
end
#
# ���ϥǡ�������
#
#   o ���ϥǡ���(cc.get_input("...."))���������
#   o ���Υȥ�󥶥��������Ϥ��ǡ�����spa�˥��åȤ���
#   o ���˵�ư����ȥ�󥶥��������֤�
#
def sub_recieve(cc)
#--- user coding start ---

	return "���Υȥ�󥶥������"
#--- user coding end   ---
end
#
# ����������
#
#    o DB���� etc
#
def sub_close(cc)
#--- user coding start ---
#--- user coding end   ---
end
#
# ����¾�Υ桼���ؿ����
#
#--- user coding start ---
#--- user coding end   ---
#
# �ᥤ���������
#
main()

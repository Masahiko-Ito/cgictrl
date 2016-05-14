#! /usr/bin/ruby
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
#   o spa�ˤ���Ϥ��줿�ǡ����򸵤˲��̤��Խ�����
#   o ���˵�ư����ȥ�󥶥������(�̾�ϼ��ȥ�󥶥�������Ʊ��)���֤�
#
def sub_send(cc)
#--- user coding start ---
	html_param = {}
	html_param["param"] = "setted_param"
	html_param["input_text"] = cc.get_spa("input_text")
	html_param["input_file"] = cc.get_spa("input_file")
	html_param["input_file_data"] = cc.get_spa("input_file_data")
	html_param["textarea"] = cc.get_spa("textarea")
	html_param["referer"] = ENV['HTTP_REFERER'].gsub(/cgi-bin\/.*/, "")
	cc.out_html("sample1", html_param)

	return "TEST"
#--- user coding end   ---
end
#
# ���ϥǡ�������
#
#   o ���ϥǡ������������
#   o ���Υȥ�󥶥��������Ϥ��ǡ�����spa�˥��åȤ���
#   o ���˵�ư����ȥ�󥶥��������֤�
#
def sub_recieve(cc)
#--- user coding start ---
	cc.set_spa("input_text", "==" + cc.get_input("input_text") + "==")
	cc.set_spa("input_file", "==" + cc.get_input("input_file") + "==")
	cc.set_spa("input_file_data", "==" + cc.get_input_file("input_file") + "==")
	cc.set_spa("textarea", "==" + cc.get_input("textarea") + "==")

	return "TEST"
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

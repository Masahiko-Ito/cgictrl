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
	pi = 3.14
	html_param = {}
	html_param["hankei"] = cc.get_spa("hankei")
	html_param["menseki"] = pi * cc.get_spa("hankei").to_f ** 2
	html_param["taiseki"] = 4.0 / 3.0 * pi * cc.get_spa("hankei").to_f ** 3

	cc.out_html("samp_calc_result", html_param)

	return "SAMP_CALC_RESULT"
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
	cc.set_spa("err_sw", "")

	return "SAMP_CALC_ENTRY"
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

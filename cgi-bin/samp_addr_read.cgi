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
require "csvutil"
$csv = ""
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
	$csv = Csvutil.new(cc.get_realres("RES_ADDR"))
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
	html_param = {}
	cc.out_html("samp_addr_view_head", html_param)

	hash_key = {}
	if (cc.get_spa("name") != "")
		hash_key["name"] = cc.get_spa("name")
	end
	if (cc.get_spa("zipcode") != "")
		hash_key["zipcode"] = cc.get_spa("zipcode")
	end
	if (cc.get_spa("address") != "")
		hash_key["address"] = cc.get_spa("address")
	end
	if (cc.get_spa("birthday") != "")
		hash_key["birthday"] = cc.get_spa("birthday")
	end
	if (hash_key.size == 0)
		hash_key["name"] = "^.*$"
	end
	msg = "�ǡ��������Ĥ���ޤ���Ǥ���"
	$csv.read_each(hash_key) {|hash_rec|
		msg = ""
		html_param = {}
		html_param["name"] = hash_rec["name"]
		html_param["zipcode"] = hash_rec["zipcode"]
		html_param["address"] = hash_rec["address"]
		html_param["birthday"] = hash_rec["birthday"]
		cc.out_html("samp_addr_view_body", html_param)
		msg = ""
	}

	html_param = {}
	html_param["msg"] = msg
	if (msg != "")
		html_param["msg_color"] = "red"
	end
	cc.out_html("samp_addr_view_tail", html_param)

	return "SAMP_ADDR_READ"
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
	cc.set_spa("err_sw", "")

	if (cc.get_spa("err_sw") == "")
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		return "SAMP_ADDR_READ"
	end
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

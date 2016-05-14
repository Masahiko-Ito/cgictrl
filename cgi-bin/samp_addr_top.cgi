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
require "samp_addr"
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
#   o spa�ˤ���Ϥ��줿�ǡ���(cc.get_spa("..."))�򸵤˲��̤��Խ�����
#   o ���˵�ư����ȥ�󥶥������(�̾�ϼ��ȥ�󥶥�������Ʊ��)���֤�
#
def sub_send(cc)
#--- user coding start ---
	html_param = {}
	html_param["name"] = cc.get_spa("name")
	html_param["zipcode"] = cc.get_spa("zipcode")
	html_param["address"] = cc.get_spa("address")
	html_param["birthday"] = cc.get_spa("birthday")

	if (cc.get_spa("err_sw") == "ER_NAME")
		html_param["name_color"] = "red"
		html_param["msg"] = "��̾�����Ϥ�ľ���Ʋ�����"
	elsif (cc.get_spa("err_sw") == "ER_ZIPCODE")
		html_param["zipcode_color"] = "red"
		html_param["msg"] = "͹���ֹ�(999 ���� 999-9999)�����Ϥ�ľ���Ʋ�����"
	elsif (cc.get_spa("err_sw") == "ER_ADDRESS")
		html_param["address_color"] = "red"
		html_param["msg"] = "��������Ϥ�ľ���Ʋ�����"
	elsif (cc.get_spa("err_sw") == "ER_BIRTHDAY")
		html_param["birthday_color"] = "red"
		html_param["msg"] = "������(YYYYMMDD)�����Ϥ�ľ���Ʋ�����"
	elsif (cc.get_spa("err_sw") == "OK_ADD")
		html_param["msg"] = "��Ͽ���ޤ���"
	elsif (cc.get_spa("err_sw") == "OK_UPDATE")
		html_param["msg"] = "�������ޤ���"
	elsif (cc.get_spa("err_sw") == "OK_DEL")
		html_param["msg"] = "������ޤ���"
	elsif (cc.get_spa("err_sw") != "")
		html_param["msg"] = "���顼ȯ����"
	end

	if (cc.get_spa("err_sw") != "")
		html_param["msg_color"] = "red"
	end

	cc.out_html("samp_addr_top", html_param)

	return "SAMP_ADDR_TOP"
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

	name = Name.new(cc.get_input("name"))
	cc.set_spa("name", name.value)
	if (cc.get_input("entry") != "")
		if (!name.check)
			cc.set_spa("err_sw", "ER_NAME")
		end
	end

	zipcode = Zipcode.new(cc.get_input("zipcode"))
	cc.set_spa("zipcode", zipcode.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!zipcode.check)
				cc.set_spa("err_sw", "ER_ZIPCODE")
			end
		end
	end

	address = Address.new(cc.get_input("address"))
	cc.set_spa("address", address.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!address.check)
				cc.set_spa("err_sw", "ER_ADDRESS")
			end
		end
	end

	birthday = Birthday.new(cc.get_input("birthday"))
	cc.set_spa("birthday", birthday.value)
	if (cc.get_spa("err_sw") ==    "")
		if (cc.get_input("entry") != "")
			if (!birthday.check)
				cc.set_spa("err_sw", "ER_BIRTHDAY")
			end
		end
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("view") != "")
			return "SAMP_ADDR_READ"
		elsif (cc.get_input("entry") != "")
			return "SAMP_ADDR_CREATE"
		elsif (cc.get_input("update") != "")
			return "SAMP_ADDR_UPDATE"
		elsif (cc.get_input("delete") != "")
			return "SAMP_ADDR_DELETE"
		end
	else
		return "SAMP_ADDR_TOP"
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

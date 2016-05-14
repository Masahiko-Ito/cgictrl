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
#   o spa�ˤ���Ϥ��줿�ǡ���(cc.get_spa("...."))�򸵤˲��̤��Խ�����
#   o ���˵�ư����ȥ�󥶥������(�̾�ϼ��ȥ�󥶥�������Ʊ��)���֤�
#
def sub_send(cc)
#--- user coding start ---
	msg = ""
	html_param = {}
	cc.out_html("samp_addr_update_head", html_param)

	if (cc.get_spa("from_tran") == "SAMP_ADDR_UPDATE")
		number = 0
		while (number < cc.get_spa("record_number").to_i)
			html_param = {}
			html_param["number"] = number
			html_param["name"] = cc.get_spa("#{number}_name")
			html_param["zipcode"] = cc.get_spa("#{number}_zipcode")
			html_param["address"] = cc.get_spa("#{number}_address")
			html_param["birthday"] = cc.get_spa("#{number}_birthday")

			if (cc.get_spa("err_sw") == "ER_#{number}_NAME")
				html_param["name_color"] = "red"
				if (msg == "")
					msg = "��̾�����Ϥ�ľ���Ʋ�����"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_ZIPCODE")
				html_param["zipcode_color"] = "red"
				if (msg == "")
					msg = "͹���ֹ�(999 ���� 999-9999)�����Ϥ�ľ���Ʋ�����"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_ADDRESS")
				html_param["address_color"] = "red"
				if (msg == "")
					msg = "��������Ϥ�ľ���Ʋ�����"
				end
			elsif (cc.get_spa("err_sw") == "ER_#{number}_BIRTHDAY")
				html_param["birthday_color"] = "red"
				if (msg == "")
					msg = "������(YYYYMMDD)�����Ϥ�ľ���Ʋ�����"
				end
			end

			cc.out_html("samp_addr_update_body", html_param)

			number += 1
		end
	else
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
		number = 0
		$csv.read_each(hash_key) {|hash_rec|
			html_param = {}
			html_param["number"] = number
			html_param["name"] = hash_rec["name"]
			html_param["zipcode"] = hash_rec["zipcode"]
			html_param["address"] = hash_rec["address"]
			html_param["birthday"] = hash_rec["birthday"]
			cc.out_html("samp_addr_update_body", html_param)

			cc.set_spa("#{number}_old_name", hash_rec["name"])
			cc.set_spa("#{number}_old_zipcode", hash_rec["zipcode"])
			cc.set_spa("#{number}_old_address", hash_rec["address"])
			cc.set_spa("#{number}_old_birthday", hash_rec["birthday"])

			msg = ""

			number += 1
		}
		cc.set_spa("record_number", number)
	end

	html_param = {}
	html_param["msg"] = msg
	if (msg != "")
		html_param["msg_color"] = "red"
	end
	cc.out_html("samp_addr_update_tail", html_param)

	return "SAMP_ADDR_UPDATE"
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

	if (cc.get_input("ok") != "")
		number = 0
		while (number < cc.get_spa("record_number").to_i)

			name = Name.new(cc.get_input("#{number}_name"))
			if (cc.get_input("ok") != "")
				if (!name.check)
					cc.set_spa("err_sw", "ER_#{number}_NAME")
				end
			end
			cc.set_spa("#{number}_name", name.value)

			zipcode = Zipcode.new(cc.get_input("#{number}_zipcode"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!zipcode.check)
						cc.set_spa("err_sw", "ER_#{number}_ZIPCODE")
					end
				end
			end
			cc.set_spa("#{number}_zipcode", zipcode.value)

			address = Address.new(cc.get_input("#{number}_address"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!address.check)
						cc.set_spa("err_sw", "ER_#{number}_ADDRESS")
					end
				end
			end
			cc.set_spa("#{number}_address", address.value)

			birthday = Birthday.new(cc.get_input("#{number}_birthday"))
			if (cc.get_spa("err_sw") == "")
				if (cc.get_input("ok") != "")
					if (!birthday.check)
						cc.set_spa("err_sw", "ER_#{number}_BIRTHDAY")
					end
				end
			end
			cc.set_spa("#{number}_birthday", birthday.value)

			number += 1
		end

		if (cc.get_spa("err_sw") == "")
			number = 0
			while (number < cc.get_spa("record_number").to_i)
				hash_key = {}
				hash_key["name"] = cc.get_spa("#{number}_old_name")
				hash_key["zipcode"] = cc.get_spa("#{number}_old_zipcode")
				hash_key["address"] = cc.get_spa("#{number}_old_address")
				hash_key["birthday"] = cc.get_spa("#{number}_old_birthday")

				hash_rec = {}
				hash_rec["name"] = cc.get_input("#{number}_name")
				hash_rec["zipcode"] = cc.get_input("#{number}_zipcode")
				hash_rec["address"] = cc.get_input("#{number}_address")
				hash_rec["birthday"] = cc.get_input("#{number}_birthday")

				$csv.update(hash_key, hash_rec)
				number += 1
			end

			$csv.vacuum()
		end
	end

	if (cc.get_spa("err_sw") == "")
		if (cc.get_input("ok") != "")
			cc.set_spa("err_sw", "OK_UPDATE")
		end
		cc.clear_spa()
		return "SAMP_ADDR_TOP"
	else
		cc.set_spa("from_tran", "SAMP_ADDR_UPDATE")
		return "SAMP_ADDR_UPDATE"
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

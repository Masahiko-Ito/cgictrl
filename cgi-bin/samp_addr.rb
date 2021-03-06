# coding: utf-8
#
# サンプルクラス by Masahiko Ito <m-ito@myh.no-ip.org>
#
#======================================================================
# 氏名クラス
#======================================================================
class Name
#----------------------------------------------------------------------
# インスタンス変数
#----------------------------------------------------------------------
	attr_accessor :value
#----------------------------------------------------------------------
# 初期化処理
#----------------------------------------------------------------------
	def initialize(value = "")
		@value = value.to_s.strip
	end
#----------------------------------------------------------------------
# 形式チェック
#----------------------------------------------------------------------
	def check()
		if (@value.to_s.strip == "")
			return false
		end
		return true
	end
#----------------------------------------------------------------------
# 形式チェックして格納
#----------------------------------------------------------------------
	def set(value)
		if (check(value.to_s.strip))
			@value = value.to_s.strip
			return true
		end
		return false
	end
end
#======================================================================
# 郵便番号クラス
#======================================================================
class Zipcode
#----------------------------------------------------------------------
# インスタンス変数
#----------------------------------------------------------------------
	attr_accessor :value
#----------------------------------------------------------------------
# 初期化処理
#----------------------------------------------------------------------
	def initialize(value = "")
		@value = value.to_s.strip
	end
#----------------------------------------------------------------------
# 形式チェック
#----------------------------------------------------------------------
	def check()
		if (/^[0-9]{3}$/ =~ @value.to_s.strip ||
			/^[0-9]{3}-[0-9]{4}$/ =~ @value.to_s.strip)
			# do nothing
		else
			return false
		end
		return true
	end
#----------------------------------------------------------------------
# 形式チェックして格納
#----------------------------------------------------------------------
	def set(value)
		if (check(value.to_s.strip))
			@value = value.to_s.strip
			return true
		end
		return false
	end
end
#======================================================================
# 住所クラス
#======================================================================
class Address
#----------------------------------------------------------------------
# インスタンス変数
#----------------------------------------------------------------------
	attr_accessor :value
#----------------------------------------------------------------------
# 初期化処理
#----------------------------------------------------------------------
	def initialize(value = "")
		@value = value.to_s.strip
	end
#----------------------------------------------------------------------
# 形式チェック
#----------------------------------------------------------------------
	def check()
		if (@value.to_s.strip == "")
			return false
		end
		return true
	end
#----------------------------------------------------------------------
# 形式チェックして格納
#----------------------------------------------------------------------
	def set(value)
		if (check(value.to_s.strip))
			@value = value.to_s.strip
			return true
		end
		return false
	end
end
#======================================================================
# 誕生日クラス
#======================================================================
class Birthday
#----------------------------------------------------------------------
# インスタンス変数
#----------------------------------------------------------------------
	attr_accessor :value
#----------------------------------------------------------------------
# 初期化処理
#----------------------------------------------------------------------
	def initialize(value = "")
		@value = value
	end
#----------------------------------------------------------------------
# 形式チェック
#----------------------------------------------------------------------
	def check()
		if (/^[12][0-9]{3}[01][0-9][0-3][0-9]$/ =~ @value.to_s.strip)
			# do nothing
		else
			return false
		end
		return true
	end
#----------------------------------------------------------------------
# 形式チェックして格納
#----------------------------------------------------------------------
	def set(value)
		if (check(value.to_s.strip))
			@value = value.to_s.strip
			return true
		end
		return false
	end
#----------------------------------------------------------------------
# 年取得
#----------------------------------------------------------------------
	def year()
		return @value.to_s.strip[0, 4]
	end
#----------------------------------------------------------------------
# 月取得
#----------------------------------------------------------------------
	def month()
		return @value.to_s.strip[4, 2]
	end
#----------------------------------------------------------------------
# 日取得
#----------------------------------------------------------------------
	def day()
		return @value.to_s.strip[6, 2]
	end
end

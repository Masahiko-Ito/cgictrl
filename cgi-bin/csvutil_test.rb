#! /usr/bin/ruby
require "csvutil"

csv = Csvutil.new("test.csv")

csv.create({"key1" => "value1", "key2" => "value1", "key3" => "value1"})
csv.create({"key1" => "value2", "key2" => "value2", "key3" => "value2"})
csv.create({"key1" => "value3", "key2" => "value3", "key3" => "value3"})
csv.create({"key1" => "value3", "key2" => "value3", "key3" => "value3"})
csv.create({"key1" => "value4", "key2" => "value4", "key3" => "value4"})
csv.create({"key1" => "value5", "key2" => "value5", "key3" => "value5"})
csv.create({"key1" => "value6", "key2" => "value6", "key3" => "value6"})
csv.create({"key1" => "value6", "key2" => "value6", "key3" => "value6"})
csv.create({"key1" => "value7", "key2" => "value7", "key3" => "value7"})
csv.create({"key1" => "value8", "key2" => "value8", "key3" => "value8"})
csv.create({"key1" => "value9", "key2" => "value9", "key3" => "value9"})
csv.create({"key1" => "value9", "key2" => "value9", "key3" => "value9"})

csv.delete({"key2" => "value[35]", "key3" => "value[35]"})

csv.update({"key1" => "value[467]"}, {"key2" => "VALUE467", "key3" => "VALUE467"})
#csv.update({"key1" => ".*"}, {"key1" => "value1", "key2" => "value1", "key3" => "value1"})

#csv.read_each({"key1" => "^value"}, 5, 5, false) {|hash_rec|
#	p hash_rec
#}

#get_array = csv.read_array({"key1" => "^value"}, 5, 5, false)
#get_array.each {|hash_rec|
#	p hash_rec
#}

csv.read_ge_each({"key1" => "value1", "key3" => "value2"}, 1, -1, true, false) {|hash_rec|
	p hash_rec
}

csv.vacuum()

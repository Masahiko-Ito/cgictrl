#! /usr/bin/ruby
require "cgi";
while (gets) do
        print CGI.unescape($_);
end

#! /usr/bin/ruby -I.
require "cgi";
while (gets) do
        print CGI.unescape($_);
end

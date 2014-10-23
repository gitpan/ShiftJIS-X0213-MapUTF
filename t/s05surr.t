
BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);

use strict;
$^W = 1;
our $loaded = 1;
print "ok 1\n";

sub hexNCR { sprintf "&#x%x;", shift }

# unicode_to_sjis2003() is not tested.

#####

print "\x00" eq utf16le_to_sjis2003("\x00\xDB\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf16be_to_sjis2003("\xDB\x00\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf32le_to_sjis2003("\x00\xDB\0\0\x00\x00\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf32be_to_sjis2003("\xDB\x00\0\0\x00\x00\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf8_to_sjis2003("\xED\xAC\x80\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

print "&#xdb00;\x00" eq utf16le_to_sjis2003(\&hexNCR, "\x00\xDB\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#xdb00;\x00" eq utf16be_to_sjis2003(\&hexNCR, "\xDB\x00\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#xdb00;\x00" eq utf32le_to_sjis2003(\&hexNCR, "\x00\xDB\0\0\0\0\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#xdb00;\x00" eq utf32be_to_sjis2003(\&hexNCR, "\0\0\xDB\x00\0\0\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#xdb00;\x00" eq utf8_to_sjis2003(\&hexNCR, "\xED\xAC\x80\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

print "\x00" eq utf16le_to_sjis2003(sub {""}, "\x00\xDB\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf16be_to_sjis2003(sub {""}, "\xDB\x00\x00\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf32le_to_sjis2003(sub {""}, "\x00\xDB\0\0\x00\x00\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf32be_to_sjis2003(sub {""}, "\xDB\x00\0\0\x00\x00\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x00" eq utf8_to_sjis2003(sub {""}, "\xED\xAC\x80\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";


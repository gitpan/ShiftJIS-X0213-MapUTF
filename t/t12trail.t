
BEGIN { $| = 1; print "1..265\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);

use strict;
$^W = 1;
our $loaded = 1;
print "ok 1\n";

sub h_fb {
    my ($char, $byte) = @_;
    defined $char
	? sprintf("&#x%s;", uc unpack 'H*', $char)
	: sprintf("[%02X]", $byte);
}

#####

our @arys = (
    [ "\x82\xFC", "&#x82FC;" ], #  2.. 13
    [ "\x84\xDD", "&#x84DD;" ], # 14.. 25
    [ "\x86\xF2", "&#x86F2;" ], # 26.. 37
    [ "\x87\x77", "&#x8777;" ], # 38.. 49
    [ "\x88\x9E", "&#x889E;" ], # 50.. 61
    [ "\x98\x73", "&#x9873;" ], # 62.. 73
    [ "\x98\x9E", "&#x989E;" ], # 74.. 85
    [ "\x80", "[80]" ], 	# 86.. 97
    [ "\x87\x9F", "&#x879F;" ], # 98..109
    [ "\x82", "[82]" ], 	#110..121
    [ "\xEA\xA5", "&#xEAA5;" ], #122..133
    [ "\xEF\xF8", "&#xEFF8;" ],	#134..145
    [ "\xEF\xF9", "&#xEFF9;" ], #146..157
    [ "\x9F", "[9F]" ], 	#158..169
    [ "\xA0", "[A0]" ], 	#170..181
    [ "\xE0", "[E0]" ], 	#182..193
    [ "\xFC", "[FC]" ], 	#194..205
    [ "\xEF\xFA", "&#xEFFA;" ],	#206..217
    [ "\xEF\xFB", "&#xEFFB;" ], #218..229
    [ "\xEF\xFC", "&#xEFFC;" ]	#230..241
);

foreach my $ary (@arys) {
    our $str = $ary->[0];
    our $ret = $ary->[1];

    print sjis0213_to_utf16be($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf16le($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf32be($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf32le($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf8   ($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_unicode($str) eq ""
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf16be(\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf16le(\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf32be(\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf32le(\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_utf8   (\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print sjis0213_to_unicode(\&h_fb, $str) eq $ret
	? "ok" : "not ok" , " ", ++$loaded, "\n";
}

##### 242..247

our $string = "\x81\x00";

print sjis0213_to_utf16be(\&h_fb, $string) eq "[81]\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf16le(\&h_fb, $string) eq "[81]\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32be(\&h_fb, $string) eq "[81]\x00\x00\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32le(\&h_fb, $string) eq "[81]\x00\x00\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf8   (\&h_fb, $string) eq "[81]\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_unicode(\&h_fb, $string) eq "[81]\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

##### 248..253

$string = "\x82\x39";

print sjis0213_to_utf16be(\&h_fb, $string) eq "[82]\x00\x39"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf16le(\&h_fb, $string) eq "[82]\x39\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32be(\&h_fb, $string) eq "[82]\x00\x00\x00\x39"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32le(\&h_fb, $string) eq "[82]\x39\x00\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf8   (\&h_fb, $string) eq "[82]\x39"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_unicode(\&h_fb, $string) eq "[82]\x39"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

##### 254..259

$string = "\xF0\x7F";

print sjis0213_to_utf16be(\&h_fb, $string) eq "[F0]\x00\x7F"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf16le(\&h_fb, $string) eq "[F0]\x7F\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32be(\&h_fb, $string) eq "[F0]\x00\x00\x00\x7F"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32le(\&h_fb, $string) eq "[F0]\x7F\x00\x00\x00"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf8   (\&h_fb, $string) eq "[F0]\x7F"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_unicode(\&h_fb, $string) eq "[F0]\x7F"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

##### 260..265

$string = "\xFC\xFF";

print sjis0213_to_utf16be(\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf16le(\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32be(\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf32le(\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_utf8   (\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print sjis0213_to_unicode(\&h_fb, $string) eq "[FC][FF]"
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

1;
__END__

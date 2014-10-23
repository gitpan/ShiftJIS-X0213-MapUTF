
BEGIN { $| = 1; print "1..25\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);
$loaded = 1;
print "ok 1\n";

my $repeat = 1000;

my $hasUnicode = defined &sjis0213_to_unicode;

sub hexNCR {
    my ($char, $byte) = @_;
    return sprintf("&#x%x;", $char) if defined $char;
    die sprintf "illegal byte 0x%02x was found", $byte;
}

#####

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq utf16le_to_sjis0213(\&hexNCR,
	"\x00\xd8\x00\xdc\x61\x00\x62\x00\x63\x00"
	    . "\x08\xD8\x45\xDF\x78\x00\x79\x00\x7a\x00\xff\xdb\xff\xdf")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq utf16be_to_sjis0213(\&hexNCR,
	"\xd8\x00\xdc\x00\x00\x61\x00\x62\x00\x63"
	    . "\xD8\x08\xDF\x45\x00\x78\x00\x79\x00\x7a\xdb\xff\xdf\xff")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq utf32le_to_sjis0213(\&hexNCR,
	    "\x00\x00\x01\x00\x61\0\0\0\x62\0\0\0\x63\0\0\0\x45\x23\x01\x00" .
	    "\x78\0\0\0\x79\0\0\0\x7a\0\0\0\xff\xff\x10\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq utf32be_to_sjis0213(\&hexNCR,
	    "\x00\x01\x00\x00\0\0\0\x61\0\0\0\x62\0\0\0\x63\x00\x01\x23\x45" .
	    "\0\0\0\x78\0\0\0\x79\0\0\0\x7a\x00\x10\xff\xff")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print !$hasUnicode || "&#x10000;abc&#x12345;xyz&#x10ffff;" eq
	unicode_to_sjis0213(\&hexNCR,  pack 'U*', 0x10000, 0x61, 0x62, 0x63,
	    0x12345, 0x78, 0x79, 0x7a, 0x10ffff)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq
	utf8_to_sjis0213(\&hexNCR, "\xF0\x90\x80\x80\x61\x62\x63" .
	    "\xF0\x92\x8D\x85\x78\x79\x7A\xF4\x8F\xBF\xBF")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

print "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	utf16le_to_sjis0213(\&hexNCR, 
	"\xff\x00\xb5\x00\x05\xff\x6B\xD8\xDE\xDC\xB1\x03\xde\xAC" x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	utf16be_to_sjis0213(\&hexNCR,
	"\x00\xff\x00\xb5\xff\x05\xD8\x6B\xDC\xDE\x03\xB1\xAC\xde" x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	utf32le_to_sjis0213(\&hexNCR,
    "\xff\0\0\0\xb5\0\0\0\x05\xff\0\0\xDE\xAC\x02\x00\xB1\x03\0\0\xde\xAC\0\0"
		x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	utf32be_to_sjis0213(\&hexNCR,
    "\0\0\0\xff\0\0\0\xb5\0\0\xff\x05\x00\x02\xAC\xDE\0\0\x03\xB1\0\0\xAC\xde"
		x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	utf8_to_sjis0213(\&hexNCR,
	    "\xC3\xBF\xC2\xB5\xEF\xBC\x85\xF0\xAA\xB3\x9E\xCE\xB1\xEA\xB3\x9E"
		x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print !$hasUnicode
	    || "\x85\x94&#xb5;\x81\x93&#x2acde;\x83\xbf&#xacde;" x $repeat eq
	unicode_to_sjis0213(\&hexNCR,
	    pack('U*', 0xff, 0xb5, 0xff05, 0x2acde, 0x3B1, 0xacde) x $repeat)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

print "ABCD" eq utf16le_to_sjis0213("\x41\x00\x40\xDB\x01\xDC\x42\x00" .
	"\xEA\xDB\xCD\xDF\x43\x00\x00\xD8\x00\xDC\x44\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABCD" eq utf16be_to_sjis0213("\x00\x41\xDB\x40\xDC\x01\x00\x42" .
	"\xDB\xEA\xDF\xCD\x00\x43\xD8\x00\xDC\x00\x00\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABCD" eq utf32le_to_sjis0213("\x41\0\0\0\x01\x00\x0E\x00\x42\0\0\0" .
	"\xCD\xAB\x10\x00\x43\0\0\0\x00\x00\x01\x00\x44\0\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABCD" eq utf32be_to_sjis0213("\0\0\0\x41\x00\x0E\x00\x01\0\0\0\x42" .
	"\x00\x10\xAB\xCD\0\0\0\x43\x00\x01\x00\x00\0\0\0\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABCD" eq utf8_to_sjis0213(
	"\x41\xF3\xA0\x80\x81\x42\xF4\x8A\xAF\x8D\x43\xF0\x90\x80\x80\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print !$hasUnicode || "ABCD" eq unicode_to_sjis0213(
	"A".chr(0xE0001)."B".chr(0x10ABCD)."C".chr(0x10000)."D")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

print "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	utf16le_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "\x41\x00\x40\xDB\x01\xDC\x42\x00\xEA\xDB\xCD\xDF" .
	    "\x43\x00\x00\xD8\x00\xDC\x44\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	utf16be_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "\x00\x41\xDB\x40\xDC\x01\x00\x42\xDB\xEA\xDF\xCD" .
	    "\x00\x43\xD8\x00\xDC\x00\x00\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	utf32le_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "\x41\0\0\0\x01\x00\x0E\x00\x42\0\0\0\xCD\xAB\x10\x00" .
	    "\x43\0\0\0\x00\x00\x01\x00\x44\0\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	utf32be_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "\0\0\0\x41\x00\x0E\x00\x01\0\0\0\x42\x00\x10\xAB\xCD" .
	    "\0\0\0\x43\x00\x01\x00\x00\0\0\0\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	utf8_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "\x41\xF3\xA0\x80\x81\x42\xF4\x8A\xAF\x8D\x43\xF0\x90\x80\x80\x44")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print !$hasUnicode || "A&#xE0001;B&#x10ABCD;C&#x10000;D" eq
	unicode_to_sjis0213(sub { sprintf "&#x%04X;", shift },
	    "A".chr(0xE0001)."B".chr(0x10ABCD)."C".chr(0x10000)."D")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";



BEGIN { $| = 1; print "1..31\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);
use ShiftJIS::X0213::MapUTF::Supplements;

my $hasUnicode = defined &sjis0213_to_unicode;

$loaded = 1;
print "ok 1\n";

my $uniStr = $hasUnicode ? "ABC".pack('U*', 0xB5, 0x3042) : "";

print !$hasUnicode || "ABC\x82\xA0" eq unicode_to_sjis0213($uniStr)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print !$hasUnicode || "ABC\x83\xCA\x82\xA0" eq
	unicode_to_sjis0213(\&to_sjis0213_supplements, $uniStr)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x82\xA0" eq utf8_to_sjis0213("ABC\xC2\xB5\xE3\x81\x82")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq
	utf8_to_sjis0213(\&to_sjis0213_supplements, "ABC\xC2\xb5\xE3\x81\x82")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x82\xA0" eq utf16le_to_sjis0213("A\0B\0C\0\xb5\0\x42\x30")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf16le_to_sjis0213(
	\&to_sjis0213_supplements, "A\0B\0C\0\xb5\0\x42\x30")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf16le_to_sjis0213(
	\&to_sjis0213_supplements, "A\0B\0C\0\xb5\0\x42\x30\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x82\xA0" eq utf16be_to_sjis0213("\0A\0B\0C\0\xb5\x30\x42")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf16be_to_sjis0213(
	\&to_sjis0213_supplements, "\0A\0B\0C\0\xb5\x30\x42")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf16be_to_sjis0213(
	\&to_sjis0213_supplements, "\0A\0B\0C\0\xb5\x30\x42\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x82\xA0" eq utf32le_to_sjis0213
	("A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\0\x42\x30\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32le_to_sjis0213(\&to_sjis0213_supplements,
	"A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\0\x42\x30\0\0")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32le_to_sjis0213(\&to_sjis0213_supplements,
	"A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\0\x42\x30\0\0\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32le_to_sjis0213(\&to_sjis0213_supplements,
	"A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\0\x42\x30\0\0\x00\x01")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x82\xA0" eq utf32be_to_sjis0213(
	"\0\0\0A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\x30\x42")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32be_to_sjis0213(\&to_sjis0213_supplements,
	"\0\0\0A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\x30\x42")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32be_to_sjis0213(\&to_sjis0213_supplements,
	"\0\0\0A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\x30\x42\x00")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print "ABC\x83\xCA\x82\xA0" eq utf32be_to_sjis0213(\&to_sjis0213_supplements,
	"\0\0\0A\0\0\0B\0\0\0C\0\0\0\xb5\0\0\x30\x42\x00\x01")
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

#####

my $unicode = "ABC".pack('U*', 0x2985, 0x2986, 0x9B1C, 0x3042);
my $utf8    = "ABC\xe2\xa6\x85\xe2\xa6\x86\xe9\xac\x9c\xe3\x81\x82";
my $utf16le = "A\00B\00C\00\x85\x29\x86\x29\x1C\x9B\x42\x30";
my $utf16be = "\00A\00B\00C\x29\x85\x29\x86\x9B\x1C\x30\x42";
my $utf32le = pack 'V*', unpack 'v*', $utf16le;
my $utf32be = pack 'N*', unpack 'n*', $utf16be;
my $sjis    = "ABC\x82\xA0";
my $sjisFB  = "ABC\x81\xD4\x81\xD5\xFC\x5A\x82\xA0";

print $sjis eq unicode_to_sjis0213($unicode)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjis eq utf8_to_sjis0213($utf8)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjis eq utf16le_to_sjis0213($utf16le)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjis eq utf16be_to_sjis0213($utf16be)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjis eq utf32le_to_sjis0213($utf32le)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjis eq utf32be_to_sjis0213($utf32be)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq unicode_to_sjis0213(\&to_sjis0213_supplements, $unicode)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq utf8_to_sjis0213(\&to_sjis0213_supplements, $utf8)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq utf16le_to_sjis0213(\&to_sjis0213_supplements, $utf16le)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq utf16be_to_sjis0213(\&to_sjis0213_supplements, $utf16be)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq utf32le_to_sjis0213(\&to_sjis0213_supplements, $utf32le)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";

print $sjisFB eq utf32be_to_sjis0213(\&to_sjis0213_supplements, $utf32be)
    ? "ok" : "not ok" , " ", ++$loaded, "\n";


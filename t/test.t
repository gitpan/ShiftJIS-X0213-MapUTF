# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..27\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF;
$loaded = 1;
print "ok 1\n";

my $repeat = 1000;

######################### End of black magic.

print 1
  && "" eq sjis0213_to_utf16le("")
  && "A\x00B\x00C\x00"		eq sjis0213_to_utf16le("ABC")
  && "A\x00B\x00C\x00\n\x00"	eq sjis0213_to_utf16le("ABC\n")
  && "" eq sjis0213_to_utf16be("")
  && "\x00A\x00B\x00C"		eq sjis0213_to_utf16be("ABC")
  && "\x00A\x00B\x00C\x00\n"	eq sjis0213_to_utf16be("ABC\n")
  ? "ok" : "not ok", " 2\n";

print 1
   && "" eq utf16be_to_sjis0213("")
   && "\n\n" eq utf16be_to_sjis0213("\x00\n\x00\n")
   && "\x82\xa0\x82\xa2\x82\xa4\x81\xe0\x82\xa6\x82\xa8"
	eq utf16be_to_sjis0213
	("\xfe\xff\x30\x42\x30\x44\x30\x46\x22\x52\x30\x48\x30\x4a")
   && "" eq utf16le_to_sjis0213("") 
   && "\n\n" eq utf16le_to_sjis0213("\n\x00\n\x00")
   && "\x82\xa0\x82\xa2\x82\xa4\x81\xe0\x82\xa6\x82\xa8"
	eq utf16le_to_sjis0213
	("\xff\xfe\x42\x30\x44\x30\x46\x30\x52\x22\x48\x30\x4a\x30")
  ? "ok" : "not ok", " 3\n";

print 1
  && "\x42\x30\x44\x30\x46\x30\x48\x30\x4a\x30" eq
     sjis0213_to_utf16le("\x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8")
  && "\x30\x42\x30\x44\x30\x46\x30\x48\x30\x4a" eq
     sjis0213_to_utf16be("\x82\xa0\x82\xa2\x82\xa4\x82\xa6\x82\xa8")
  ? "ok" : "not ok", " 4\n";

my $uni
    = pack('U*', 0x6f22, 0x5b57) . "\n"
    . pack('U*', 0x0050, 0x0065, 0x0072, 0x006c, 0x2252) . "\n"
    . pack('U*', 0xFF8C, 0xFF9F, 0xFF9B, 0xFF78, 0xFF9E)
    . pack('U*', 0xFF97, 0xFF90, 0xFF9D, 0xFF78, 0xFF9E) . "\n";

my $sjis0213 = "\x8a\xbf\x8e\x9a\n\x50\x65\x72\x6c\x81\xe0\n"
    . "\xcc\xdf\xdb\xb8\xde\xd7\xd0\xdd\xb8\xde\n";

print ""	eq unicode_to_sjis0213("")
  && "\n\n"	eq unicode_to_sjis0213("\n\n")
  && $sjis0213	eq unicode_to_sjis0213($uni)
  && "$sjis0213\n" eq unicode_to_sjis0213("$uni\n")
  ? "ok" : "not ok", " 5\n";

print ""	eq sjis0213_to_unicode("")
  && "\n\n"	eq sjis0213_to_unicode("\n\n")
  && $uni	eq sjis0213_to_unicode($sjis0213)
  && "$uni\n"	eq sjis0213_to_unicode("$sjis0213\n")
  ? "ok" : "not ok", " 6\n";

my $vu_sjis = "abc\x82\xf2pqr\x82\xf2xyz";
my $vu_uni  = "abc".pack('U', 0x3094)."pqr".pack('U', 0x3094)."xyz";
my $vu_16l  = "a\x00b\x00c\x00\x94\x30p\x00q\x00r\x00\x94\x30x\x00y\x00z\x00";
my $vu_16b  = "\x00a\x00b\x00c\x30\x94\x00p\x00q\x00r\x30\x94\x00x\x00y\x00z";

print $vu_uni  eq sjis0213_to_unicode($vu_sjis)
   && $vu_16l  eq sjis0213_to_utf16le($vu_sjis)
   && $vu_16b  eq sjis0213_to_utf16be($vu_sjis)
  ? "ok" : "not ok", " 7\n";

print $vu_sjis eq unicode_to_sjis0213($vu_uni)
   && $vu_sjis eq utf16le_to_sjis0213($vu_16l)
   && $vu_sjis eq utf16be_to_sjis0213($vu_16b)
  ? "ok" : "not ok", " 8\n";

sub hexNCR { sprintf "&#x%04x;", shift }

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq 
     utf16le_to_sjis0213(\&hexNCR,
        "\x00\xd8\x00\xdc\x61\x00\x62\x00\x63\x00\x08\xD8\x45\xDF"
      . "\x78\x00\x79\x00\x7a\x00\xff\xdb\xff\xdf")
  ? "ok" : "not ok", " 9\n";

print "&#x10000;abc&#x12345;xyz&#x10ffff;" eq 
     utf16be_to_sjis0213(\&hexNCR,
        "\xd8\x00\xdc\x00\x00\x61\x00\x62\x00\x63\xD8\x08\xDF\x45"
      . "\x00\x78\x00\x79\x00\x7a\xdb\xff\xdf\xff")
  ? "ok" : "not ok", " 10\n";

print "\x85\x94\x81\x93\x83\xbf&#xacde;" x $repeat eq
  utf16le_to_sjis0213(\&hexNCR, "\xff\x00\x05\xff\xB1\x03\xde\xAC" x $repeat)
  ? "ok" : "not ok", " 11\n";

print "\x85\x94\x81\x93\x83\xbf&#xacde;" x $repeat eq
  unicode_to_sjis0213(\&hexNCR, "\x{ff}\x{ff05}\x{03B1}\x{acde}" x $repeat)
  ? "ok" : "not ok", " 12\n";

print "\x81\x7E\x00\x81\x80\0\x41" eq unicode_to_sjis0213("\xd7\x00\xf7\0\x41")
  ? "ok" : "not ok", " 13\n";

print "\x{ff71}\x{ff72}\x{ff73}\x{ff74}\x{ff75}" x $repeat eq 
  sjis0213_to_unicode("\xb1\xb2\xb3\xb4\xb5" x $repeat)
  ? "ok" : "not ok", " 14\n";

print "\x81\x5F\x81\x5F\x81\x5F\x81\x5F\x81\x5F" x $repeat eq
  unicode_to_sjis0213("\x5c\x5c\x5c\x5c\x5c" x $repeat) # latin 1
  ? "ok" : "not ok", " 15\n";

print "\x85\x94\x81\x93\x83\xbf&#xacde;" x $repeat eq
  unicode_to_sjis0213(\&hexNCR, "\x{ff}\x{ff05}\x{03B1}\x{acde}" x $repeat)
  ? "ok" : "not ok", " 16\n";

print "ABCD" eq unicode_to_sjis0213("A\x{E0001}B\x{10000}C\x{100000}D")
  ? "ok" : "not ok", " 17\n";

print unicode_to_sjis0213(sub { sprintf "&#x%04X;", shift },
    "A\x{E0001}B\x{10ABCD}C\x{10000}D") eq "A&#xE0001;B&#x10ABCD;C&#x10000;D"
  ? "ok" : "not ok", " 18\n";

print "\xFB\x55\x84\x47\xFB\x5C" eq
    unicode_to_sjis0213("\x{28A99}\x{0416}\x{28AE4}")
  &&  "\xFB\x55\x84\x47\xFB\x5C" eq
    utf16be_to_sjis0213("\xD8\x62\xDE\x99\x04\x16\xD8\x62\xDE\xE4")
  &&  "\xFB\x55\x84\x47\xFB\x5C" eq
    utf16le_to_sjis0213("\x62\xD8\x99\xDE\x16\x04\x62\xD8\xE4\xDE")
  ? "ok" : "not ok", " 19\n";

print "\x{28A99}\x{0416}\x{28AE4}" eq
    sjis0213_to_unicode("\xFB\x55\x84\x47\xFB\x5C")
  && "\xD8\x62\xDE\x99\x04\x16\xD8\x62\xDE\xE4" eq
    sjis0213_to_utf16be("\xFB\x55\x84\x47\xFB\x5C")
  && "\x62\xD8\x99\xDE\x16\x04\x62\xD8\xE4\xDE" eq
    sjis0213_to_utf16le("\xFB\x55\x84\x47\xFB\x5C")
  ? "ok" : "not ok", " 20\n";

# SJIS 1 char <= Unicode 2 chars
print "\x82\xF5\x82\xA9" eq unicode_to_sjis0213("\x{304B}\x{309A}\x{304B}")
  ? "ok" : "not ok", " 21\n";

print "\x82\xF5\x82\xA9" eq utf16be_to_sjis0213("\x30\x4B\x30\x9A\x30\x4B")
  ? "ok" : "not ok", " 22\n";

print "\x82\xF5\x82\xA9" eq utf16le_to_sjis0213("\x4B\x30\x9A\x30\x4B\x30")
  ? "ok" : "not ok", " 23\n";

print "\x41\x86\x85\x41\x86\x86\x41\x86\x84" eq unicode_to_sjis0213(
	"\x41\x{02E9}\x{02E5}\x41\x{02E5}\x{02E9}\x41\x{02E9}")
  ? "ok" : "not ok", " 24\n";

print "\x41\x86\x85\x41\x86\x86\x41\x86\x84" eq utf16be_to_sjis0213(
	"\x00\x41\x02\xE9\x02\xE5\x00\x41\x02\xE5\x02\xE9\x00\x41\x02\xE9")
  ? "ok" : "not ok", " 25\n";

print "\x41\x86\x85\x41\x86\x86\x41\x86\x84" eq utf16le_to_sjis0213(
	"\x41\x00\xE9\x02\xE5\x02\x41\x00\xE5\x02\xE9\x02\x41\x00\xE9\x02")
  ? "ok" : "not ok", " 26\n";

print "\x86\x63\x86\x63" x $repeat eq unicode_to_sjis0213(
    sjis0213_to_unicode("\x85\x7B\x86\x7B\x86\x63" x $repeat))
  ? "ok" : "not ok", " 27\n";

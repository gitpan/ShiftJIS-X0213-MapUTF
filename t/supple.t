# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF;
use ShiftJIS::X0213::MapUTF::Supplements;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $unicode = "ABC\x{2985}\x{2986}\x{9B1C}\x{3042}";
my $utf16be = "\00A\00B\00C\x29\x85\x29\x86\x9B\x1C\x30\x42";
my $utf16le = "A\00B\00C\00\x85\x29\x86\x29\x1C\x9B\x42\x30";
my $sjis    = "ABC\x82\xA0";
my $sjisFB  = "ABC\x81\xD4\x81\xD5\xFC\x5A\x82\xA0";

print $sjis eq unicode_to_sjis0213($unicode)
  ? "ok" : "not ok", " 2\n";

print $sjis eq utf16be_to_sjis0213($utf16be)
  ? "ok" : "not ok", " 3\n";

print $sjis eq utf16le_to_sjis0213($utf16le)
  ? "ok" : "not ok", " 4\n";

print $sjisFB eq unicode_to_sjis0213(\&to_sjis0213_supplements, $unicode)
  ? "ok" : "not ok", " 5\n";

print $sjisFB eq utf16be_to_sjis0213(\&to_sjis0213_supplements, $utf16be)
  ? "ok" : "not ok", " 6\n";

print $sjisFB eq utf16le_to_sjis0213(\&to_sjis0213_supplements, $utf16le)
  ? "ok" : "not ok", " 7\n";



BEGIN { $| = 1; print "1..121\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);
$loaded = 1;
print "ok 1\n";

my $hasUnicode = defined &sjis0213_to_unicode;

my @arys = (
  [ "",   "",   "" ],
  [ "\n\n\0\n", "\n\n\0\n", "n:n:0:n" ],
  [ "ABC\0\0\0", "\x41\x42\x43\0\0\0", "41:42:43:0:0:0" ],
  [ "ABC\n\n", "\x41\x42\x43\n\n", "41:42:43:n:n" ],
  [
    "\x82\xa0\x82\xa2\x82\xa4\x81\xe0\x82\xa6\x82\xa8",
    "\xE3\x81\x82\xE3\x81\x84\xE3\x81\x86\xE2\x89\x92\xE3\x81\x88\xE3\x81\x8A",
    "3042:3044:3046:2252:3048:304a",
  ],
  [
    "\x8a\xbf\x8e\x9a\n\x00\x41\xdf\x81\x40\x88\x9F",
    "\xE6\xBC\xA2\xE5\xAD\x97\n\0\x41\xEF\xBE\x9F\xE3\x80\x80\xE4\xBA\x9C",
    "6f22:5b57:n:0:41:FF9F:3000:4E9C",
  ],
  [
    "abc\x82\xf2pqr\x82\xf2xyz",
    "abc\xE3\x82\x94pqr\xE3\x82\x94xyz",
    "61:62:63:3094:70:71:72:3094:78:79:7a",
  ],
  [
    "\xFB\x55\x84\x47\xFB\x5C",
    "\xf0\xa8\xaa\x99\xd0\x96\xf0\xa8\xab\xa4",
    "28A99:416:28AE4",
  ],
  [
    "\x82\xF5\x82\xA9",
    "\xe3\x81\x8b\xe3\x82\x9a\xe3\x81\x8b",
    "304B:309A:304B",
  ],
  [
    "\x41\x86\x85\x41\x86\x86\x41\x86\x84",
    "\x41\xcb\xa9\xcb\xa5\x41\xcb\xa5\xcb\xa9\x41\xcb\xa9",
    "41:02E9:02E5:41:02E5:02E9:41:02E9",
  ],
);

sub uv_to_utf16 {
    my $u = shift;
    return $u if $u <= 0xFFFF;
    return    if $u > 0x10FFFF;
    $u -= 0x10000;
    my $hi = ($u >> 10) + 0xD800;
    my $lo = ($u & 0x3FF) + 0xDC00;
    return $hi, $lo;
}

my $ary;
for $ary (@arys) {
    my $sjis0213   = $ary->[0];
    my $sjis0213re = defined $ary->[3] ? $ary->[3] : $ary->[0];
    my $utf8    = $ary->[1];
    my @char    = map { $_ eq 'n' ? ord("\n") : hex $_ } split /:/, $ary->[2];
    my $unicode = $hasUnicode ? pack 'U*', @char : "";
    my $utf16le = pack 'v*', map uv_to_utf16($_), @char;
    my $utf16be = pack 'n*', map uv_to_utf16($_), @char;
    my $utf32le = pack 'V*', @char;
    my $utf32be = pack 'N*', @char;

    print !$hasUnicode || $unicode eq sjis0213_to_unicode(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $utf8    eq sjis0213_to_utf8(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $utf16le eq sjis0213_to_utf16le(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $utf16be eq sjis0213_to_utf16be(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $utf32le eq sjis0213_to_utf32le(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $utf32be eq sjis0213_to_utf32be(sub {""}, $sjis0213)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print !$hasUnicode || $sjis0213re eq
	    unicode_to_sjis0213(sub {""}, $unicode)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $sjis0213re eq utf8_to_sjis0213(sub {""}, $utf8)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $sjis0213re eq utf16le_to_sjis0213(sub {""}, $utf16le)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $sjis0213re eq utf16be_to_sjis0213(sub {""}, $utf16be)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $sjis0213re eq utf32le_to_sjis0213(sub {""}, $utf32le)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $sjis0213re eq utf32be_to_sjis0213(sub {""}, $utf32be)
	? "ok" : "not ok" , " ", ++$loaded, "\n";
}


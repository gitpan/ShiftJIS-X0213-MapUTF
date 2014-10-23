
BEGIN { $| = 1; print "1..6\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::X0213::MapUTF qw(:all);
$loaded = 1;
print "ok 1\n";

my $hasUnicode = defined &sjis0213_to_unicode;

sub hexNCR {
    my ($char, $byte) = @_;
    return sprintf("&#x%x;", $char) if defined $char;
    die sprintf "illegal byte 0x%02x was found", $byte;
}

#####

{
    my @hangul = 0xAC00..0xD7AF;
    my $h_u16l = pack 'v*', @hangul;
    my $h_u16b = pack 'n*', @hangul;
    my $h_u32l = pack 'V*', @hangul;
    my $h_u32b = pack 'N*', @hangul;
    my $h_uni  = $hasUnicode ? pack 'U*', @hangul : "";
    my $h_ncr  = join '', map sprintf("&#x%x;", $_), @hangul;

    print $h_ncr eq utf16le_to_sjis0213(\&hexNCR, $h_u16l)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $h_ncr eq utf16be_to_sjis0213(\&hexNCR, $h_u16b)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $h_ncr eq utf32le_to_sjis0213(\&hexNCR, $h_u32l)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print $h_ncr eq utf32be_to_sjis0213(\&hexNCR, $h_u32b)
	? "ok" : "not ok" , " ", ++$loaded, "\n";

    print !$hasUnicode || $h_ncr eq unicode_to_sjis0213(\&hexNCR, $h_uni)
	? "ok" : "not ok" , " ", ++$loaded, "\n";
}

package ShiftJIS::X0213::MapUTF;

require 5.006;

use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw(
    sjis0213_to_unicode  unicode_to_sjis0213
    sjis0213_to_utf8     utf8_to_sjis0213
    sjis0213_to_utf16le  utf16le_to_sjis0213
    sjis0213_to_utf16be  utf16be_to_sjis0213
);

%EXPORT_TAGS = (
    'unicode'  => [ 'sjis0213_to_unicode', 'unicode_to_sjis0213' ],
    'utf8'     => [ 'sjis0213_to_utf8',    'utf8_to_sjis0213'    ],
    'utf16le'  => [ 'sjis0213_to_utf16le', 'utf16le_to_sjis0213' ],
    'utf16be'  => [ 'sjis0213_to_utf16be', 'utf16be_to_sjis0213' ],
    'utf32le'  => [ 'sjis0213_to_utf32le', 'utf32le_to_sjis0213' ],
    'utf32be'  => [ 'sjis0213_to_utf32be', 'utf32be_to_sjis0213' ],
);

@EXPORT_OK = map @$_, values %EXPORT_TAGS;
$EXPORT_TAGS{all}  = [ @EXPORT_OK ];

$VERSION = '0.11';

$PACKAGE = 'ShiftJIS::X0213::MapUTF'; # __PACKAGE__

bootstrap ShiftJIS::X0213::MapUTF $VERSION;

1;
__END__

=head1 NAME

ShiftJIS::X0213::MapUTF - conversion between Shift_JISX0213 and Unicode

=head1 SYNOPSIS

    use ShiftJIS::X0213::MapUTF;

    $utf16be_string  = sjis0213_to_utf16be($sjis0213_string);
    $sjis0213_string = utf16be_to_sjis0213($utf16be_string);

=head1 DESCRIPTION

This module provides some functions to map
from Shift_JISX0213 to Unicode, and vice versa.

=head2 Functions to transcode Shift_JISX0213 to Unicode

If a coderef C<SJIS_CALLBACK> is not specified,
characters unmapped to Unicode are deleted;
otherwise, a string returned from C<SJIS_CALLBACK> is inserted there.
The argument for B<SJIS_CALLBACK> is a Shift_JISX0213 string like
C<"\x80">, C<"\xfc\xfc">, C<"\xff">
(that may be a byte that is illegal or a partial charcter).

The return value of B<SJIS_CALLBACK> must be legal in the target format.
E.g. it must be silly to use with sjis0213_to_utf16be()
a callback that returns UTF-8.
I.e. you should prepare a callback coderef for each encoding.

=over 4

=item C<sjis0213_to_utf8(STRING)>

=item C<sjis0213_to_utf8(SJIS_CALLBACK, STRING)>

Converts Shift_JISX0213 to UTF-8

=item C<sjis0213_to_unicode(STRING)>

=item C<sjis0213_to_unicode(SJIS_CALLBACK, STRING)>

Converts Shift_JISX0213 to Unicode
(Perl's internal format (see perlunicode), flagged).

=item C<sjis0213_to_utf16le([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-16LE.

=item C<sjis0213_to_utf16be([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-16BE.

=item C<sjis0213_to_utf32le([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-32LE.

=item C<sjis0213_to_utf32be([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-32BE.

=back

=head2 Functions to transcode Shift_JISX0213 from Unicode

If the C<UNICODE_CALLBACK> coderef is not specified,
illegal bytes are skipped by one byte,
and characters unmapped to Shift_JISX0213 are deleted;
otherwise, a string returned from C<UNICODE_CALLBACK> is inserted there.

The 1st argument for B<UNICODE_CALLBACK> is its Unicode codepoint (integer),
or B<undef> when encounters an illegal byte.

If the 1st argument is B<undef>, integer in byte is passed as the 2nd argument.
 
For example, characters unmapped to Shift_JISX0213 are
converted to numerical character references for HTML 4.01.

    sub toHexNCR {
        my ($char, $byte) = @_;
        return sprintf("&#x%x;", $char) if defined $char;
        die sprintf "illegal byte 0x%02x was found", $byte;
    }

    $sjis0213 = utf8_to_sjis0213(\&toHexNCR, $utf8_string);
    $sjis0213 = unicode_to_sjis0213(\&toHexNCR, $unicode_string);
    $sjis0213 = utf16le_to_sjis0213(\&toHexNCR, $utf16le_string);

=over 4

=item C<utf8_to_sjis0213(STRING)>

=item C<utf8_to_sjis0213(UNICODE_CALLBACK, STRING)>

Converts UTF-8 to Shift_JISX0213.

=item C<unicode_to_sjis0213(STRING)>

=item C<unicode_to_sjis0213(UNICODE_CALLBACK, STRING)>

Converts Unicode to Shift_JISX0213.

This B<Unicode> is in the Perl's internal format (see perlunicode).
If not flagged with C<SVf_UTF8>, upgraded as an ISO 8859-1 string).

=item C<utf16le_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-16LE to Shift_JISX0213.

=item C<utf16be_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-16BE to Shift_JISX0213.

=item C<utf32le_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-32LE to Shift_JISX0213.

=item C<utf32be_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-32BE to Shift_JISX0213.

=back

=head2 Export

B<By default:>

    sjis0213_to_utf8     utf8_to_sjis0213
    sjis0213_to_utf16le  utf16le_to_sjis0213
    sjis0213_to_utf16be  utf16be_to_sjis0213
    sjis0213_to_unicode  unicode_to_sjis0213

B<On request:>

    sjis0213_to_utf32le  utf32le_to_sjis0213
    sjis0213_to_utf32be  utf32be_to_sjis0213

=head1 BUGS

On mapping between Shift_JISX0213 and Unicode used in this module,
notice that:

=over 4

=item *

If an authentic mapping would have been published,
the mapping by this module will be corrected according to that mapping.

=item *

0xFC5A in Shift_JISX0213 is mapped to U+9B1D according to JIS X 0213:2000,
while Unicode's Unihan.txt maps it to U+9B1C.

=item *

0x81D4 and 0x81D5 in Shift_JISX0213 is mapped in the block
of C<Halfwidth and Fullwidth Forms>,
not in the block of C<Miscellaneous Mathematical Symbols-B>,
according to Shibano's JIS KANJI JITEN, published in June, 2002.

=item *

The following 25 JIS Non-Kanji characters are not included in Unicode 3.2.0.
So they are mapped to each 2 characters in Unicode.
These mappings are done round-trippedly for *one Shift_JISX0213 character*.
Then round-trippedness for a Shift_JISX0213 *string* is broken.
(E.g. Shift_JISX0213 <0x8663> and <0x857B, 0x867B> both are mapped
to <U+00E6, U+0300>; but <U+00E6, U+0300> is mapped only to SJIS <0x8663>.)

    SJIS0213  Unicode 3.2.0    # Name by JIS X 0213:2000

    0x82F5    <U+304B, U+309A> # [HIRAGANA LETTER BIDAKUON NGA]
    0x82F6    <U+304D, U+309A> # [HIRAGANA LETTER BIDAKUON NGI]
    0x82F7    <U+304F, U+309A> # [HIRAGANA LETTER BIDAKUON NGU]
    0x82F8    <U+3051, U+309A> # [HIRAGANA LETTER BIDAKUON NGE]
    0x82F9    <U+3053, U+309A> # [HIRAGANA LETTER BIDAKUON NGO]
    0x8397    <U+30AB, U+309A> # [KATAKANA LETTER BIDAKUON NGA]
    0x8398    <U+30AD, U+309A> # [KATAKANA LETTER BIDAKUON NGI]
    0x8399    <U+30AF, U+309A> # [KATAKANA LETTER BIDAKUON NGU]
    0x839A    <U+30B1, U+309A> # [KATAKANA LETTER BIDAKUON NGE]
    0x839B    <U+30B3, U+309A> # [KATAKANA LETTER BIDAKUON NGO]
    0x839C    <U+30BB, U+309A> # [KATAKANA LETTER AINU CE]
    0x839D    <U+30C4, U+309A> # [KATAKANA LETTER AINU TU(TU)]
    0x839E    <U+30C8, U+309A> # [KATAKANA LETTER AINU TO(TU)]
    0x83F6    <U+31F7, U+309A> # [KATAKANA LETTER AINU P]
    0x8663    <U+00E6, U+0300> # [LATIN SMALL LETTER AE WITH GRAVE]
    0x8667    <U+0254, U+0300> # [LATIN SMALL LETTER OPEN O WITH GRAVE]
    0x8668    <U+0254, U+0301> # [LATIN SMALL LETTER OPEN O WITH ACUTE]
    0x8669    <U+028C, U+0300> # [LATIN SMALL LETTER TURNED V WITH GRAVE]
    0x866A    <U+028C, U+0301> # [LATIN SMALL LETTER TURNED V WITH ACUTE]
    0x866B    <U+0259, U+0300> # [LATIN SMALL LETTER SCHWA WITH GRAVE]
    0x866C    <U+0259, U+0301> # [LATIN SMALL LETTER SCHWA WITH ACUTE]
    0x866D    <U+025A, U+0300> # [LATIN SMALL LETTER HOOKED SCHWA WITH GRAVE]
    0x866E    <U+025A, U+0301> # [LATIN SMALL LETTER HOOKED SCHWA WITH ACUTE]
    0x8685    <U+02E9, U+02E5> # [RISING SYMBOL]
    0x8686    <U+02E5, U+02E9> # [FALLING SYMBOL]

=back

=head1 AUTHOR

Tomoyuki SADAHIRO

  bqw10602@nifty.com
  http://homepage1.nifty.com/nomenclator/perl/

  Copyright(C) 2002-2002, SADAHIRO Tomoyuki. Japan. All rights reserved.

This module is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item JIS X 0213:2000

7-bit and 8-bit double byte coded extended KANJI sets for information interchange (by JIS Committee)

=item JIS KANJI JITEN, the revised edition.

edited by Shibano, published by Japanese Standards Association (JSA), 2002, Tokyo [ISBN4-542-20129-5]

=item L<http://www.jsa.or.jp/>

Japanese Standards Association (access to JIS)

=item L<http://www.unicode.org/Public/UNIDATA/Unihan.txt>

Unihan database (Unicode version: 3.2.0) by Unicode (c).

=item L<http://homepage1.nifty.com/nomenclator/unicode/sjis0213.zip>

A mapping table between Shift_JISX0213 and Unicode 3.2.0.

(This table is prepared by me, and with no authority;
but through the table, you will know what is to be done by this module.)

=item L<ShiftJIS::CP932::MapUTF>

conversion between Microsoft Windows CP-932 and Unicode

(The CP932-Unicode mapping is different
with the Shift_JISX0213-Unicode mapping,
but what you desire may be the former.)

=back

=cut

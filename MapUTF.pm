package ShiftJIS::X0213::MapUTF;

require 5.006;

use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

$VERSION = '0.12';
$PACKAGE = 'ShiftJIS::X0213::MapUTF'; # __PACKAGE__

@EXPORT = qw(
    sjis0213_to_unicode  unicode_to_sjis0213
    sjis0213_to_utf8     utf8_to_sjis0213
    sjis0213_to_utf16le  utf16le_to_sjis0213
    sjis0213_to_utf16be  utf16be_to_sjis0213
);

%EXPORT_TAGS = (
    'unicode'  => [ 'sjis0213_to_unicode', 'unicode_to_sjis0213' ],
    'utf8'     => [ 'sjis0213_to_utf8',    'utf8_to_sjis0213'    ],
    'utf16'    => [                        'utf16_to_sjis0213'   ],
    'utf16le'  => [ 'sjis0213_to_utf16le', 'utf16le_to_sjis0213' ],
    'utf16be'  => [ 'sjis0213_to_utf16be', 'utf16be_to_sjis0213' ],
    'utf32'    => [                        'utf32_to_sjis0213'   ],
    'utf32le'  => [ 'sjis0213_to_utf32le', 'utf32le_to_sjis0213' ],
    'utf32be'  => [ 'sjis0213_to_utf32be', 'utf32be_to_sjis0213' ],
);

@EXPORT_OK = map @$_, values %EXPORT_TAGS;
$EXPORT_TAGS{all}  = [ @EXPORT_OK ];

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

=head2 Conversion from Shift_JISX0213 to Unicode

If the first parameter is a reference,
that is used for coping with Shift_JISX0213 characters
unmapped to Unicode, C<SJIS_CALLBACK>.
(any reference will not allowed as C<STRING>.)

If C<SJIS_CALLBACK> is given, C<STRING> is
the second parameter; otherwise the first.

If C<SJIS_CALLBACK> is not specified,
Shift_JISX0213 characters unmapped to Unicode are silently deleted
and illegal bytes are skipped by one byte.
(as if a coderef constantly returning null string, C<sub {''}>,
is passed as C<SJIS_CALLBACK>.)

Currently, only coderefs are allowed as C<SJIS_CALLBACK>.
A string returned from C<SJIS_CALLBACK> is inserted
in place of the unmapped character or the illegal byte.

A coderef as C<SJIS_CALLBACK> is called with one or more arguments.

If illegal byte appears (i.e. a leading byte C<[0x81..0x9F, 0xE0..0xFC]>
without trailing byte (C<[0x40..0x7E, 0x80..0xFC]>), or a reserved byte
(C<[0x80, 0xA0, 0xF0..0xFF]>), the first argument is C<undef>
and the second argument is an unsigned integer representing the byte.

If an unmapped character appears, the first argument is
a defined string representing a character.

Example

    my $sjis_callback = sub {
        my ($char, $byte) = @_;
        return function($char) if defined $char;
        die sprintf "illegal byte 0x%02x", $byte;
    };

In the example above, C<$char> may be C<"\xfc\xfc">, etc.

The return value of C<SJIS_CALLBACK> must be legal in the target format.
E.g. never use with C<sjis0213_to_utf16be()> a callback that returns UTF-8.
I.e. you should prepare C<SJIS_CALLBACK> for each UTF.

=over 4

=item C<sjis0213_to_utf8([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-8

=item C<sjis0213_to_unicode([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to Unicode
(Perl's internal format, flagged with C<SVf_UTF8>,
see F<perlunicode>)

=item C<sjis0213_to_utf16le([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-16LE.

=item C<sjis0213_to_utf16be([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-16BE.

=item C<sjis0213_to_utf32le([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-32LE.

=item C<sjis0213_to_utf32be([SJIS_CALLBACK,] STRING)>

Converts Shift_JISX0213 to UTF-32BE.

=back

=head2 Conversion from Unicode to Shift_JISX0213

If the first parameter is a reference,
that is used for coping with Unicode characters
unmapped to Shift_JISX0213, C<UNICODE_CALLBACK>.
(any reference will not allowed as C<STRING>.)

If C<UNICODE_CALLBACK> is given, C<STRING> is
the second parameter; otherwise the first.

If C<UNICODE_CALLBACK> is not specified,
Shift_JIS characters unmapped to Unicode are silently deleted
and partial bytes are skipped by one byte.
(as if a coderef constantly returning null string, C<sub {''}>
is passed as C<UNICODE_CALLBACK>.)

Currently, only coderefs are allowed as C<UNICODE_CALLBACK>.
A string returned from the coderef is inserted
in place of the unmapped character.

A coderef as C<UNICODE_CALLBACK> is called with one or more arguments.
If the unmapped character is a partial character (an illegal byte),
the first argument is C<undef>
and the second argument is an unsigned integer representing the byte.
If not partial, the first argument is an unsigned interger
representing a Unicode code point.

For example, characters unmapped to Shift_JISX0213 are
converted to numerical character references for HTML 4.01.

    sub toHexNCR {
        my ($char, $byte) = @_;
        return sprintf("&#x%x;", $char) if defined $char;
        die sprintf "illegal byte 0x%02x", $byte;
    }

    $sjis0213 = utf8_to_sjis0213   (\&toHexNCR, $utf8_string);
    $sjis0213 = unicode_to_sjis0213(\&toHexNCR, $unicode_string);
    $sjis0213 = utf16le_to_sjis0213(\&toHexNCR, $utf16le_string);

The return value of C<UNICODE_CALLBACK> must be legal in Shift_JISX0213.

=over 4

=item C<utf8_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-8 to Shift_JISX0213.

=item C<unicode_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts Unicode to Shift_JISX0213.

This B<Unicode> is in the Perl's internal format (see F<perlunicode>).
If C<SVf_UTF8> is not turned on,
C<STRING> is upgraded as an ISO 8859-1 (latin1) string.

=item C<utf16_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-16 (with or w/o C<BOM>) to Shift_JISX0213.

=item C<utf16le_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-16LE to Shift_JISX0213.

=item C<utf16be_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-16BE to Shift_JISX0213.

=item C<utf32_to_sjis0213([UNICODE_CALLBACK,] STRING)>

Converts UTF-32 (with or w/o C<BOM>) to Shift_JISX0213.

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
                         utf16_to_sjis0213 [*]
                         utf32_to_sjis0213 [*]

[*] Their counterparts C<sjis0213_to_utf16()> and C<sjis0213_to_utf32()>
are not implemented yet. They need more investigation
on return values from C<SJIS_CALLBACK>...
(concatenation needs recognition of and coping with C<BOM>)

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

SADAHIRO Tomoyuki <SADAHIRO@cpan.org>

  http://homepage1.nifty.com/nomenclator/perl/

  Copyright(C) 2002-2003, SADAHIRO Tomoyuki. Japan. All rights reserved.

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

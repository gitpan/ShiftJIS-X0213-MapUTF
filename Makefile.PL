use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

require 5.006;

do "mkheader";

WriteMakefile(
    'NAME'		=> 'ShiftJIS::X0213::MapUTF',
    'VERSION_FROM'	=> 'MapUTF.pm',
    'ABSTRACT_FROM'	=> 'MapUTF.pm',
    'AUTHOR'		=> 'SADAHIRO Tomoyuki <SADAHIRO@cpan.org>',
    'clean'		=> {FILES=> 'fmsj0213.h tosj0213.h'},
);

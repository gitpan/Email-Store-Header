use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Email::Store::Header',
    AUTHOR              => 'Chisel Wright <cpan@herlpacker.co.uk>',
    VERSION_FROM        => 'lib/Email/Store/Header.pm',
    ABSTRACT_FROM       => 'lib/Email/Store/Header.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,

        'Email::Store'  => 0,
        'Mail::Header'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Email-Store-Header-*' },
);

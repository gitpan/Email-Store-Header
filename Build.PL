use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Email::Store::Header',
    license             => 'perl',
    dist_author         => 'Chisel Wright <chisel.wright@net-a-porter.com>',
    dist_version_from   => 'lib/Email/Store/Header.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Email-Store-Header-*' ],
);

$builder->create_build_script();

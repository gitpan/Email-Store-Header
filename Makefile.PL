use inc::Module::Install;
use lib 'lib';

name            'Email-Store-Header';
author          'Chisel Wright <cpan@herlpacker.co.uk>';
version         '0.0.4';

all_from        'lib/Email/Store/Header.pm';

requires(
    'Email::Store'      => 0,
    'Mail::Header'      => 0,
    'version'           => 0,
);

build_requires(
    'Test::More'        => 0,
);

WriteAll;

#!usr/bin/env perl
use Test::Perl::Critic;
use Test::More;

# search different places, depending on where we're run from

if ( -f q[./perlcritic.t] ) {
    # we're in the t/ directory
    all_critic_ok(q[..]);
}
elsif ( -f q[t/perlcritic.t] ) {
    # we're in the perl/ directory
    all_critic_ok(q[lib]);
}
else {
    # we're not anywhere sensible ...
    plan skip_all
        => q[perlcritic.t needs to be called from perl/ or perl/t/];
}


package Email::Store::Header;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.4');

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;

use Mail::Header;
use base qw{ Email::Store::DBI };


# Module implementation here
__PACKAGE__->table('header');
__PACKAGE__->columns( All => qw[ id mail header value ] );
__PACKAGE__->has_a(mail => 'Email::Store::Mail');
Email::Store::Mail->has_many(headers => 'Email::Store::Header');

sub on_store {
    my ($class, $mail) = @_;

    my $rfc822      = $mail->message;
    my @lines       = split m{ \n }x, $rfc822;
    my $head        = new Mail::Header \@lines;

    # Remove any header line that, other than the tag, only contains whitespace
    $head->cleanup;

    my @tags        = $head->tags;
    my $head_hash   = $head->header_hashref;

    # loop through all the tags and store them
    foreach my $tag (@tags) {
        # get a list of all instances of $tag in the mail header
        my $tag_value = $head_hash->{ $tag };

        if ('ARRAY' eq ref($tag_value)) {
            # loop through the list
            foreach my $value (@$tag_value) {
                chomp $value;

                $class->_store_header(
                    $mail,
                    $tag,
                    $value,
                );
            }
        }
        else {
            # it's just a scalar
            chomp $tag_value;
            $class->_store_header(
                $mail,
                $tag,
                $tag_value,
            );
        }
    }

    undef $mail->{simple}; # Invalidate cache
    $mail->update;
}

sub on_store_order { 1 };


sub _store_header {
    my ($class, $mail, $header, $value) = @_;

    $class->create(
        {
            mail    =>  $mail->id,
            header  =>  $header,
            value   =>  $value,
        }
    );
}



1; # Magic true value required at end of module

__END__

=head1 NAME

Email::Store::Header - plugin to Email::Store to parse and save message headers


=head1 VERSION

This document describes Email::Store::Header version 0.0.3


=head1 SYNOPSIS

    use Email::Store::Header;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

Sometimes it's useful to parse and store message headers. This is a plugin to
Email::Store to do just that.


=head1 INTERFACE 

=head2 on_store
 
Email::Store extension function to parse and store message headers.
 
=head2 on_store_order

Plugin magic for Email::Store

=head1 DIAGNOSTICS

None listed.

=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Email::Store::Header requires no configuration files or environment variables.


=head1 DEPENDENCIES

=over 4
 
=item Email::Store
 
=item Mail::Header
 
=back

=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-email-store-header@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 SEE ALSO
 
L<Email::Store>, L<Mail::Header>

=head1 AUTHOR

Chisel Wright  C<< <cpan@herlpacker.co.uk> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Chisel Wright C<< <cpan@herlpacker.co.uk> >>.
 
This module was written on time and machinery provided by Net-A-Porter,
http://www.net-a-porter.com/

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

__DATA__
CREATE TABLE IF NOT EXISTS header (
    id INTEGER auto_increment NOT NULL PRIMARY KEY,
    mail text NOT NULL,
    header text NOT NULL,
    value text NOT NULL
);

package Digest::SipHash;

use 5.008001;
use strict;
use warnings;

our $VERSION = sprintf "%d.%02d", q$Revision: 0.2 $ =~ /(\d+)/g;
use base 'Exporter';
our @EXPORT_OK = qw/siphash/;

require XSLoader;
XSLoader::load('Digest::SipHash', $VERSION);

our $DEFAULT_KEY = pack 'C16', map { int(rand(256)) } (0..0xF);

sub siphash {
    my $str = shift;
    my $key = shift || $DEFAULT_KEY;
    use bytes;
    if (length($key) < 16) {
        $key .= substr($DEFAULT_KEY, length($key));
    }
    @{ xs_siphash($str, $key) };
}

1;

=head1 NAME

Digest::SipHash - Perl XS interface to the SipHash algorithm

=head1 VERSION

$Id: SipHash.pm,v 0.2 2013/02/17 08:30:18 dankogai Exp dankogai $

=head1 SYNOPSIS

  use Digest::SipHash qw/siphash/;
  my $key = pack 'C16', 0..0xF; # 16 chars long
  my $str = "hello world!";
  my ($hi, $lo) = siphash($str, $key);
  # $hi == 2209449934 && $lo ==  1373975341;

=head1 DESCRIPTION

SipHash is the default perl hash function for 64 bit builds and
ONE_AT_A_TIME on 32 bit now.

L<https://131002.net/siphash/>

L<http://perl5.git.perl.org/perl.git/commit/3db6cbfca39da94d152d3e860e2aa79b9c6bb161>

This module does only one thing - culculates the SipHash value of the
given string.

=head1 EXPORT

siphash() by option.

=head1 SUBROUTINES/METHODS

=head2 siphash

  my ($hi, $lo) = siphash($str [, $key]);

Calculates the SipHash value of C<$src> with $<$key>.

If C<$key> is omitted, it defaults to C<$Digest:::SipHash::DEFAULT_KEY>
which is set randomly upon initialization of this module.

If C<$key> is set but less than 16 bytes long, it is padded with $DEFAULT_KEY.

To be compatible with 32-bit perl, It returns two 32-bit integers instead of a 64-bit integer.  To restore the original 64-bit value, do

  $whole = ($hi << 32) + $lo

=over 2

=item xs_siphash

which actually does the job.

=item pp_siphash

Pure-Perl implementation -- not yet implemented.

=back

=head1 AUTHOR

Dan Kogai, C<< <dankogai+cpan at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-digest-siphash at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Digest-SipHash>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Digest::SipHash

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Digest-SipHash>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Digest-SipHash>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Digest-SipHash>

=item * Search CPAN

L<http://search.cpan.org/dist/Digest-SipHash/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

=head2 csiphash.c

Copyright (c) 2013  Marek Majkowski

MIT License L<http://opensource.org/licenses/MIT>

L<https://github.com/majek/csiphash>

=head2 The SipHash Algrorithm

Jean-Philippe Aumasson & Daniel J. Bernstein

L<https://131002.net/siphash/>

=head2 The rest of this module

Copyright 2013 Dan Kogai.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of Digest::SipHash

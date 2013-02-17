#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Digest::SipHash qw/siphash/;
plan tests => 1;
#my $hash = 9489515210053333805;
#printf "%d, %d\n", ($hash >> 32), ($hash & 0xffffffff);
my ($hi, $lo) = siphash("hello world!", pack 'C16', 0..0xF);
ok ($hi == 2209449934 && $lo == 1373975341);

#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Config;
use Digest::SipHash qw/siphash/;
plan tests => 2;

my $key = pack 'C16', 0..0xf;
my $str = "hello, world!";
my ($hi, $lo) = siphash($str, $key); # 0x7da9cd17, 0x10cf32e0
ok $hi == 0x7da9cd17 && $lo == 0x10cf32e0, '32-bit pair';
SKIP:{
    skip "64-bit int unsupported", 1 unless $Config{use64bitint};
    my $whole = siphash($str, $key);
    # 0x7da9cd1710cf32e0
    is $whole, 9054994024755049184, '64-bit scalar';
}

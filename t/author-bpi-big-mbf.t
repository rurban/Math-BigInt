#!perl

BEGIN {
    unless ($ENV{AUTHOR_TESTING}) {
        print "1..0 # SKIP these tests are for testing by the author";
        exit;
    }
}

use strict;
use warnings;

use Test::More tests => 9;

use Math::BigFloat lib => "GMP";

$| = 1;

my $pibuf = '3.';

my $file = 't/pi.dat';
my $accu = 1;

my $rmodes = [ 'even', 'odd', '+inf', '-inf', 'zero', 'trunc', 'common' ];

open FILE, $file or die "$file: can't open file for reading: $!";
while (<FILE>) {
    tr/0-9//cd;
    $pibuf .= $_;

    while ($accu < length($pibuf) - 50) {
        for my $rmode (@$rmodes) {

            # reference (exact) value of pi (rounded)
            my $piexp = Math::BigFloat -> new($pibuf) -> bround($accu, $rmode);

            # computed value
            my $pigot = Math::BigFloat -> bpi($accu, undef, $rmode) -> bstr();

            my $test = qq|Math::BigFloat -> bpi($accu, undef, "$rmode")|;
            if ($pigot eq $piexp) {
                }, $test) or do {
                if ($accu > 60) {
                    $piexp = "3.14..." . substr($piexp, $accu - 50);
                    $pigot = "3.14..." . substr($pigot, $accu - 50);
                    diag("  Failed test '$test'\n",
                         "         got: '$pigot'\n",
                         "    expected: '$piexp'\n");
                }
            };
        }

    } continue {
        $accu ++;
    }

}
close FILE or die "$file: can't close file after reading: $!";

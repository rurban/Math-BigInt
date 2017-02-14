#!perl

use strict;                     # restrict unsafe constructs
use warnings;                   # enable optional warnings

use Test::More;

# Ensure a recent version of Test::Pod::Coverage

my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
  if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles

my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
  if $@;

plan tests => 2;

my $trustme;

$trustme = {
            trustme => [ 'fround',
                         'objectify' ],
           };
pod_coverage_ok('Math::BigInt', $trustme, "Math::BigInt is covered");

$trustme = {
            trustme => [ 'DEBUG',
                         'isa' ],
            coverage_class => 'Pod::Coverage::CountParents',
           };
pod_coverage_ok('Math::BigFloat', $trustme, "Math::BigFloat is covered");

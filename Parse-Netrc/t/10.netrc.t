#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;

use Parse::Netrc;

use FindBin '$Bin';
my $netrc = Parse::Netrc->read(file => "$Bin/netrc.1");
isa_ok($netrc, "Parse::Netrc");

my $result = $netrc->parse;

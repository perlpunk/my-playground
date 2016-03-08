#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use YAML::XS;
use JSON::XS;

my $file = "ext/App-Spec-p5/t/appspec-tests.yaml";
my $data = YAML::XS::LoadFile($file);
my $js = JSON::XS->new->pretty;
my $json = $js->encode($data);
open my $fh, ">", "test/appspec-tests.json" or die $!;
print $fh $json;
close $fh;

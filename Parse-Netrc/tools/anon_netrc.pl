#!/usr/bin/env perl
# vim:et:sts=4:sws=4:sw=4
use strict;
use warnings;
use 5.010;

# anonymize .netrc file
# perl $0 < /path/to/.netrc

my %s;
my $i;

while (<>) {
    s/([^"\s#]+)/anon($1)/eg;
    print;
}
sub anon {
    my ($w) = @_;
    return $w if $w =~ m/^(default|machine|macdef|login|account|password)$/;
    my $e = $s{ $w } || "";
    $e = $s{ $w } ||= "word" . ++$i;
}

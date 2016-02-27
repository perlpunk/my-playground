use strict;
use warnings;
package Parse::Netrc::Tree;

use Data::Dumper;

use Pegex::Base;
extends 'Pegex::Tree';

has meta => {};

sub initial {
    my ($self) = @_;
    $self->{data} = {};
}

sub final {
    my ($self) = @_;
    return $self->{data};
}

sub got_macdef_entry {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF\n";
    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
    return $got;
}

sub got_macdef_header {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF header\n";
    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
    return $got;
}

sub got_netrc_machine_entry {
    my ($self, $got) = @_;
    my ($name, @rest) = @$got;
    warn __PACKAGE__.':'.__LINE__.": NETRC machine $name\n";
    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\@rest], ['rest']);
    return @rest;
#    my %res = map { %$_ } @$rest;
#    $res{machine} = $name;
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\%res], ['res']);
#    return \%res;
}

sub got_netrc_default_entry {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": NETRC default\n";
    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
    return $got;
#    my %res = map { %$_ } @$rest;
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\%res], ['res']);
#    return \%res;
}

sub got_netrc_item {
    my ($self, $got) = @_;
    return { @$got }
}

sub got_comment {
    my ($self, $got) = @_;
    return { comment => $got };
}

sub got_quoted_value {
    my ($self, $got) = @_;
    return $got;
}

sub got_netrc_item_comment {
    my ($self, $got) = @_;
    my %res = map { %$_ } @$got;
    return \%res;
}

1;

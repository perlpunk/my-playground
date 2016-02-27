use strict;
use warnings;
package Parse::Netrc::Tree;

use Data::Dumper;

use Pegex::Base;
extends 'Pegex::Tree';

has meta => {};

sub initial {
    my ($self) = @_;
    $self->{data}->{macdefs} = [];
    $self->{data}->{machines} = [];
    $self->{data}->{defaults} = [];
}

sub final {
    my ($self) = @_;
    return $self->{data};
}

sub got_macdef_entry {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF\n";
    my ($header, $rest) = @$got;
    $header ||= {};
    $rest ||= {};
    my %res = (
        %$header,
        %$rest,
    );
    push @{ $self->{data}->{macdefs} }, \%res;
}

sub got_macdef_header {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF header\n";
    my ($name, $comment) = @$got;
    $comment ||= {};
    my %res = (
        name => {
            value => $name,
            %$comment,
        },
    );
    return \%res;
}

sub got_netrc_machine_entry {
    my ($self, $got) = @_;
    return $got;
#    my ($name, @rest) = @$got;
#    warn __PACKAGE__.':'.__LINE__.": NETRC machine $name\n";
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\@rest], ['rest']);
#    return @rest;
#    my %res = map { %$_ } @$rest;
#    $res{machine} = $name;
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\%res], ['res']);
#    return \%res;
}

sub got_netrc_default_entry {
    my ($self, $got) = @_;
#    warn __PACKAGE__.':'.__LINE__.": NETRC default\n";
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$got], ['got']);
    return $got;
#    my %res = map { %$_ } @$rest;
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\%res], ['res']);
#    return \%res;
}

sub got_netrc_item {
    my ($self, $got) = @_;
    return { @$got };
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
    my ($item, $comment) = @$got;
    $comment ||= {};
    my ($key, $value) = %$item;
    my %res = (
        $key => {
            value => $value,
            %$comment,
        },
    );
    return \%res;
}

sub got_macdef_commandline {
    my ($self, $got) = @_;
    return $got;
}

sub got_macdef_commands {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF COMMANDS\n";
    return $got;
}

sub got_macdef_body {
    my ($self, $got) = @_;
    warn __PACKAGE__.':'.__LINE__.": MACDEF BODY \n";
    my ($netrc, $commands) = @$got;
    my %res = (
        netrc => $netrc,
        commands => $commands,
    );
    return \%res;
}

1;

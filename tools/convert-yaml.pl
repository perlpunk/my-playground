#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Data::Dumper;

use FindBin '$Bin';
use lib "$Bin/../../t/lib";
use App::Spec;
use JSON::XS;
use Types::Serialiser;

my $spec = App::Spec->read(shift);
my $class = $spec->class;
$class =~ s/.*:://;
$spec->class($class);
my $structure = structure($spec);
my $js = JSON::XS->new->pretty;
my $json = $js->encode($structure);
say $json;
exit;

my $json_bash = json_bash($spec);
say $json_bash;

sub json_bash {
    my ($self) = @_;
    my $structure = structure($self);
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$structure], ['structure']);
    my @jb = _json_bash($self, $structure, "");
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\@jb], ['jb']);
    my $jb = join "\n", map {
        $_->[0] . "\t" . $_->[1]
    } @jb;
}

sub _json_bash {
    my ($self, $struct) = @_;
    my @result;
    if (ref $struct eq "HASH") {
        for my $key (sort keys %$struct) {
            my $value = $struct->{ $key };
            my @items = _json_bash($self, $value);
            @items = map {
                ["/$key" . $_->[0], $_->[1] ]
            } @items;
            push @result, @items;
        }
    }
    elsif (ref $struct eq "ARRAY") {
        for my $i (0 .. $#$struct) {
            my $item = $struct->[ $i ];
            my @items = _json_bash($self, $item);
            @items = map {
                ["/$i" . $_->[0], $_->[1] ]
            } @items;
            push @result, @items;
        }
    }
    else {
        return unless defined $struct;
        my $enc = JSON::XS::encode_json([$struct]);
#        warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$enc], ['enc']);
        $enc =~ s/^\[//;
        $enc =~ s/\]$//;
        return ["", $enc];
    }
    return @result;
}

sub structure {
    my ($object) = @_;
    my $struct;
    if (ref $object eq "ARRAY") {
        $struct = [];
        for my $item (@$object) {
            push @$struct, structure($item);
        }
    }
    elsif (ref $object) {
        $struct = {};
        for my $key (keys %$object) {
            my $value = $object->{ $key };
            if (ref $value) {
                $value = structure($value);
            }
            $struct->{ $key } = $value;
        }
    }
    else {
        $struct = $object;
    }
    return $struct;
}



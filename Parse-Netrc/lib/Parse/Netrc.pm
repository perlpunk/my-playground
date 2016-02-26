use strict;
use warnings;
package Parse::Netrc;

use Parse::Netrc::Tree;

use Pegex::Grammar;
use Pegex::Parser;
use File::Share qw/ dist_file /;
use IO::All;

use Moo;
has tree => ( is => 'rw' );
has data => ( is => 'ro' );

use constant DEBUG => $ENV{NETRC_DEBUG} ? 1 : 0;

sub read {
    my ($class, %args) = @_;
    my $file = $args{file} || $class->_default_netrc_file;
    open my $fh, "<", $file or die $!;
    my $data = do { local $/; <$fh> };
    close $fh;
    my $netrc = $class->new({
        data => $data,
    });
}

sub parse {
    my ($self) = @_;
    my $file = dist_file('Parse-Netrc', 'netrc.pgx');
    my $grammar_text = io($file)->all;

    my $grammar = Pegex::Grammar->new(text => $grammar_text);
    my $parser = Pegex::Parser->new(
        grammar => $grammar,
        receiver => Parse::Netrc::Tree->new,
        debug => DEBUG,
    );

    # XXX $grammar->tree->{hwaddr};

    my $result = $parser->parse($self->data);
}

sub _default_netrc_file {
    "$ENV{HOME}/.netrc"
}

1;

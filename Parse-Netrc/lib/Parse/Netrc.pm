use strict;
use warnings;
package Parse::Netrc;

use Parse::Netrc::Tree;
use Pegex::Grammar;
use Pegex::Parser;
use File::Share qw/ dist_file /;

use Mo;
has tree => ();
has data => ();

use constant DEBUG => $ENV{NETRC_DEBUG} ? 1 : 0;

sub read {
    my ($class, %args) = @_;
    my $file = $args{file};
    open my $fh, "<", $file or die $!;
    my $data = do { local $/; <$fh> };
    close $fh;
    my $netrc = $class->new(
        data => $data,
    );
    return $netrc;
}

sub parse {
    my ($self) = @_;
    my $file = dist_file('Parse-Netrc', 'netrc.pgx');
    open my $fh, "<", $file or die $!;
    my $grammar_text = do { local $/; <$fh> };
    close $fh;

    my $grammar = Pegex::Grammar->new(text => $grammar_text);
    my $parser = Pegex::Parser->new(
        grammar => $grammar,
        receiver => Parse::Netrc::Tree->new,
        debug => DEBUG,
    );

    my $result = $parser->parse($self->data);
    $self->tree($result);
    return $result;
}

1;

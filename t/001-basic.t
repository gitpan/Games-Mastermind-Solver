#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Games::Mastermind::Solver::Sequential;

# correct answer: BB
my @results = (
    [0, 0],
    [1, 0],
    [1, 0],
    [2, 0],
);

my @expected_guesses = qw/AA AB BA/;

my @guesses;

my $gmss = Games::Mastermind::Solver::Sequential->new(
    get_result => sub { push @guesses, pop; @{ shift @results } },
    holes      => 2,
    pegs       => [qw/A B/],
);

my $answer = $gmss->solve;

is($answer, 'BB', "BB found.");
is_deeply(\@guesses, \@expected_guesses, "Guesses were sequential, and stopped after the penultimate possibility.");


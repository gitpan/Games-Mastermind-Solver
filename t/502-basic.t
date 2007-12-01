#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Games::Mastermind::Solver::Basic;

# correct tune: DEADEE
my %results;
my @guesses;

my $gmsb = Games::Mastermind::Solver::Basic->new(
    get_result => sub { push @guesses, pop; @{ $results{$guesses[-1]} } },
    holes      => 5,
    pegs       => ['A' .. 'G'],
);

%results = map { $_ => [$gmsb->score($_, 'DEADE')] }
           keys %{ $gmsb->all_codes };

is(keys %results, 16807, "16807 possible 5x A..G codes");
is($gmsb->solve, "DEADE", "DEADE solution found.");
cmp_ok(@guesses, '<', 50, "got it in less than 50/16807 guesses")
    or diag join ', ', @guesses;


#!/usr/bin/env perl
package Games::Mastermind::Solver::Basic;
use Moose;

extends 'Games::Mastermind::Solver';
with 'Games::Mastermind::Solver::Role::Elimination';

sub make_guess {
    my $self = shift;

    # reset iterator
    keys %{ $self->possibilities };

    # return an arbitrary possibility
    return scalar each %{ $self->possibilities };
}

sub result_of { }

=head1 NAME

Games::Mastermind::Solver::Basic - guess arbitrary possible codes

=cut

1;


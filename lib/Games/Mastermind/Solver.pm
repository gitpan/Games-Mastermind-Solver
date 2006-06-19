package Games::Mastermind::Solver;

use strict;
use warnings;
use base qw(Class::Accessor::Fast);

our $VERSION = '0.01';

__PACKAGE__->mk_ro_accessors( qw(game won) );

sub new {
    my( $class, $game ) = @_;
    my $self = $class->SUPER::new( { game => $game } );
    $self->reset;
    return $self;
}

sub move {
    my( $self, $guess ) = @_;
    return ( 1, undef, undef ) if $self->won;

    $guess ||= $self->guess;
    my $result = $self->game->play( @$guess );
    $self->check( $guess, $result );

    return ( $self->won, $guess, $result );
}

sub guess {
    my( $self ) = @_;

    return [ _from_number( $self->_guess, $self->_pegs, $self->_holes ) ];
}

sub check {
    my( $self, $guess, $result ) = @_;

    $self->{won} = 1 if $result->[0] == $self->_holes;
    $self->_check( $guess, $result );
}

sub remaining {
    my $p = $_[0]->_possibility;
    return $p ? scalar @$p : $_[0]->_peg_number ** $_[0]->_holes;
}

sub reset {
    my( $self ) = @_;
    $self->game->reset;
    $self->{possibility} = undef;
    $self->{won} = 0;
}

sub _possibility {
    my( $self, $idx ) = @_;

    return $self->{possibility} if @_ == 1;
    return $self->{possibility} ? $self->{possibility}[$idx] : $idx;
}

sub _guess {
    my( $self ) = @_;
    die 'Cheat!' unless $self->remaining;
    return $self->_possibility( rand $self->remaining );
}

sub _check {
    my( $self, $guess, $result ) = @_;
    my $game = Games::Mastermind->new;
    my( $pegs, $holes, @new ) = ( $self->_pegs, $self->_holes );

    foreach my $try ( @{$self->_possibility || [0 .. $self->remaining - 1]} ) {
        $game->code( [ _from_number( $try, $pegs, $holes ) ] );
        my $try_res = $game->play( @$guess );
        push @new, $try if    $try_res->[0] == $result->[0]
                           && $try_res->[1] == $result->[1];
    }

    $self->{possibility} = \@new;
}

sub _from_number {
    my( $number, $pegs, $holes ) = @_;
    my $peg_number = @$pegs;
    return map { my $peg = $number % $peg_number;
                 $number = int( $number / $peg_number );
                 $pegs->[$peg]
                 } ( 1 .. $holes );
}

sub _peg_number { scalar @{$_[0]->game->pegs} }
sub _pegs  { $_[0]->game->pegs }
sub _holes { $_[0]->game->holes }

1;

__END__

=head1 NAME

Games::Mastermind::Solver - a Master Mind puzzle solver

=head1 SYNOPSIS

    # a trivial Mastermind solver

    use Games::Mastermind;
    use Games::Mastermind::Solver;

    my $player = Games::Mastermind::Solver->new( Games::Mastermind->new );
    my $try;

    print join( ' ', @{$player->game->code} ), "\n\n";

    until( $player->won || ++$try > 10 ) {
        my( $win, $guess, $result ) = $player->move;

        print join( ' ', @$guess ),
              '  ',
              'B' x $result->[0], 'W' x $result->[1],
              "\n";
    }

=head1 DESCRIPTION

C<Games::Mastermind::Solver> uses the classical brute-force algorithm
for solving Master Mind puzzles.

=head1 METHODS

=head2 new

    $player = Games::Mastermind::Solver->new( $game );

Constructor. Takes a C<Games::Mastermind> object as argument.

=head2 move

    ( $won, $guess, $result ) = $player->move;
    ( $won, $guess, $result ) = $player->move( $guess );

The player chooses a suitable move to continue the game, plays it
against the game object passed as constructor and updates its knowledge
of the solution. The C<$won> return value is a boolean, C<$guess> is
an array reference holding the value passed to C<Games::Mastermind::play>
and C<$result> is the value returned  by C<play>.

It is possible to pass an array reference as the move to make.

=head2 remaining

    $number = $player->remaining;

The number of possible solutions given the knowledge the player has
accumulated.

=head2 reset

    $player->reset;

Resets the internal state of the player.

=head2 guess

    $guess = $player->guess;

Guesses a solution.

=head2 check

    $player->check( $guess, $result );

Given a guess and the result for the guess, determines which positions
are still possible solutions for the game.

=head2 AUTHOR

Mattia Barbon <mbarbon@cpan.org>

=head2 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

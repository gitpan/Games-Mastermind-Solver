#!perl -T
use strict;
use warnings;
use Test::More tests => 8;
use Test::Exception;

BEGIN { use_ok 'Games::Mastermind::Solver' }
BEGIN { use_ok 'Games::Mastermind::Solver::Random' }
BEGIN { use_ok 'Games::Mastermind::Solver::Sequential' }
BEGIN { use_ok 'Games::Mastermind::Solver::Basic' }

dies_ok  { Games::Mastermind::Solver->new             }
         'Games::Mastermind::Solver is not instantiable';

lives_ok { Games::Mastermind::Solver::Random->new     }
         'Games::Mastermind::Solver::Random is instantiable';

lives_ok { Games::Mastermind::Solver::Sequential->new }
         'Games::Mastermind::Solver::Sequential is instantiable';

lives_ok { Games::Mastermind::Solver::Basic->new      }
         'Games::Mastermind::Solver::Basic is instantiable';


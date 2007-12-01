# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'Games-Mastermind-Solver';
all_from       'lib/Games/Mastermind/Solver.pm';

requires       'Moose';

build_requires 'Test::More';
build_requires 'Test::Exception';

auto_install;
WriteAll;


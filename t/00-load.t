#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'PDL::IO::Matlab' ) || print "Bail out!\n";
}

diag( "Testing PDL::IO::Matlab $PDL::IO::Matlab::VERSION, Perl $], $^X" );

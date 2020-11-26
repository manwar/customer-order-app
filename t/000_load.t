#!perl

use Test::More tests => 1;

BEGIN { use_ok( 'CustomerOrderApp' ) || print "Bail out!"; }
diag( "Testing CustomerOrderApp $manwar::VERSION, Perl $], $^X" );

#!/usr/bin/perl

use 5.006;
use strict; use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'CustomerOrderApp',
    AUTHOR             => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM       => 'lib/CustomerOrderApp.pm',
    ABSTRACT           => 'lib/CustomerOrderApp.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    dist               => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean              => { FILES => 'customer-order-app-*' },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'            => 0,
        'Plack::Test'           => 0,
        'HTTP::Request::Common' => 0,
    },
    PREREQ_PM => {
        'Try::Tiny'    => 0,
        'Email::Valid' => 0,
        'JSON'         => 2.90,
        'Dancer2'      => 0.159001,
    },
);

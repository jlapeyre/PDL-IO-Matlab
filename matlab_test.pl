#!/usr/bin/env perl

use warnings;
use strict;
use PDL;
use PDL::IO::Matlab qw( matlab_open );

my $f = 'Rep_Carlo_90nm.mat';
#my $f = 'junk';

#my $res = PDL::IO::Matlab::open('afile');
my $res = matlab_open($f);

print $res,"\n";

PDL::IO::Matlab::close($res);


1;

#!perl

use strict; use warnings;

use Test::More tests => 15;

use PDL;
use PDL::IO::Matlab qw ( read_matlab write_matlab );

sub tapprox {
  my($x,$y, $eps) = @_;
  $eps ||= 1e-10;
  my $diff = abs($x-$y)->sum;
  return $diff < $eps;
}


my @vers = (1,5,0);
ok( @vers ==  (my @res = PDL::IO::Matlab::get_library_version), 'library version' );

my ($x,$y);

# Write one pdl
my $f = 'testf.mat';
my $mat = PDL::IO::Matlab->new($f, '>', {format => 'MAT5'});
ok( $mat != 0 , 'file opened for write');
$mat->write(sequence(10));
$mat->close();

# Read the pdl
$mat = PDL::IO::Matlab->new($f, '<');
ok($mat != 0 , 'file opened for read');
ok($mat->get_version eq 'MAT5', 'file format MAT5');

$x = $mat->read_next;
$mat->close();

ok(tapprox($x,sequence(10)), 'read data same as write data');


$mat = PDL::IO::Matlab->new($f, '>', {format => 'MAT5'});

my @types = ( double, float, long, byte, ushort, short );
map { $mat->write(sequence($_,10)) } @types;

$mat->close;

$mat = PDL::IO::Matlab->new($f, '<');
while(1) {
    my ($err,$x) = $mat->read_next;
#    last if $err;
    last unless ref($x); #  this works as well
    ok($x->type == shift @types, 'trying type');
}
$mat->close;

$mat = PDL::IO::Matlab->new($f, '<');
my @pdls = $mat->read_all;
ok( scalar(@pdls) == 6 , 'read_all');

$mat->rewind;
 @pdls = $mat->read_all;
ok( scalar(@pdls) == 6 , 'rewind');
$mat->close;

write_matlab('tst.mat',zeroes(10),ones(5));
($x,$y) = read_matlab('tst.mat');

ok( (tapprox($x,zeroes(10)) and tapprox($y,ones(5))), 'read_matlab write_matlab');

write_matlab('tst.mat', 'MAT73', zeroes(10));
($x) = read_matlab('tst.mat');
ok( tapprox($x,zeroes(10)), 'read_matlab write_matlab, MAT73');

done_testing();


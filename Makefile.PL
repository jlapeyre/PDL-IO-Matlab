use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;

my $matio_src = './matio-1.5.0';
my $matlab_package = ['matlab.pd', 'Matlab', 'PDL::IO::Matlab'];
my %hash = pdlpp_stdargs($matlab_package);

my %more_items = (
    NAME                => 'PDL::IO::Matlab',
    AUTHOR              => q{John Lapeyre <jlapeyre@cpan.org>},
    VERSION_FROM        => 'matlab.pd',
    ABSTRACT_FROM       => 'matlab.pd',
    PL_FILES            => {},
    OBJECT  =>  ' Matlab.o matio_obj.o ' ,
    LIBS => [ ' -lz -lhdf5 ' ],
    PREREQ_PM => {
        'Test::More' => 0,
        'PDL' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'PDL-IO-Matlab-* Matlab.*' },
);

map { $hash{$_} = $more_items{$_} } keys %more_items;

sub MY::postamble {pdlpp_postamble($matlab_package)};

WriteMakefile( %hash );

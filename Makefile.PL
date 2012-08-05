use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;

# Makefile has targets 'cleanall' and 'distcleanall'.
# These do clean and distclean in both module distribution
# toplevel and in $matio_top_level.

my $matio_top_level = './matio-1.5.0';

if ( not -e "$matio_top_level/src/matio_pubconf.h" ) {
    print "Makefile.PL: running configure in $matio_top_level\n";
    system "cd $matio_top_level; ./configure";
}

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
    # note the file below that matio Makefile fails to clean.
    clean               => { FILES => ' PDL-IO-Matlab-* Matlab.* tst.mat testf.mat ' . 
                                 $matio_top_level . '/test/atconfig' },
);

map { $hash{$_} = $more_items{$_} } keys %more_items;

#	cd $matio_top_level; ./configure

sub MY::postamble {   qq{

matio_obj.o:
	cd $matio_top_level; cd src; \$(MAKE)
	ld -r -o matio_obj.o $matio_top_level/src/.libs/*.o

cleanall: clean
	cd $matio_top_level; \$(MAKE) clean

distcleanall: distclean
	cd $matio_top_level; \$(MAKE) distclean

}  . pdlpp_postamble($matlab_package)};


WriteMakefile( %hash );

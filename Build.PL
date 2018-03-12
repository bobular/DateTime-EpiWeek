use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'DateTime::EpiWeek',
    license             => 'perl',
    dist_author         => q{Bob MacCallum <r.maccallum@imperial.ac.uk>},
    dist_version_from   => 'lib/DateTime/EpiWeek.pm',
    requires => {
	'DateTime' => 0,
    },	
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

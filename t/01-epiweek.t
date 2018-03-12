use Test::More tests => 4;

use strict;
use warnings;

use DateTime;
use DateTime::Format::ISO8601;
use DateTime::EpiWeek;

my $iso8601 = DateTime::Format::ISO8601->new;

my $dt1 = $iso8601->parse_datetime("2013-12-29");
my ($y1, $w1) = $dt1->epiweek;
is($y1, 2014, "year1 correct");
is($w1, 1, "week1 correct");

my $dt2 = $iso8601->parse_datetime("2014-12-29");
my ($y2, $w2) = $dt2->epiweek;
is($y2, 2014, "year2 correct");
is($w2, 52, "week2 correct");

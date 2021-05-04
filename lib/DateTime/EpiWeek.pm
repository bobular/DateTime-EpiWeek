package DateTime::EpiWeek;

=head1 NAME
DateTime::EpiWeek - convert dates to epidemiological weeks - epi-weeks
=head1 VERSION
Version 0.01
=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module clumsily adds epiweek methods to the DateTime class itself.

    use DateTime;
    use DateTime::EpiWeek;
    my $dt = ...
    my ($epi_year, $epi_week) = $dt->epiweek;

=head1 METHODS

=head2 epiweek

    ($epi_year, $epi_week) = $dt->epiweek;

=head2 epiweek_number

    returns just the week number

=head2 epiweek_year

    returns just the year

=head1 BACKGROUND

From http://www.cmmcp.org/epiweek.htm

The first epi week of the year ends, by definition, on the first
Saturday of January, as long as it falls at least four days into the
month. Each epi week begins on a Sunday and ends on a Saturday.

The epiweek function was tested on the calendars available here:
http://www.cmmcp.org/epiweek.htm

Any days in Epi Week 53 "twilight zone" are assigned to week 52.

=cut

use DateTime;
use Math::Utils 'floor';

# We want to add a new method for all DateTime objects
# and this seems to do it.
package DateTime;


sub epiweek {
  my $self = shift;
  my ($epi_year, $epi_week) = ("n/a", "n/a");
  my $orig_year = $self->year;

  # first find out the beginning Sunday of epiweek 2 for this year
  my $epiweek2_start_day_of_year;
  my $i = 4;
  while (not defined $epiweek2_start_day_of_year) {
    my $dt = DateTime->new(year=>$orig_year, month=>1, day=>$i);
    if ($dt->day_of_week == 6) { # Saturday
      $epiweek2_start_day_of_year = $i+1; # the Sunday after
    }
    $i++;
  }

  my $is_leap = $self->is_leap_year;
  my $epi_week = floor(($self->day_of_year-$epiweek2_start_day_of_year)/7) + 2;
  if ($epi_week == 53) {
    if ($epiweek2_start_day_of_year == 5 ||
       ($is_leap && $epiweek2_start_day_of_year == 6)) {
      # handle "missing week 53" as 52
      $epi_year = $orig_year;
      $epi_week = 52;
    } else {
      $epi_year = $orig_year + 1;
      $epi_week = 1;
    }
  } elsif ($epi_week == 0) {
    $epi_year = $orig_year - 1;
    $epi_week = 52;
  } else {
    $epi_year = $orig_year;
  }
  return ($epi_year, $epi_week);
}

sub epiweek_number {
  my $self = shift;
  my ($epi_year, $epi_week) = $self->epiweek;
  return $epi_week;
}

sub epiweek_year {
  my $self = shift;
  my ($epi_year, $epi_week) = $self->epiweek;
  return $epi_year;
}

1;

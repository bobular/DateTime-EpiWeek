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
use POSIX qw/floor/;

# We want to add a new method for all DateTime objects
# and this seems to do it.
package DateTime;


sub epiweek {
  my $self = shift;

  # first find out the beginning Sunday of epiweek 2 for this year
  my $i = 4;
  my $epiweek2_day;
  my $orig_year = $self->year;

  until (defined $epiweek2_day) {
    my $today = new DateTime(
      day   => $i++,
      month => 1,
      year  => $orig_year,
    )->day_of_week;

    # Sets the next day (Sunday) if 'today' pointer is Saturday
    $epiweek2_day = $i if $today == 6;
  }

  my ($epi_year, $epi_week) = ('n/a', 'n/a');
  {
    my $day_of_year   = $self->day_of_year;
    my $days_from     = $day_of_year - $epiweek2_day;
    my $weeks_from    = $days_from / 7;
    my $real_epi_week = $weeks_from + 2;

    $epi_week = POSIX::floor $real_epi_week;
  }
  $epi_year = $orig_year;

  if ($epi_week == 53) {
    
    if (
      $epiweek2_day == 5 ||
      $self->is_leap_year && $epiweek2_day == 6
    ) {
      # handle "missing week 53" as 52
      $epi_week = 52;
    } else {
      $epi_year++;
      $epi_week = 1;
    }

  } elsif ($epi_week == 0) {
    $epi_year--;
    $epi_week = 52;
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

#!/usr/bin/perl

my $months_ref = {
  "Jan" => "01",
  "Feb" => "02",
  "Mar" => "03",
  "Apr" => "04",
  "May" => "05",
  "Jun" => "06",
  "Jul" => "07",
  "Aug" => "08",
  "Sep" => "09",
  "Oct" => "10",
  "Nov" => "11",
  "Dec" => "12" };
my %months = %$months_ref;

my $totalcount = 0;
my $totalsum = 0;
my $totalmin = 255;
my $totalmax = -255;
my $count = 0;
my $sum = 0;
my $min = 255; 	# initial conditions
my $max = -255;

while (<>) {
  chomp;

  next if /transmitting/i;

  if ( /^(\d{4})-([a-z0-9]*)-(\d\d)/i or /^(\d{4})(\d{2})(\d{2})\s+\d\d:\d\d/ ) {
    ($y, $m, $d) = ($1, $2, $3);
    $m = $months{$m} if $m =~ /[a-z]/i;
    $lastdate = $date;
    $date = "$y-$m-$d";
    #print "$date\n";

    if ($lastdate ne $date and $count > 0) {
      outputOneDay($lastdate, $count, $sum, $min, $max);
      $count = 0;
      $sum = 0;
      $min = 255; 	# initial conditions
      $max = -255;
    }
  }

  if (/^(\d{4})(\d{2})(\d{2}) \d{4}/ ) {
    # jtdx
    ($y, $m, $d) = ($1, $2, $3);
    $logdate = "$y-$m-$d";
    if ($logdate ne $date) {
      $lastdate = $date;
      $date = $logdate;
      if ($lastdate ne $date and $count > 0) {
	outputOneDay($lastdate, $count, $sum, $min, $max);
	$count = 0;
	$sum = 0;
	$min = 255; 	# initial conditions
	$max = -255;
      }
    }

    (undef, $t, $db, $dt, $afreq, $mode) = split /\s+/;
    next if $mode =~ /^[^#@~]/;	# JT65, JT9 and FT8
    #print "$t $db $dt\n";
    addOne($dt);
    if (abs($dt) > 6) {
      print "WARNING: BIG DELTA (jtdx): $_\n";
    }
  } elsif (/^\d+\s+[+-]?\d+\s+-?[0-9.]+/) {
    # wsjtx
    ($t, $db, $dt, $afreq, $mode) = split /\s+/;
    #print "$t $db $dt\n";
    next if $mode =~ /^[^#@~]/;	# JT65, JT9 and FT8
    addOne($dt);
    if (abs($dt) > 6) {
      print "WARNING: BIG DELTA (wsjtx): $_\n";
    }
  }
}

if ($count > 0) {
  outputOneDay($date, $count, $sum, $min, $max);
}

outputOneDay("TOTAL", $totalcount, $totalsum, $totalmin, $totalmax);

exit 0;

sub addOne
{
  my $dt = shift;

  $count++;
  $sum += $dt;
  $max = $dt if $dt > $max;
  $min = $dt if $dt < $min;

  $totalsum += $dt;
  $totalcount++;
  $totalmax = $dt if $dt > $totalmax;
  $totalmin = $dt if $dt < $totalmin;
}

sub outputOneDay
{
  my $date = shift;
  my $count = shift;
  my $sum = shift;
  my $min = shift;
  my $max = shift;

  my $avg = $sum / $count;
  printf "%s: %d samples; %.2f avg, %.1f max, %.1f min\n", $date, $count, $avg, $max, $min;
}

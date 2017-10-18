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
  if ( /^(\d{4})-([a-z0-9]*)-(\d\d)/i ) {
    ($y, $m, $d) = ($1, $2, $3);
    $m = $months{$m} if $m =~ /[a-z]/i;
    $lastdate = $date;
    $date = "$y-$m-$d";
    #print "$date\n";

    if ($lastdate ne $date and $count > 0) {
      my $avg = $sum / $count;
      printf "%s: %d samples; %.2f avg, %.1f max, %.1f min\n", $lastdate, $count, $avg, $max, $min;
      $count = 0;
      $sum = 0;
      $min = 255; 	# initial conditions
      $max = -255;
    }
  }

  if (/^\d+\s+[+-]?\d+\s+-?[0-9.]+/) {
    ($t, $db, $dt) = split /\s+/;
    #print "$t $db $dt\n";
    $count++;
    $sum += $dt;
    $max = $dt if $dt > $max;
    $min = $dt if $dt < $min;
    $totalsum += $dt;
    $totalcount++;
    $totalmax = $dt if $dt > $totalmax;
    $totalmin = $dt if $dt < $totalmin;
  }
}

my $totalavg = $totalsum / $totalcount;
printf "TOTAL: %d samples; %.2f avg, %.1f max, %.1f min\n", $totalcount, $totalavg, $totalmax, $totalmin;

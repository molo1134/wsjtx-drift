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

my $count = 0;
my $sum = 0;

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
      printf "%s: %d samples: %.2f offset\n", $lastdate, $count, $avg;
      $count = 0;
      $sum = 0;
    }
  }

  if (/^\d+\s+[+-]?\d+\s+-?[0-9.]+/) {
    ($t, $db, $dt) = split /\s+/;
    #print "$t $db $dt\n";
    $count++;
    $sum += $dt;
  }
}

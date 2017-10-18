# WSJT-X Drift calculation

This is a quick program to calculate average time delta to see how closely your
machine's clock matches to ham transmitters using JT65, JT9 or FT8 modes.  It
uses the WSJT-X `DT` field for this calculation.

## Usage

```
$ ./drift.pl ALL.TXT
2017-09-21: 7293 samples: 0.46 offset
2017-09-22: 8170 samples: 0.44 offset
2017-09-23: 2070 samples: 0.44 offset
2017-09-26: 5947 samples: 0.44 offset
2017-09-27: 13352 samples: 0.42 offset
```

From this output we see about ~440 ms of time delta between the local clock and
the average ham transmitter.

## Compare your clock to a time reference

If you have doubts about how your local clock compares to a reference time, use the `ntpdate -q` command to query a NTP server.

```
$ ntpdate -q tick.usno.navy.mil
server 192.5.41.40, stratum 1, offset 0.000606, delay 0.05931
18 Oct 11:20:07 ntpdate[1354]: adjust time server 192.5.41.40 offset 0.000606 sec
```

From this output, we see <1ms time delta to a reference standard.

## Conclusions

Most hams have shitty NTP implementations.


use strict;
use warnings;
use Time::HiRes "gettimeofday";

my $currentTimeStr = getCurrentTimeStr();
print $currentTimeStr;

sub getCurrentTimeStr {
    my ($epochSec, $microSec) = gettimeofday();
    my ($sec, $min, $hour, $day, $mon, $year) = localtime($epochSec);
    $year += 1900;
    $mon++;
    return sprintf("%04d/%02d/%02d %02d:%02d:%02d.%03d ",$year,$mon,$day,$hour,$min,$sec,$microSec/1000);
}

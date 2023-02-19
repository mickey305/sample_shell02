#!/usr/local/bin/perl

#use open IN => ":encoding(shiftjis)";

my $inFile = $ARGV[0];
if (!-f $inFile) {
    die "There is not $inFile file...";
}
my $outFile = $ARGV[1];
if (!-f $inFile) {
    die "There is not $inFile file...";
}
my $templFile = "template.txt";
open(my $inFh,  "< $inFile")  or die("Error :$!");
open(my $templFh,  "< $templFile")  or die("Error :$!");
open(my $outFh,  "> $outFile")  or die("Error :$!");

my %templCache = ();
while (my $templData = <$templFh>) {
  chomp($templData);
  my $key1 = substr($templData, 0, 1);
  my $key2 = substr($templData, 9, 7);
  my $key3 = substr($templData, 1, 1);
  
  if ($key1 == "1" || $key1 == "3") {
    push(@{$templCache{$key1}}, $templData);
  } else {
    push(@{$templCache{$key1}{$key2}{$key3}}, $templData);
  }
}

close($templFh);

my $i = 1;
my $cnt = 1;
while (my $line = <$inFh>) {
    chomp($line);
    my $s1 = substr($line, 0, 1);
    
    if ($s1 == "1") {
      my $tmpData = $templCache{"1"}[0];
      print $outFh
            substr($tmpData, 0, 21)
            . getTime()
            . substr($tmpData, 33)
            . "\n";
    }
    
    if ($s1 == "2") {
      if (!exists $templCache{"2"}{sprintf("%07d", $i)}) {
        $i = 1;
      }
      # 1st data edit
      my $tmpData = $templCache{"2"}{sprintf("%07d", $i)}{"1"}[0];
      print $outFh
            substr($tmpData, 0, 2)
            . sprintf("%07d", $cnt)
            . substr($line, 1, 7)
            . substr($tmpData, 16, 51 - 16)
            . substr($line, 25, 12)
            . substr($tmpData, 63)
            . "\n";
      $cnt++;
      
      # 2nd data edit
      my $tmpData = $templCache{"2"}{sprintf("%07d", $i)}{"2"}[0];
      print $outFh
            substr($tmpData, 0, 2)
            . sprintf("%07d", $cnt)
            . substr($line, 1, 7)
            . substr($tmpData, 16, 99)
            . getTime()
            . substr($tmpData, 127)
            . "\n";
      $cnt++;
      
      $i++;
    }
    
    if ($s1 == "3") {
      my $tmpData = $templCache{"3"}[0];
      print $outFh
            substr($tmpData, 0, 21)
            . getTime()
            . substr($tmpData, 33)
            . "\n";
    }
}

close($inFh);
close($outFh);

sub getTime() {
  my ($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
  $year += 1900;
  $mon += 1;
  $year = $year % 100;
  return sprintf("%02d%02d%02d%02d%02d%02d", $year, $mon, $mday, $hour, $min, $sec);
}


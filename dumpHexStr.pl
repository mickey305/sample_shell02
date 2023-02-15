#!/usr/local/bin/perl
use Data::Dumper;

$Data::Dumper::Terse = 1;

my $inFile = $ARGV[0];
if (!-f $inFile) {
    die "There is not $inFile file...";
}

open(my $inFh,  "< $inFile")  or die("Error :$!");

my $res = "";
while (my $line = <$inFh>) {
    $res = $res . $line;
}

BinaryDump($res);

close($inFh);

sub BinaryDump {
    my ($buf) = @_;
    my $len;
    my $i;
    my $cnt1 = 0;
    my $cnt2 = 0;

    # ダンプとして１行に何バイト分のデータを出力するか
    my $limit = 32;

    $len = length($buf);
    $tmp = "";
    
    printf("%06X-%08X ", $cnt1, $cnt2);
    for ($i = 0; $i < $len; $i++) {
        my $s = substr($buf, $i, 1);
        printf("%02X ", ord($s));
        $tmp = $tmp . $s;
        # limit文字目で画面上の改行
        if (($i % $limit) == ($limit - 1)) {
            $tmp =~ s/[[:cntrl:]]/?/g;
            print Dumper(" " . $tmp . " ");
            $tmp = "";
            $cnt1++;
            $cnt2 = $cnt2 + $limit;
            printf("%06X-%08X ", $cnt1, $cnt2);
        }
    }
    if (($i % $limit) != ($limit - 1)) {
        $tmp =~ s/[[:cntrl:]]/?/g;
        printf("%" . ($limit - ($i % $limit)) * 3 . "s", " ");
        print Dumper(" " . $tmp . " ");
        $tmp = "";
    }
}

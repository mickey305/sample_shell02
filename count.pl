#!/usr/local/bin/perl

my %data = ();

open(IN, 'customer_data.csv');
while(<IN>){
    chomp;
    my $lineData = $_;
    my ($id, $name, $age, $ken, $shi) = split(/,/, $lineData);

    my $name = $name . "テスト";
    # 人データを作る
    my $people = [$id, $name, $age];
    # 結果配列に保存する
    push(@{$data{$ken}{$shi}}, $people);
}
close(IN);

# 出力ファイルを開く
open(OUT, ">customer_output.txt");

foreach my $ken (keys %data){
    # 県名の表示
    print OUT $ken, "\n";

    # 県名に対する値(市区がキーの連想配列)を取り出す
    my $ken_val = $data{$ken};

    foreach my $shi (keys %{$ken_val}){
        # 市区を表示
        print OUT "\t", $shi, "\n";

        # 県名・市区に対する値（人を含んだ配列)を取り出す
        my $shi_val = $data{$ken}{$shi};

        foreach my $people (@$shi_val){
        # カンマで区切って表示する
            print OUT "\t\t", join(',', @$people), "\n";
        }
    }
}

# ファイルを閉じる　ﾃｽﾄ 123456789012345678
close(OUT);

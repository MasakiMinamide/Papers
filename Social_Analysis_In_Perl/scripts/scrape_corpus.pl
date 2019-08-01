# Page title: <span class="page_title__text">First timer - what to do in 3 days</span>
# Time: 	<td align=right><font class=type--legacy face=arial color=ffffff>2019/7/4 11:57 </font></td>
# Reply text tag: <div class=type--legacy> </div>

#!/usr/bin/perl -w
use strict;
use warnings;
use LWP::Simple;

my $input = ("./corpus/take_urls.txt");
open(IN, "< $input") or die("error :$!");

while(my $url = <IN>){
    chomp($url);
    my $html = qx(curl "$url");
    $html =~ m/span class="page_title__text">(.*?)<\/span>/;
    my $title = $1;
    $html =~ m/([0-9]{4})\/([0-9]+?)\/([0-9]+) ([0-9]+):([0-9]+)/;
    my $year = $1;
    my $output = ("./corpus/posts_" . $year .".txt");
    open OUT, ">> $output";
    print OUT "Title\t$title";

    my @html = split (/<tr bgcolor=dddddd>/, $html);
    foreach my $tablerow (@html){
        if($tablerow =~ m/div class=type--legacy>(.*?)<\/div>/sm) {
            print OUT $1;
        }
    }
}

close(OUT);


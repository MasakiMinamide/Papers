# STEP2: Iterate. Inside loop, create hash of each year, count appearances
# STEP3: Visualize popular city ranking in csv
use strict;
use warnings;

my @cities = ('aichi', 'akita', 'aomori', 'chiba', 'ehime', 'fukui', 'fukuoka', 'fukushima', 'gifu', 'gunma', 'hiroshima', 'hokkaido', 'hyogo', 'ibaraki', 'ishikawa', 'iwate', 'kagawa', 'kagoshima', 'kanagawa', 'kochi', 'kumamoto', 'kyoto', 'mie', 'miyagi', 'miyazaki', 'nagano', 'nagasaki', 'nara', 'niigata', 'oita', 'okayama', 'okinawa', 'osaka', 'saga', 'saitama', 'shiga', 'shimane', 'shizuoka', 'tochigi', 'tokushima', 'tokyo', 'tottori', 'toyama', 'wakayama', 'yamagata', 'yamaguchi', 'yamanashi');
my %city_count;

my $output = ('./output/data.csv');
open (OUT, "> $output");

print OUT " ,";
foreach my $city(@cities){
    # Print top row for city name
    print OUT ucfirst($city) . ",";
}
print OUT "\n";

# Iterate each city by year
for (my $year=2004; $year <= 2019; $year++) {
    foreach my $city (@cities){
        $city_count{$city} = 0;
    }
    my $counter = 0;
    my $input = ('./corpus/posts_'. $year . '.txt');
    open(IN, "< $input") or die("error :$!");

    # count city appearance.
    while(my $line = <IN>){
        chomp($line);
        my @words = split(/ /, $line);
        foreach (@words) {
            if (defined($city_count{lc($_)})) {
                $city_count{lc($_)} +=1;
                $counter ++;
            }
        }
    }
    my %relative_frequencies = %city_count;
    print OUT "$year,";

    for my $key (sort keys %city_count) {
        # $relative_frequencies{$key} =  sprintf("%.4f", $city_count{$key}/$counter);
        # print OUT "$city_count{$key} ,$relative_frequencies{$key},";
        print OUT "$city_count{$key},";
    }
    print OUT "\n";
}
print "$output is saved.\n";
close OUT;
# STEP2: Iterate. Inside loop, create hash of each year, count appearances
# STEP3: Visualize popular city ranking in csv
use strict;
use warnings;
# my @cities = ("Hokkaido","Aomori","Iwate","Miyagi","Akita", "Yamagata", "Fukushima", "Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa", "Niigata", "Toyama", "Ishikawa", "Fukui", "Yamanashi", "Nagano", "Gifu", "Shizuoka", "Aichi", "Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama", "Tottori", "Shimane", "Okayama", "Hiroshima", "Yamaguchi", "Tokushima", "Kagawa", "Ehime", "Kochi", "Fukuoka", "Saga", "Nagasaki", "Kumamoto", "Oita", "Miyazaki", "Kagoshima", "Okinawa");
my @cities = ('hokkaido', 'aomori', 'iwate', 'miyagi', 'akita', 'yamagata', 'fukushima', 'ibaraki', 'tochigi', 'gunma', 'saitama', 'chiba', 'tokyo', 'kanagawa', 'niigata', 'toyama', 'ishikawa', 'fukui', 'yamanashi', 'nagano', 'gifu', 'shizuoka', 'aichi', 'mie', 'shiga', 'kyoto', 'osaka', 'hyogo', 'nara', 'wakayama', 'tottori', 'shimane', 'okayama', 'hiroshima', 'yamaguchi', 'tokushima', 'kagawa', 'ehime', 'kochi', 'fukuoka', 'saga', 'nagasaki', 'kumamoto', 'oita', 'miyazaki', 'kagoshima', 'okinawa');
my %city_count;
my $counter = 0;
foreach my $city (@cities){
    $city_count{$city} = 0;
}

my $year = $ARGV[0];
my $input = ('./corpus/posts_'. $year . '.txt');
open(IN, "< $input") or die("error :$!");;

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

my $output = ('./output/result_' . $year . '.csv');
open (OUT, "> $output");

print OUT "Total:$counter\nCity,Count,RelativeFrequency\n";
# for my $key (sort {$city_count{$b} <=> $city_count{$a}} keys %city_count) {
#     $relative_frequencies{$key} =  sprintf("%.4f", $city_count{$key}/$sum);
#     print OUT ucfirst($key) . "\t\t$city_count{$key}\t$relative_frequencies{$key}\n";
# }
for my $key (sort {$city_count{$b} <=> $city_count{$a}} keys %city_count) {
    $relative_frequencies{$key} =  sprintf("%.4f", $city_count{$key}/$counter);
    print OUT ucfirst($key) . ",$city_count{$key},$relative_frequencies{$key}\n";
}
print "$output is saved.\n";
close OUT;
#!/usr/bin/perl/ -w

use strict;
use warnings;
use LWP::Simple;

## LWP is blocked as a user agent on japan-guide; we use cURL for downloading instead;
## windows users might try installing curl: https://curl.haxx.se/windows/
## or change the user agent automatically: https://www.perlmonks.org/?node_id=695886


# my $corpusfolder = "/Users/josch/Documents/BERLIN/Lehre/seminare/perl/13_scraping/corpus/";

# define output files
my $follow_url_file = "./corpus/follow_urls.txt";
my $take_url_file = "./corpus/take_urls.txt";

# manage urls
# my $start_url = "https://www.japan-guide.com/forum/quedisplay.html";
my $start_url = "https://www.japan-guide.com/forum/quedisplay.html?aTYPE=1";

my $basis_url = "https://www.japan-guide.com/forum/"; # needed for complementing url

# initialize variables
my %downloaded_urls; # contains all follow urls which where analyzed
my %urls_to_download; # contains all known follow urls, which need to be downloaded
my %take_urls; # contains all take urls

# add start url to hash containing url, which still need to be downloaded
$urls_to_download{$start_url} = 1;

# set number of urls to be downloaded to 1
my $number_of_urls_to_download = 1;
my $count = 0;
# loop until no follow urls left
while ($number_of_urls_to_download > 0) {

	print "\n---------------------------------------------\n$number_of_urls_to_download URLs to be downloaded\n\n";
	my @urls_to_download = keys %urls_to_download;
	
	foreach my $url (@urls_to_download) {

		# delete url from hash, which contains urls that still need to be downloaded
		delete ($urls_to_download{$url});

		# add url to hash of urls, which have already been downloaded once
		$downloaded_urls{$url} = 1;

		# download url
		print "\ndownloading: $url\n";
		my $html = qx(curl "$url");

		# find all hyperlinks
		my @links = split(/a href=/, $html);

		# check all links, if they are follow links	or take links
		foreach my $snippet (@links) {
			my $follow_url;
			if ($snippet =~ m/aTYPE=1&aPAGE=([0-9]+)/) {
				$follow_url = $basis_url . "quedisplay.html?aTYPE=1&aPAGE=" . $1;
			}
			# elsif ($snippet =~ m/aTYPE=([0-9])/) {
			# 	$follow_url = $basis_url . "quedisplay.html?aTYPE=" . $1;
			# }
			elsif ($snippet =~ m/^quereadisplay.html\?0\+([0-9]+)/) {
				my $take_url = $basis_url . "quereadisplay.html?0+" . $1;
				$take_urls{$take_url} = 1;
			}
			if (defined $follow_url) {
				unless (defined $downloaded_urls{$follow_url}) {
					# unless follow link has already been downloaded, add it to urls_to_download-hash
					unless (defined $urls_to_download{$follow_url}) {
						print "\tnew follow URL: $follow_url\n"
					}
					$urls_to_download{$follow_url} = 1;;
				}
			}

		}

	}	

	# get number of urls left for downloading
	$number_of_urls_to_download = keys %urls_to_download;
	$count += 1;
	print "count: $count\n";
}

# print URLs to files

open OUT, "> $take_url_file";
foreach my $url (sort keys %take_urls) {
	print OUT "$url\n";
}
close OUT;

open OUT, "> $follow_url_file";
foreach my $url (sort keys %downloaded_urls) {
	print OUT "$url\n";
}
close OUT;
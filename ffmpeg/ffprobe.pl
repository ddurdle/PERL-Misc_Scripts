#!/usr/bin/perl

require 'crawler.pm';

# number of times to retry when ffmpeg encounters network errors
use constant RETRY => 50;


use constant PATH_TO_FFMPEG => '/u01/ffmpeg-git-20171123-64bit-static/';


use Getopt::Std;		# and the getopt module

my $FFPROBE = PATH_TO_FFMPEG .'/ffprobe ';


my %opt;
die (USAGE) unless (getopts ('d:',\%opt));

my $directory = $opt{'d'};


TOOLS_CRAWLER::ignoreCookies();

opendir (DIR, $directory) or die $!;


while (my $file = readdir(DIR)) {

	next if $file eq '.' or $file eq '..';
	print "$file\n";

	open(STRM, $directory. '/'. $file) or die ('cannot open input '.$file);
	my $url = <STRM>;
	close(STRM);

	$url =~ s%\n%%;

	$url .= '&checkonly=true';
	my @results = TOOLS_CRAWLER::complexGET($url,undef,[],[],[('exists=([^\<])[^\<]+', '<html></br>', '</html>')]);

	if ($results[3] eq 'F'){
		print $directory . '/' . $file . "\n";
	}



}
close(DIR);




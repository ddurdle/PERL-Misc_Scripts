######
# Traverse a URL
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:1:2:3:l',\%opt));

my $URL = $opt{'u'};

if ($URL eq ''){
	$URL = <>;
}

my $searchCriteria = quotemeta $opt{'1'};
my $extractStart = quotemeta $opt{'2'};
my $extractEnd = quotemeta $opt{'3'};
my $lastOnly = 0;
if (defined($opt{'l'})){
	$lastOnly = 1;
}


require 'crawler.pm';
@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
for (my $i=3; $i <=$#results; $i = $i+2){
	print STDOUT 'Found = ' .  $results[$i]. "\n" if (not $lastOnly or $i == $#results);
}


exit(0);
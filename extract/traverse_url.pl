######
# Traverse a URL
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:1:2:3:',\%opt));

my $URL = $opt{'u'};
my $searchCriteria = quotemeta $opt{'1'};
my $extractStart = quotemeta $opt{'2'};
my $extractEnd = quotemeta $opt{'3'};


require 'crawler.pm';
@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
if ($#results >= 3 ){
	print STDOUT 'Found = ' .  $results[3]. "\n";
}


exit(0);
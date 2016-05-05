######
# Traverse a URL
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:1:2:3:l4:5:6',\%opt));

my $URL = $opt{'u'};

if ($URL eq ''){
	$URL = <>;
}

my $searchCriteria = quotemeta $opt{'1'};
my $extractStart = quotemeta $opt{'2'};
my $extractEnd =  $opt{'3'}; #quotemeta $opt{'3'};
my $lastOnly = 0;
if (defined($opt{'l'})){
	$lastOnly = 1;
}
my $nextCriteria = quotemeta $opt{'4'};
my $nextStart = quotemeta $opt{'5'};
my $nextEnd =  $opt{'6'}; #quotemeta $opt{'3'};

require 'crawler.pm';
if ($nextCriteria ne ''){
	my $nextURL = $URL;
	while ($URL ne ''){

		@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($nextCriteria, $nextStart, $nextEnd)]);
		if ($#results >=3){
			$nextURL =  $results[3];
			$nextURL = $nextURL.'10:00';
			print STDOUT 'NEXT = ' .  $nextURL. "\n";
		}

		@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
		for (my $i=3; $i <=$#results; $i = $i+2){
			print STDOUT  $results[$i]. "\n" if (not $lastOnly or $i == $#results);
		}
		$URL = $nextURL;
	}

}else{
	@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
	for (my $i=3; $i <=$#results; $i = $i+2){
		print STDOUT  $results[$i]. "\n" if (not $lastOnly or $i == $#results);
	}

}




exit(0);
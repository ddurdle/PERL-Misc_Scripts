######
# Find a value on a url
#  Parameters
#  -u url
#  -s string to grep value from (value = %1%)
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:1:2:3:4:5:6:lh:',\%opt));

my $URL = $opt{'u'};
my $headers = $opt{'h'};

my $searchCriteria = quotemeta $opt{'1'};
my $extractStart =  quotemeta  $opt{'2'};#
my $extractEnd = quotemeta $opt{'3'};#quotemeta $opt{'3'};
my $searchCriteria2 = quotemeta $opt{'4'};
my $extractStart2 =  quotemeta  $opt{'5'};#
my $extractEnd2 = quotemeta $opt{'6'};#quotemeta $opt{'3'};



#my $extractStart = quotemeta $opt{'2'};

my $lastOnly = 0;
if (defined($opt{'l'})){
	$lastOnly = 1;
}

require 'crawler.pm';

if ($headers ne ''){

	TOOLS_CRAWLER::setHeaders($headers);
}

my $isList=0;
if ($URL eq ''){
	$isList=1;
	open(LIST, '<-') or die ('cannot open STDIN');
	$URL = <LIST>;
}

while ($URL ne ''){

	if ($searchCriteria2 ne '' ){
		@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd),($searchCriteria2, $extractStart2, $extractEnd2)]);

	}else{
		@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
	}
	for (my $i=3; $i <=$#results; $i = $i+2){
		next if $results[$i] eq $URL;
		print STDOUT 'Found = ' .  $results[$i]. "\n" if (not $lastOnly or $i == $#results);
	}
	if ($isList){
		$URL = <LIST>;
	}else{
		$URL = '';
	}

}
close(LIST) if $isList;



exit(0);
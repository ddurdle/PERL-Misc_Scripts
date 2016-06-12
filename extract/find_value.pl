######
# Find a value on a url
#  Parameters
#  -u url
#  -s string to grep value from (value = %1%)
#  -r referer
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:1:2:3:4:5:6:7:8:9:lh:r:',\%opt));

my $URL = $opt{'u'};
my $headers = $opt{'h'};

my $searchCriteria = quotemeta $opt{'1'};
my $extractStart =  quotemeta  $opt{'2'};#
my $extractEnd = $opt{'3'};#quotemeta $opt{'3'};
my $searchCriteria2 = $opt{'4'};
my $extractStart2 =   $opt{'5'};#
my $extractEnd2 = $opt{'6'};#quotemeta $opt{'3'};
my $searchCriteria3 = quotemeta $opt{'7'};
my $extractStart3 =  quotemeta  $opt{'8'};#
my $extractEnd3 = quotemeta $opt{'9'};#quotemeta $opt{'3'};

#my $extractStart = quotemeta $opt{'2'};

my $lastOnly = 0;
if (defined($opt{'l'})){
	$lastOnly = 1;
}

require 'crawler.pm';


if ($headers ne ''){

	TOOLS_CRAWLER::setHeaders($headers);
}
TOOLS_CRAWLER::ignoreCookies();

my $isList=0;
if ($URL eq ''){
	$isList=1;
	open(LIST, '<-') or die ('cannot open STDIN');
	$URL = <LIST>;
}
if  ($opt{'r'} ne ''){
	TOOLS_CRAWLER::setReferer($opt{'r'});
}

while ($URL ne ''){

	if ($URL =~ m%\|%){
		my $param;
		($URL, $param) = $URL =~ m%([^\|]+)\|(.*?)%;
		if ($searchCriteria3 ne '' ){
			@results = TOOLS_CRAWLER::complexPOST($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd),($searchCriteria2, $extractStart2, $extractEnd2),($searchCriteria3, $extractStart3, $extractEnd3)], $param);
		}elsif ($searchCriteria2 ne '' ){
			@results = TOOLS_CRAWLER::complexPOST($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd),($searchCriteria2, $extractStart2, $extractEnd2)], $param);
		}else{
			@results = TOOLS_CRAWLER::complexPOST($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)], $param);
		}

	}else{
		if ($searchCriteria3 ne '' ){
			@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd),($searchCriteria2, $extractStart2, $extractEnd2),($searchCriteria3, $extractStart3, $extractEnd3)]);
		}elsif ($searchCriteria2 ne '' ){
			@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd),($searchCriteria2, $extractStart2, $extractEnd2)]);
		}else{
			@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[($searchCriteria, $extractStart, $extractEnd)]);
		}

	}
	for (my $i=3; $i <=$#results; $i = $i+2){
		next if $results[$i] eq $URL;
		print STDOUT $results[$i]. "\n" if (not $lastOnly or $i == $#results);
	}
	if ($isList){
		$URL = <LIST>;
	}else{
		$URL = '';
	}

}
close(LIST) if $isList;



exit(0);

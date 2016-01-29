######
# Extract URLs from a txt file
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('u:',\%opt));

my $URL = $opt{'u'};


require 'crawler.pm';
@results = TOOLS_CRAWLER::complexGET($URL,undef,[],[],[('https://drive.google.com/file/d/', '/', '/')]);
if ($#results >= 3 ){
	print STDERR 'Google Drive document = ' .  $results[3]. "\n";
}


exit(0);
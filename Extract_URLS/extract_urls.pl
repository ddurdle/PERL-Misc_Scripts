######
# Extract URLs from a txt file
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:',\%opt));

my $file = $opt{'f'};


open(LIST, './'.$file) or die ('cannot open input'.$file);

while(my $line = <LIST>){
	if ($line =~ m%http[^\:]?\:\/\/[^\s]+%){
		my ($URL) = $line =~ m%(http[^\:]?\:\/\/[^\s]+)%;
		print STDOUT "$URL\n";
	}
}
close(LIST);

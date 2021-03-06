######
# Extract URLs from a txt file
#
#  Parameters
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:F:',\%opt));

my $file = $opt{'f'};
my $filter = $opt{'F'};


open(LIST, $file) or die ('cannot open input '.$file);

while(my $line = <LIST>){
	if ($line =~ m%http[^\:]?\:\/\/[^\s]+% and $line =~ m%$filter%){
		my ($URL) = $line =~ m%href\=\s?(http[^\:]?\:\/\/[^\"]+)%;
		($URL) = $line =~ m%(http[^\:]?\:\/\/[^\"]+)% if ($URL eq '');
		($URL) = $line =~ m%(http[^\:]?\:\/\/[^\s]+)% if ($URL eq '');
		#$URL =~ s%"%%gi;
		#$URL =~ s%'%%gi;
		print STDOUT "$URL\n";
	}
}
close(LIST);

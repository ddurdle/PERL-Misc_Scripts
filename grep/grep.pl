######
# For each entry in the list (-f), grep for the data indicated
#  Parameters
#  -f file containing data
#  -1 start grep to find against data
#  -2 end grep to find against data
#    command to run: <1><f><2>
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:1:2:',\%opt));

my $file = $opt{'f'};
my $grepStart = $opt{'1'};
my $grepEnd = $opt{'2'};

open(LIST, './'.$file) or die ('cannot open input'.$file);

while(my $line = <LIST>){
	$line =~ s%\n%%;
	my ($value) = $line =~ m%\Q$grepStart\E(.*)\Q$grepEnd\E%;
	print STDOUT $value . "\n" if $value ne '';
}
close(LIST);

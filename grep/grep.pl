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

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');

}

while(my $line = <LIST>){
	my $value;
	if ($grepEnd ne ''){
		$line =~ s%\n%%;
		($value) = $line =~ m%\Q$grepStart\E(.*?)\Q$grepEnd\E%;
	}else{
		($value) = $line =~ m%\Q$grepStart\E(.*?)\n%;
	}
	print STDOUT $value . "\n" if $value ne '';
}
close(LIST);

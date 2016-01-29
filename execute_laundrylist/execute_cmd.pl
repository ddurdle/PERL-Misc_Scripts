######
# For each entry in the laundry list (-f), execute the command (-c)
#  Parameters
#  -f file containing data
#  -1 start command to run against data
#  -2 end command to run against data
#    command to run: <1><f><2>
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:1:2:',\%opt));

my $file = $opt{'f'};
my $commandStart = $opt{'1'};
my $commandEnd = $opt{'2'};


open(LIST, './'.$file) or die ('cannot open input'.$file);

while(my $line = <LIST>){
	$line =~ s%\n%%;
	#$output = `$commandStart$line$commandEnd`;
	system "$commandStart$line$commandEnd";
	#print STDOUT $output . "\perl n";
}
close(LIST);

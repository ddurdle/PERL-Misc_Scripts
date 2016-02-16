######
# Extract data into a table
#  Parameters
#  -f file containing data
#  -1 start grep to find against data
#  -2 end grep to find against data
#    command to run: <1><f><2>
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:1:2:3:4:',\%opt));

my $file = $opt{'f'};
my $grep1Start = $opt{'1'};
my $grep1End = $opt{'2'};
my $grep2Start = $opt{'3'};
my $grep2End = $opt{'4'};


if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');

}

while(my $line = <LIST>){
	$line =~ s%\n%%;
	my ($value1, $value2) = $line =~ m%\Q$grep1Start\E(.*)\Q$grep1End\E.*\Q$grep2Start\E([^\Q$grep2End\E]+)\Q$grep2End\E%;
	print STDOUT $value1 . "\t" .$value2 . "\n" if $value1 ne '';
}
close(LIST);

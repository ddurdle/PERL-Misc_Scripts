######
# Output over each loop iteration
#  Parameters
#  -1 start iteration
#  -2 end iteration
#  -i input (containing #i to be replaced by iteration value)
# for example -i test#i -1 0 -2 2 will output:
#	test1
# 	test2
#	test3
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('i:1:2:',\%opt));

my $input = $opt{'i'};
my $start = $opt{'1'};
my $end = $opt{'2'};

for (my $i=$start;$i <= $end;$i++){
	my $output = $input;
	$output =~ s%\#i%$i%;
	print STDOUT $output . "\n";
}


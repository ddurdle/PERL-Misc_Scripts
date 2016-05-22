######
# Output over each loop iteration
#  Parameters
#  -1 start iteration
#  -2 end iteration
#  -i input (containing #i to be replaced by iteration value)
#  -c run as a command
#  -r reverse increment
# for example -i test#i -1 0 -2 2 will output:
#	test1
# 	test2
#	test3
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('i:1:2:cr',\%opt));

my $input = $opt{'i'};
my $start = $opt{'1'};
my $end = $opt{'2'};

my $isCommand=0;
$isCommand =1 if $opt{'c'};

for (my $i=$start;$i <= $end;){
	my $output = $input;
	$output =~ s%\#i%$i%;
	if ($isCommand){
		print STDOUT `$output`;
	}else{
		print STDOUT $output . "\n";
	}
	if (defined $opt{r}){
		$i--;
	}else{
		$i++;
	}
}


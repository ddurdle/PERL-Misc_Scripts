######
# load into 2 dimensional array,return max value
#  Parameters
#  -f file containing data
#  ###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:',\%opt));

my $file = $opt{'f'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');

}

my @lines;
while(my $line = <LIST>){
	$line =~ s%\n%%;
	push(@lines, $line);
}
close(LIST);

my $maxValue=0;
my $maxIndex=0;
for(my$i=($#lines+1)/2; $i <= $#lines; $i++){
	my $currentValue = $lines[$i];
	$currentValue =~ s%\D%%g;
	if ($currentValue > $maxValue){
		$maxIndex = $i/2;
		$maxValue = $currentValue;
	}

}
print STDOUT $lines[$maxIndex];
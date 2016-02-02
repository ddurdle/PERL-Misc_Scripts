######
# For each entry in the laundry list (-f), pipe the line into the command (-c)
#  Parameters
#  -f file containing data
#  -c command to run against data
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:c:',\%opt));

my $file = $opt{'f'};
my $command = $opt{'c'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	$line =~ s%\n%%;
	system  "echo \"$line\" | $command";
}
close(LIST);

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
die (USAGE) unless (getopts ('f:c:',\%opt));

my $file = $opt{'f'};
my $command = $opt{'c'};


if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	my ($entry1, $entry2) = $line =~ m%([^\t]+)\t([^\n]+)\n%;
	my $cmdline = $command;
	$cmdline =~ s/%1%/${entry1}/;
	$cmdline =~ s/%2%/${entry2}/;
	print "$cmdline \n";
	#system "$commandStart$line$commandEnd";
	#print STDOUT $output . "\perl n";
}
close(LIST);

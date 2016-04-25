######
# Save each line as a column in a table
#  Parameters
#  -f file containing data
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:',\%opt));

my $file = $opt{'f'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');

}

my $previous='';
while(my $line = <LIST>){
	$line =~ s%\n%%;
	if ($previous ne ''){
		print STDOUT "\t";
	}
	print STDOUT $line;
	$previous = $line;
}
close(LIST);
print STDOUT "\n";

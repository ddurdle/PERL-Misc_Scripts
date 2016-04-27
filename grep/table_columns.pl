######
# Save each line as a column in a table
#  Parameters
#  -f file containing data
#  -c count before new row
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:c:',\%opt));

my $file = $opt{'f'};
my $countNewLine = $opt{'c'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');

}

my $count=1;
while(my $line = <LIST>){
	$line =~ s%\n%%;
	print STDOUT $line;
	if ($count < $countNewLine){
		print STDOUT "\t";
		$count++;
	}elsif ($count == $countNewLine){
		$count=1;
		print STDOUT "\n";

	}

}
close(LIST);
print STDOUT "\n";

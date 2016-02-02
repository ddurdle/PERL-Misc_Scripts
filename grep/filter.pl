######
# Filter out -F from file -f
#  Parameters
#  -f file containing data
#  -F to filter out
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:F:',\%opt));

my $file = $opt{'f'};
my $filter = $opt{'F'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	$line =~ s%\Q$filter\E%%g;
	print STDOUT $line;

}
close(LIST);

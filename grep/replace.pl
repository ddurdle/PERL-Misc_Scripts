######
# String replacement
#  Parameters
#  -g string to look for
#  -r replacement string
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:g:r:',\%opt));

my $filter = $opt{'g'};
my $file = $opt{'f'};

my $replacement = $opt{'r'};#quotemeta $opt{'F'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	$line =~ s%$filter%$replacement%g;
	print STDOUT $line;

}
close(LIST);

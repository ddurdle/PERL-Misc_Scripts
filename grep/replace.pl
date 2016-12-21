######
# String replacement
#
#  Parameters
#  -g string to look for
#  -r replacement string
#  -R replacement end of string
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:g:r:R:',\%opt));

my $filter = $opt{'g'};
#my $filterEnd = $opt{'G'};
my $file = $opt{'f'};

my $replacement = $opt{'r'};#quotemeta $opt{'r'};
my $replacementEnd = $opt{'R'};#quotemeta $opt{'r'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	$line =~ s%$filter%$replacement.($1<10?'0'.$1:$1).$replacementEnd%ge;
	print STDOUT $line;

}
close(LIST);

######
# Transform a string if criteria matches, otherwise echo value back
#  Parameters
#  -c string to look for
#  -r additional start of  string
#  -R additional end of string
#  -n reverse logic
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:c:r:R:n',\%opt));

my $criteria = $opt{'c'};
#my $filterEnd = $opt{'G'};
my $file = $opt{'f'};

my $transformStart = $opt{'r'};#quotemeta $opt{'r'};
my $transformEnd = $opt{'R'};#quotemeta $opt{'r'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

while(my $line = <LIST>){
	if (($opt{'n'} and not $line =~ m%$criteria%) or  $line =~ m%$criteria%){
		$line = $transformStart. $line .$transformEnd;
	}
	print STDOUT $line;

}
close(LIST);

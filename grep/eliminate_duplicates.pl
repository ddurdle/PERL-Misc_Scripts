######
# Replace lines regarded as a duplicate

#  Parameters
#  -g string to look for

###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('g:f:',\%opt));

my $filter = $opt{'g'};

my $file = $opt{'f'};

my $replacement = $opt{'r'};#quotemeta $opt{'r'};
my $replacementEnd = $opt{'R'};#quotemeta $opt{'r'};

if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

my %hash;


while(my $line = <LIST>){
	if ($line =~ m%$filter%){
		my ($item) = $line =~ m%($filter)%;
		if ($hash{$item} != 1){
			print STDOUT $line;
			$hash{$item} = 1;
		}
	}


}
close(LIST);

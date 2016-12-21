######
# For each entry in the laundry list of columns (-f), execute the command (-c)
#
#  Parameters
#  -f file containing data
#  -c command to run with %#% substitued by columns from table
#  (-t trim leading+trailing white spaces)
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:c:t',\%opt));

my $file = $opt{'f'};
my $command = $opt{'c'};
my $doTrim = $opt{'t'};


if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}


while(my $line = <LIST>){
	my @entryA;
	while (my ($entry) = $line =~ m%(^[^\t]*)\t%){
		$line =~ s%^[^\t]*\t%%;
		if ($doTrim){
			$entry =~ s%^\s+%%;
			$entry =~ s%\s+$%%;
		}
		push @entryA,$entry;
		#print $entryA[$#entryA];

	}
	while (my ($entry) = $line =~ m%(^[^\n]*)\n%){
		$line =~ s%^[^\n]*\n%%;
		if ($doTrim){
			$entry =~ s%^\s+%%;
			$entry =~ s%\s+$%%;
		}

		push @entryA,$entry;
		#print $entryA[$#entryA];
	}
	#print "\n";
	my $commandA = $command;
	while (my ($entry) = $commandA =~ m/\%(\d+)\%/){
		$commandA =~ s/\%$entry\%/$entryA[$entry-1]/g;
	}
	print $commandA . "\n";

}
close(LIST);

######
# String replacement, recursive replacement
#
#  Parameters
#  -g string to look for
#  -r replacement string
#  -d directory
###

use Getopt::Std;		# and the getopt module
use File::Copy;

my %opt;
die (USAGE) unless (getopts ('d:g:r:',\%opt));

my $filter = $opt{'g'};
my $directory = $opt{'d'};

my $replacement = $opt{'r'};#quotemeta $opt{'r'};
my $dirs = [];
push(@dirs,$directory);

for (my $i=0; $i <=$#dirs; $i++){

print "scanning $dirs[$i]\n";
opendir (DIR, $dirs[$i]) or die $!;

while (my $file = readdir(DIR)) {

	$fileWithPath = $dirs[$i] . '/'. $file;
	if (-e  $fileWithPath and -f $fileWithPath){
		print "file $fileWithPath\n";
		my $changeFile=0;
		open (FILE, $fileWithPath);
		while(my $line = <FILE>){
			if 	($line =~ m%$filter%){
				$changeFile = 1;
				last;
			}#$replacement%ge;
		#	print STDOUT $line;

		}
		close(FILE);
		if ($changeFile){
			move($fileWithPath, $fileWithPath.$$);
			open (FILE, $fileWithPath.$$);
			open (FILEWRITE, '>'.$fileWithPath);
			while(my $line = <FILE>){
				$line =~ s%$filter%$replacement%ge;
				print FILEWRITE $line;
			}
			close(FILEWRITE);
			close(FILE);
			unlink $fileWithPath.$$;

		}

	}elsif (-e $fileWithPath and -d $fileWithPath and $file ne '.' and $file ne '..'){
		print "directory $fileWithPath\n";
		push(@dirs,$fileWithPath);
	}

}

closedir(DIR);
}

#close(LIST);

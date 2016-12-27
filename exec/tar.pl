######
# For the provided directory, if size is > -m size, split archive, otherwise archive
#  Parameters
#  -d directory
#  -m size
#  -c do compression
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('d:s:c',\%opt));

my $directory = $opt{'d'};
my $splitsize = $opt{'s'};
my $doCompression;
if ($opt{'c'}){
	$doCompression = 1;
}



my $size = 0;

if ($splitsize > 0){
	for my $filename (glob("$directory/*")) {
	    next unless -f $filename;
	    $size += -s _;
	}

}

if ($size > $splitsize){
	if ($doCompression){
		system "tar cvzf - $directory/ | split --bytes=$splitsize - $directory.tgz. ";

	}else{
		system "tar vzf - $directory/ | split --bytes=$splitsize - $directory.tar. ";
	}

}else{
	if ($doCompression){
		system "tar cvzf $directory.tgz $directory";

	}else{
		system "tar vzf $directory.tar $directory";
	}


}

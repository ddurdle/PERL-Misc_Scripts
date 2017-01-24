######
# For the provided directory, if size is > -m size, split archive, otherwise archive
#  Parameters
#  -d directory
#  -m size
#  -c do compression
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:d:s:c',\%opt));

my $directory = $opt{'d'};
my $filename = $opt{'f'};

my $splitsize = $opt{'s'};
my $doCompression;
if ($opt{'c'}){
	$doCompression = 1;
}

if ($filename eq ''){
	$filename = $directory;

}


my $size = 0;

if ($splitsize > 0){
	use File::Find;
	find( sub { $size += -f $_ ? -s _ : 0 }, "./$directory" );

}

#contains space
if ($directory =~ m%\s%){
	$directory = '"' . $directory . '"';

}

if ($size > $splitsize){
	if ($doCompression){
		system "tar cvzf - $directory/ | split --bytes=$splitsize - \"$filename.tgz.\" ";

	}else{
		system "tar cvf - $directory/ | split --bytes=$splitsize - \"$filename.tar.\" ";
	}

}else{
	if ($doCompression){
		system "tar cvzf \"$filename.tgz\" $directory";

	}else{
		system "tar cvf \"$filename.tar\" $directory";
	}


}

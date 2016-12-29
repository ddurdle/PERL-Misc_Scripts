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
	use File::Find;
	find( sub { $size += -f $_ ? -s _ : 0 }, shift(@ARGV) );

}

if ($size > $splitsize){
	if ($doCompression){
		system "tar cvzf - \"$directory/\" | split --bytes=$splitsize - \"$directory.tgz.\" ";

	}else{
		system "tar cvf - \"$directory/\" | split --bytes=$splitsize - \"$directory.tar.\" ";
	}

}else{
	if ($doCompression){
		system "tar cvzf \"$directory.tgz\" \"$directory\"";

	}else{
		system "tar cvf \"$directory.tar\" \"$directory\"";
	}


}

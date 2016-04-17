######
# Generate a unique, non-existing filename
#  Parameters
#  -f filename
#    parse YYYYMMDD
#    parse %1% -- unique identifier
#  -d directory to check
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('f:d:',\%opt));

my $filename = $opt{'f'};
my $directory;
if (exists($opt{'d'})){
	$directory = $opt{'d'};
}else{$directory = '.'};


my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year += 1900;
$mon += 1;
$mon = '0' . $mon if $mon < 10;
$mday = '0' . $mday if $mday < 10;
$filename =~ s/YYYYMMDD/$year$mon$mday/;
$count=1;
my $newfilename;
do{
	$newfilename = $filename;
	$newfilename =~ s/%1%/$count/g;
	$count++;
}while (-e $directory . '/'.$newfilename);
print 'unique filename = '.$newfilename. "\n";

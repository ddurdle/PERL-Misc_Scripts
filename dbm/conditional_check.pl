######
# For each entry in the laundry list (-f), execute the command (-c), conditional based on value on each line of input file
# - if column %1% value is not in dbm, execute and add %1 to dbm (if executed command returns non-failure), otherwise do not execute
#  Parameters
#  -f file containing data
#  -c command to run
###

use Fcntl;
use DB_File;

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('d:v:c:',\%opt));

my $value = $opt{'v'};
my $dbm = $opt{'d'};
my $command = $opt{'c'};


tie( my %dbase, DB_File, $opt{d} ,O_CREAT|O_RDWR, 0666) or die "can't open ". $opt{d}.": $!";

if ($dbase{$value} != 1){
	print "$command \n";
	my $ret = system "$command";
	print $ret;
	#don't count if command fails
	if ($ret ne '-1'){
		$dbase{$value} = 1;
	}
}else{
	print "skip $entry1\n";
}



untie %dbase;

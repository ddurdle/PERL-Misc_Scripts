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
die (USAGE) unless (getopts ('d:f:c:i',\%opt));

my $file = $opt{'f'};
my $dbm = $opt{'d'};
my $command = $opt{'c'};


if ($file ne ''){
	open(LIST, $file) or die ('cannot open input '.$file);
}else{
	open(LIST, '<-') or die ('cannot open STDIN');
}

tie( my %dbase, DB_File, $opt{d} ,O_CREAT|O_RDWR, 0666) or die "can't open ". $opt{d}.": $!";

while(my $line = <LIST>){
	my ($entry1) = $line =~ m%([^\n]+)\n%;
	my $cmdline = $command;
	if ($opt{i} or $dbase{$entry1} != 1){
		$cmdline =~ s/%1%/${entry1}/g;
		print "$cmdline \n";
		my $ret = system "$cmdline";
		print $ret;
		#don't count if command fails
		if ($ret ne '-1'){
			$dbase{$entry1} = 1;
		}
	}else{
		print "skip $entry1\n";
	}

}
close(LIST);

untie %dbase;

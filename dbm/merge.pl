
##
#
# This script is used to merge two dbm files.
# -1 dbm file (such as gd.uername.md5.db)
# -2 dbm file (such as gd.uername.md5.db)
# -3 new dbm file (such as gd.uername.md5.db)
###

use strict;


use Getopt::Std;
use constant USAGE => " usage: $0 [-1 dbm] [-2 dbm] [-3 dbm]\n";

my %opt;
die (USAGE) unless (getopts ('1:2:3:',\%opt));

die(USAGE) if $opt{1} eq '' or  $opt{2} eq '';

my $dbm_file1 = $opt{1};
my $dbm_file2 = $opt{2};
my $dbm_file3 = $opt{3};


&DBM::init($dbm_file1, $dbm_file2, $dbm_file3);


&DBM::merge();

{
package DBM;

use DB_File;
use Fcntl;

use strict;

my $dbm1;
my $dbm2;
my $dbm3;


sub init($$$$){


	$dbm1 = shift;
	$dbm2 = shift;
	$dbm3 = shift;

}




sub merge(){


	tie(my %dbase2, 'DB_File', $dbm2) or die "can't open $dbm2: $!";
	my %db;
	foreach my $key (keys %dbase2) {
		$db{$key} = $dbase2{$key};
	}
	untie(%dbase2);
	tie(my %dbase1, 'DB_File', $dbm1) or die "can't open $dbm1: $!";
	my $countAdded=0;
	my $countSkipped=0;
	my %changes;
	#while(my ($key, $record) = each %db){
  	foreach my $key (keys %db) {
  	#foreach my $key (keys %dbase2) {
    	if ($dbase1{$key} eq $db{$key}){
			$countSkipped++;
		#print STDERR 'key ' . $key . ' ' .$dbase1{$key}." ". $dbase2{$key}."\n";

    	}else{
    		#$dbase1{$key} = $db{$key};
			#$dbase1{$key} =  $dbase2{$key};
			print STDERR 'key ' . $key . ' ' .$dbase1{$key}." ". $db{$key}."\n";
			$changes{$key} = $db{key};
			$countAdded++;
    	}
  	}
	#untie(%dbase2);
	#untie(%dbase1);
	tie(my %dbase3, 'DB_File', $dbm3, O_CREAT|O_RDWR, 0644) or die "can't open $dbm1: $!";

  	foreach my $key (keys %changes) {
  		$dbase3{$key} = $changes{$key};
  	}

  	foreach my $key (keys %dbase1) {
  		$dbase3{$key} = $dbase1{$key};
  	}
	untie(%dbase3);
	untie(%dbase1);

	print STDERR "$dbm1 $dbm2 $dbm3 added = $countAdded, skipped = $countSkipped\n";
}



1;

}

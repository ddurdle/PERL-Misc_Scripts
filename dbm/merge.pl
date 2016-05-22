
##
#
# This script is used to merge two dbm files.
# -1 dbm file (such as gd.uername.md5.db)
# -2 dbm file (such as gd.uername.md5.db)
#
###

use strict;


use Getopt::Std;
use constant USAGE => " usage: $0 [-1 dbm] [-2 dbm]\n";

my %opt;
die (USAGE) unless (getopts ('1:2:',\%opt));

die(USAGE) if $opt{1} eq '' or  $opt{2};

my $dbm_file1 = $opt{1};
my $dbm_file2 = $opt{2};


&DBM::init($dbm_file);


&DBM::updateDBHash($opt{k},$opt{v});

{
package DBM;

use DB_File;
use Fcntl;

use strict;

my $dbm1;
my $dbm2;
my %dbase1;
my %dbase2;

sub init($$){

	$dbm1 = shift;
	$dbm2 = shift;

}




sub merge($$){


	tie(%dbase1, 'DB_File', $dbm1,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";
	tie(%dbase2, 'DB_File', $dbm2,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";

	$dbase{$key} = $value;
	print "$key: $dbase{$key}\n";

	untie(%dbase1);
	untie(%dbase2);

}



1;

}
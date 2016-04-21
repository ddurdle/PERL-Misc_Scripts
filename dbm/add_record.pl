
##
#
# This script is used to debug a dbm file.
# -d dbm file (such as -d gd.uername.md5.db)
# optional:
#  -p   -- prints dbm contents
#  -c  -- count the number of enteries
#
###




use strict;

use constant DEBUG => 0;
use constant DEBUG_LOG => 'debug.log';



use Getopt::Std;
use constant USAGE => " usage: $0 [-d dbm] -k key -v value\n";

my %opt;
die (USAGE) unless (getopts ('d:k:v:',\%opt));

die(USAGE) if $opt{d} eq '' or ($opt{v} eq '' or $opt{k} eq '');

my $dbm_file = $opt{d};


&DBM::init($dbm_file);


&DBM::updateDBHash($opt{k},$opt{v});

{
package DBM;

use DB_File;
use Fcntl;

use strict;

my $dbm;
my %dbase;
sub init($){

 $dbm = shift;

}




sub updateDBHash($$){

	my $key = shift;
	my $value = shift;

	tie(%dbase, 'DB_File', $dbm,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";

	$dbase{$key} = $value;
	print "$key: $dbase{$key}\n";

	untie(%dbase);

}



1;

}
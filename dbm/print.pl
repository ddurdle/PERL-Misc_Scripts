
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
use constant USAGE => " usage: $0 [-d dbm] [-p] [-c]\n";

my %opt;
die (USAGE) unless (getopts ('d:pc',\%opt));

die(USAGE) if $opt{d} eq '' or (not defined ($opt{p}) and not defined ($opt{c}));

my $dbm_file = $opt{d};

&DBM::init($dbm_file);

if ($opt{p}){
	&DBM::printDBHash();
}elsif ($opt{c}){
	&DBM::countDBHash();
}

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




sub printDBHash(){

  print "Database $dbm consists of the following key value pairs...\n";



  tie(%dbase, 'DB_File', $dbm,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";

  foreach my $key (keys %dbase) {
    print "$key: $dbase{$key}\n";
  }


  untie(%dbase);

}



sub countDBHash(){

  print "Database $dbm contains this count...\n";


  tie(%dbase, 'DB_File', $dbm,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";

  my $count = 0;
  foreach my $key (keys %dbase) {
    $count++;
  }

  untie(%dbase);

  print "Number of enteries = " . $count ."\n";

}

1;

}
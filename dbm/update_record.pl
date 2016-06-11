
##
#
# This script is used to update all records in a dbm file.
# -d dbm file (such as -d gd.uername.md5.db)
# optional:
#  -v value
#
###




use strict;

use constant DEBUG => 0;
use constant DEBUG_LOG => 'debug.log';



use Getopt::Std;
use constant USAGE => " usage: $0 [-d dbm] [-v value]\n";

my %opt;
die (USAGE) unless (getopts ('d:v:',\%opt));

die(USAGE) if $opt{d} eq '' or $opt{v} eq '';

my $dbm_file = $opt{d};

&DBM::init($dbm_file);

&DBM::updateDBHash();


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




sub updateDBHash(){

  print "Database $dbm consists of the following key value pairs...\n";



  tie(%dbase, 'DB_File', $dbm,O_RDWR|O_CREAT, 0666) or die "can't open $dbm: $!";

  foreach my $key (keys %dbase) {
     $dbase{$key} = $opt{v};
  }


  untie(%dbase);

}



1;

}

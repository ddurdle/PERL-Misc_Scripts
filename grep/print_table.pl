######
# Extract data into a table
#
#  Parameters
#  -f file containing data
#  -1 start grep to find against data
#  -2 end grep to find against data
#    command to run: <1><f><2>
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('1:2:',\%opt));

my $value1 = $opt{'1'};
my $value2 = $opt{'2'};

print STDOUT $value1 . "\t" .$value2 . "\n";

######
# Validate the output of an execution, looking for particular criteria
#  Parameters
#  -c command to run
#  -s success criteria
#  -f failure criteria
#  -r (retry on failure)
###

use Getopt::Std;		# and the getopt module

my %opt;
die (USAGE) unless (getopts ('c:s:rf:',\%opt));

my $command = $opt{'c'};
my $success = $opt{'s'};
my $failure = $opt{'f'};
my $isRetry = $opt{'r'};

while(1){
	my $ret = `$command`;
	if ($success ne '' and $ret =~ m%\Q$success\E%){
		return 0;
		last;
	}elsif ($failure ne '' and $ret =~ m%\Q$failure\E%){
		return 1;
	}elsif ($failure ne '' and $success eq '' ){
		return 1;
		last;
	}else{
		print 'output = '.$ret;
		return 0;
		last;
	}
}


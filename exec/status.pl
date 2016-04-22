######
# Validate the output of an execution, looking for particular criteria
#  Parameters
#  -c command to run
#  -s success criteria
#  -f failure criteria
#  -r count

###

use Getopt::Std;		# and the getopt module
use constant USAGE => '';
my %opt;
die (USAGE) unless (getopts ('c:s:r:f:S:F:',\%opt));

my $command = $opt{'c'};
my $success = $opt{'s'};
my $failure = $opt{'f'};
my $retryCount = $opt{'r'};
my $failureCmd = $opt{'F'};
my $successCmd = $opt{'S'};

my $isFailure=0;
for (my$i=0;$i<= $retryCount; $i++){
	my $ret = `$command`;
	if ($success ne '' and $ret =~ m%\Q$success\E%){
		$isFailure=0;
		last;
	}elsif ($failure ne '' and $ret =~ m%\Q$failure\E%){
		$isFailure=1;
	}elsif ($failure ne '' and $success eq '' ){
		$isFailure=0;
		last;
	}else{
		print 'output = '.$ret;
		$isFailure=0;
	}
}
if ($isFailure){
	`$failureCmd`;
}else{
	`$successCmd`;
}


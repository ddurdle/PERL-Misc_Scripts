#!/usr/bin/perl

use File::Copy qw(move);

use constant RETRY => 10;


sub createArglist(){
	my $arglist = '';
	foreach my $current (0 .. $#ARGV) {
		if ($ARGV[$current] =~ m%\s%){
	   	$arglist .= ' "' .$ARGV[$current] . '"';
		}else{$arglist .= ' ' .$ARGV[$current];}
	}
	return $arglist;

}

my $start = time;
my $duration = 0;
my $duration_ptr = -1;
my $arglist = '';
my $filename_ptr = 0;
my $count = 1;
my $renameFileName = '';
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
	}elsif ($ARGV[$current] =~ m%\.ts%){
		$filename_ptr = $current;
		#$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;

	}
	if ($ARGV[$current] =~ m%\s%){
   	$arglist .= ' "' .$ARGV[$current] . '"';
	}else{$arglist .= ' ' .$ARGV[$current];}
}

#run only once? -- enable retry
if ($duration_ptr == -1){
	my $retry=1;
	while ($retry< RETRY and $retry > 0){

		my $output = `/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error 2>&1`;
		if($output ne ''){
			print STDERR "ERROR";
			print STDERR $output;
			print STDERR 'run /u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' . $arglist . "\n";
			sleep 1;
			$retry++;
		}else{
			$retry = 0;
		}
	}
#running wit duration? -- keep retrying and adjusting duration
}else{
	$ARGV[$filename_ptr] =~ s%\.ts%\.$count\.ts%;
	while (-e $ARGV[$filename_ptr]){
		$count++;
		$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
	}
	$renameFileName = $ARGV[$filename_ptr];
	$renameFileName =~ s%\.ts%\.mp4%;

	my $now = 60;
	while ($now > 59){
	  	$arglist = createArglist();
		print STDERR 'run /u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' . $arglist . "\n";
		`/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error`;
		move $ARGV[$filename_ptr], $renameFileName;
		print STDERR "move $ARGV[$filename_ptr], $renameFileName\n";
		$now = ($start + $duration + 5) - time ;

		my $hour = int($now /60/60);
	    my $min = int ($now /60%60);
		my $sec = int ($now %60);
		$ARGV[$duration_ptr] = ($hour<10? '0':'').$hour.":".($min <10? '0':'').$min.':' . ($sec<10?'0':'').$sec;
		$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
		while (-e $ARGV[$filename_ptr]){
			$count++;
			$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
			$renameFileName = $ARGV[$filename_ptr];
			$renameFileName =~ s%\.ts%\.mp4%;
		}
		print STDERR "time " .$now;
	}
}



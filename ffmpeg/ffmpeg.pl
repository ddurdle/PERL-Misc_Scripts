#!/usr/bin/perl

use File::Copy qw(move);

use constant RETRY => 10;
my $pidi=0;

$SIG{QUIT} = sub {  kill 'KILL', $pid;die "Caught a quit $pid $!"; };
$SIG{TERM} = sub {  kill 'KILL', $pid;die "Caught a term $pid $!"; };
$SIG{INT} = sub {  kill 'KILL', $pid;die "Caught a int $pid $!"; };
$SIG{HUP} = sub {  kill 'KILL', $pid;die "Caught a hup $pid $!"; };
$SIG{ABRT} = sub {  kill 'KILL', $pid;die "Caught a abrt $pid $!"; };
$SIG{TRAP} = sub {  kill 'KILL', $pid;die "Caught a trap $pid $!"; };
$SIG{STOP} = sub {  kill 'KILL', $pid;die "Caught a stop $pid $!"; };


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
my $isSRT = 0;
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
	}elsif ($ARGV[$current] =~ m%\.ts%){
		$filename_ptr = $current;
		#$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
	}elsif ($ARGV[$current] =~ m%\.srt%){
		$isSRT = 1;
	}
	if ($ARGV[$current] =~ m%\s%){
   	$arglist .= ' "' .$ARGV[$current] . '"';
	}else{$arglist .= ' ' .$ARGV[$current];}
}

if ($isSRT){
	`/opt/emby-server/bin/ffmpeg.x $arglist`;
#run only once? -- enable retry
}elsif ($duration_ptr == -1){
	my $retry=1;
	while ($retry< RETRY and $retry > 0){
		#my $result = 'x';
		#print "running " . '/u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' + $arglist
		$pid = open ( LS, '-|', '/u01/ffmpeg-git-20171123-64bit-static/ffmpeg  2>&1' . $arglist);
		my $output = do{ local $/; <LS> };
		#print "pid = $pid\n";
		close LS;
		#my $output = `/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error 2>&1`;
		if($output ne ''){
			print STDERR "ERROR";
			print STDERR $output;
			print STDERR 'retry /u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' . $arglist . "\n";
			sleep 2;
			$retry++;
		}else{
			$retry = 0;
		}
	}
#running wit duration? -- keep retrying and adjusting duration
}else{

	my @moveList;
	my $current=0;
	$ARGV[$filename_ptr] =~ s%\.ts%\.$count\.ts%;
	while (-e $ARGV[$filename_ptr]){
		$count++;
		$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
	}
	$renameFileName = $ARGV[$filename_ptr];
	$renameFileName =~ s%\.ts%\.mp4%;

	my $now = 60;
	my $failures=0;
	while ($now > 59 and $failures < 100){
	  	$arglist = createArglist();
		print STDERR 'run /u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' . $arglist . "\n";
		`/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error`;
		$moveList[$current][0] = $ARGV[$filename_ptr];
		$moveList[$current++][1] = $renameFileName;
		#move $ARGV[$filename_ptr], $renameFileName;
		print STDERR "move $ARGV[$filename_ptr], $renameFileName\n";
		$now = ($start + $duration + 5) - time ;
		if ($now > 59){
			sleep 5;
			$failures++;
		}
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

	for (my $i=0; $i <= $#moveList; $i++){
		move $moveList[$i][0], $moveList[$i][1];

	}
}



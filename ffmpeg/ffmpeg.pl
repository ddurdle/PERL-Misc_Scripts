#!/usr/bin/perl

use File::Copy qw(move);

use constant RETRY => 10;
use constant BLOCK_SRT => 1;
use constant BLOCK_TRANSCODE => 1;
use constant GOOGLE_TRANSCODE => 1;


my $pidi=0;

$SIG{QUIT} = sub {  kill 'KILL', $pid;die "Caught a quit $pid $!"; };
$SIG{TERM} = sub {  kill 'KILL', $pid;die "Caught a term $pid $!"; };
$SIG{INT} = sub {  kill 'KILL', $pid;die "Caught a int $pid $!"; };
$SIG{HUP} = sub {  kill 'KILL', $pid;die "Caught a hup $pid $!"; };
$SIG{ABRT} = sub {  kill 'KILL', $pid;die "Caught a abrt $pid $!"; };
$SIG{TRAP} = sub {  kill 'KILL', $pid;die "Caught a trap $pid $!"; };
$SIG{STOP} = sub {  kill 'KILL', $pid;die "Caught a stop $pid $!"; };

my $FFMPEG = '/u01/ffmpeg-git-20171123-64bit-static/ffmpeg -timeout 5000000 ';
my $FFMPEG_OEM = '/opt/emby-server/bin/ffmpeg.oem -timeout 5000000 ';
my $FFPROBE = '/opt/emby-server/bin/ffprobe ';


sub createArglist(){
	my $arglist = '';
	foreach my $current (0 .. $#ARGV) {
		if ($ARGV[$current] =~ m%\s% or $ARGV[$current] =~ m%\(% or $ARGV[$current] =~ m%\)% or $ARGV[$current] =~ m%\&%){
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
my $url = '';
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
	}elsif ($ARGV[$current] =~ m%\:9988%){
		$url = $ARGV[$current];
	}elsif (0 and $ARGV[$current] =~ m%\-user_agent%){
		$ARGV[$current++] = '';
		$ARGV[$current] = '';
	}elsif (0 and $ARGV[$current] =~ m%\-fflags%){
		$ARGV[$current++] = '';
		$ARGV[$current] = '';
	}elsif (0 and $ARGV[$current] =~ m%\-f%){
		$ARGV[$current++] = '';
		$ARGV[$current] = '';
	}elsif ($ARGV[$current] =~ m%\.ts%){
		$filename_ptr = $current;
		#$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
	}elsif ($ARGV[$current] =~ m%\.srt%){
		$isSRT = 1;
	}
}
$arglist = createArglist();


# SRT loading only, load regular routine
if ($isSRT){
	if (BLOCK_SRT){
		die("SRT transcoding is disabled.");
	}else{
		print STDERR "running " . 'ffmpeg ' . $arglist . "\n";

		`$FFMPEG $arglist`;
	}
# is google drive, so must be wanting to transcode the video -- block
}elsif ($arglist =~ m%\:9988%){

	$pid = open ( LS, '-|', $FFPROBE . ' -i "' . $url . '" 2>&1');
	my $output = do{ local $/; <LS> };
	close LS;

	if (BLOCK_TRANSCODE and $output =~ m%hevc%){
		if (GOOGLE_TRANSCODE){
			$arglist =~ s%\"?\Q$url\E\"?%\"$url\&preferred_quality\=2\&override\=true\"%;
			print STDERR "URL = $url, $arglist\n";
			`$FFMPEG $arglist`;
		}else{
			die("video/audio transcoding is disabled.");
		}


	}else{
		`$FFMPEG_OEM $arglist`;
	}

#run only once? -- enable retry
}elsif ($duration_ptr == -1){
	my $retry=1;
	while ($retry< RETRY and $retry > 0){
		#my $result = 'x';
		print STDERR "running " . $FFMPEG_OEM . ' ' . $arglist . "\n";
		$pid = open ( LS, '-|', $FFMPEG_OEM . ' ' . $arglist . ' 2>&1');
		my $output = do{ local $/; <LS> };
		close LS;
		#my $output = `/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error 2>&1`;

		#retry if contains error 403
		if($output =~ m%403%){
			print STDERR "ERROR:";
			print STDERR $output;
			print STDERR 'retry ffmpeg ' . $arglist . "\n";
			sleep 2;
			$retry++;
		}else{
			print STDERR $output;
			print STDERR "\n\n\nDONE\n\n";
			$retry = 0;
		}
	}
#running with duration? -- keep retrying and adjusting duration
}elsif ($duration != 0){

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
		print STDERR 'run ffmpeg  -v error ' . $arglist . "\n";
		`$FFMPEG $arglist -v error`;
		#$pid = open ( LS, '-|', '/u01/ffmpeg-git-20171123-64bit-static/ffmpeg  -v error ' . $arglist . ' 2>&1');
		#my $output = do{ local $/; <LS> };
		#close LS;
		#print STDERR $output;

		# we will rename the file later
		$moveList[$current][0] = $ARGV[$filename_ptr];
		$moveList[$current++][1] = $renameFileName;

		# calculate the new duration -- add a failure to the counter and wait for 5 seconds to let the failure condition pass
		$now = ($start + $duration + 5) - time ;
		if ($now > 59){
			sleep 5;
			$failures++;
		}

		# print the duration in correct format
		my $hour = int($now /60/60);
	    my $min = int ($now /60%60);
		my $sec = int ($now %60);
		$ARGV[$duration_ptr] = ($hour<10? '0':'').$hour.":".($min <10? '0':'').$min.':' . ($sec<10?'0':'').$sec;

		# increment filename
		$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
		while (-e $ARGV[$filename_ptr]){
			$count++;
			$ARGV[$filename_ptr] =~ s%\.\d+\.ts%\.$count\.ts%;
			$renameFileName = $ARGV[$filename_ptr];
			$renameFileName =~ s%\.ts%\.mp4%;
		}
		print STDERR "next iteration " .$now . "\n";

	}

	for (my $i=0; $i <= $#moveList; $i++){
		move $moveList[$i][0], $moveList[$i][1];
		print STDERR "move $moveList[$i][0],$moveList[$i][1]\n";

	}
}



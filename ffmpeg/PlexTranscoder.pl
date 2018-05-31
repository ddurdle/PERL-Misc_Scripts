#!/usr/bin/perl

use File::Copy qw(move);

# number of times to retry when ffmpeg encounters network errors
use constant RETRY => 50;

# block subtitle remuxing?
use constant BLOCK_SRT => 1;

# block 4K video encoding requets
use constant BLOCK_TRANSCODE => 1;

# prefer to drop 4K to Google Transcode for 4k video encoding requests
use constant GOOGLE_TRANSCODE => 1;

# prefer to direct stream requests with Google Transcode feeds (will reduce CPU load)
use constant PREFER_GOOGLE_TRANSCODE => 1;

use constant PATH_TO_TRANSCODER => '"/usr/lib/plexmediaserver/Plex Transcoder.oem"';


my $pidi=0;

$SIG{QUIT} = sub {  kill 'KILL', $pid;die "Caught a quit $pid $!"; };
$SIG{TERM} = sub {  kill 'KILL', $pid;die "Caught a term $pid $!"; };
$SIG{INT} = sub {  kill 'KILL', $pid;die "Caught a int $pid $!"; };
$SIG{HUP} = sub {  kill 'KILL', $pid;die "Caught a hup $pid $!"; };
$SIG{ABRT} = sub {  kill 'KILL', $pid;die "Caught a abrt $pid $!"; };
$SIG{TRAP} = sub {  kill 'KILL', $pid;die "Caught a trap $pid $!"; };
$SIG{STOP} = sub {  kill 'KILL', $pid;die "Caught a stop $pid $!"; };

my $PATH_TO_TRANSCODER = PATH_TO_TRANSCODER;


sub createArglist(){
	my $arglist = '';
	foreach my $current (0 .. $#ARGV) {
		if ($ARGV[$current] =~ m%^\-% and !( $ARGV[$current] =~ m%exp%)){
	   		$arglist .= ' ' .$ARGV[$current];
		}else{
	   		$arglist .= ' "' .$ARGV[$current] . '"';
		}

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
	}elsif ($ARGV[$current] =~ m%^htt.*\:9988%){
		$url = $ARGV[$current];
	}elsif (0 and $ARGV[$current] =~ m%\-i%){
		$ARGV[$current++] = '';
		$ARGV[$current] = 'http://premium1.monkeydevices.com:9988/default.py?kv=1jlVj9dwEJIxmjWMA4v---AHT0OnG2UTMISmpWdyZjhHeP---I4Z8Me7POAhGs24mCnlxw---pXXsVJqwiUsRYOtcXO2xkr5siKvVDWzlYR61S1bQOP1pRFEqtFbjs+KrKhUWFoKECJtRLy675dNUYsRGwDxxCbRXscgaZFRUqM---4X2wevRl+JbHgdcVE5+DuakamDwelN+fpybX7s---eRI1NVZ3UBkV4bev9KjTO6Gd7MgdDz+J5sEC1vLdNa+eWkrq19vkowOuOYYNbJiGgKF68vGklo6+AkGB04GcMAvOZjG+uA=';
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


		print "$PATH_TO_TRANSCODER $arglist \n\n";
# request is for subtitle remuxing
		$pid = open ( LS, '-|', $PATH_TO_TRANSCODER . ' ' . $arglist . ' 2>&1');
		my $output = do{ local $/; <LS> };
		close LS;
		#my $output = `/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist -v error 2>&1`;
		print "OUTPUT".$output;
		# no transcoding available
		if($output =~ m%moov atom not found%){
			$arglist =~ s%\-f mp4 %\-f matroska,webm %;
			`$FFMPEG_OEM $arglist`;
		}






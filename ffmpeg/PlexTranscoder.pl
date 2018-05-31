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

use constant LOGFILE => '/tmp/transcode.log';

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
		#if ($ARGV[$current] =~ m%^\-% and !( $ARGV[$current] =~ m%exp%)){
	   	#	$arglist .= ' ' .$ARGV[$current];
		#}else{
	   	#	$arglist .= ' "' .$ARGV[$current] . '"';
		#}
		if ($ARGV[$current] =~ m%\s% or $ARGV[$current] =~ m%\(% or $ARGV[$current] =~ m%\)% or $ARGV[$current] =~ m%\&% or $ARGV[$current] =~ m%\[%){
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
my $replace=1;
my $video = '"http://premium1.monkeydevices.com:9988/play?count=2"';
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
	}elsif ($replace and  $ARGV[$current] =~ m%\-i%){
		$ARGV[$current++] = '-i';
		$ARGV[$current] = $video;
		$replace = 0;
	}
}
$arglist = createArglist();

open (LOG, '>>' . LOGFILE) or die $!;
print LOG "passed in $arglist\n";

$arglist =~ s%\-codec\:0 \S+%\-codec\:0 h264%;
$arglist =~ s%\-codec\:1 \S+%\-codec\:1 aac%;

if ($arglist =~ m% dash %){
	$arglist =~ s%\-i .* -f dash%\-i $video \-codec\:v\:0 copy \-copyts \-vsync \-1 \-codec\:a\:0 copy \-copypriorss\:a\:0 0 \-f dash%;

}elsif ($arglist =~ m%\-segment_format mpegts %){
	$arglist =~ s%\-i .* \-segment_format mpegts \-f ssegment%\-i $video \-codec\:v\:0 copy \-copyts \-vsync \-1 \-codec\:a\:0 copy \-copypriorss\:a\:0 0 \-segment_format mpegts \-f ssegment%;

}

print LOG "$PATH_TO_TRANSCODER $arglist\n\n";
close(LOG);
print "$PATH_TO_TRANSCODER $arglist \n\n";

`$PATH_TO_TRANSCODER $arglist`;





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
my $video = 'http://premium1.monkeydevices.com:9988/default.py?kv=1jlVj9dwEJIxmjWMA4v---AHT0OnG2UTMISmpWdyZjhHewxGUtLClxyG92GEg4sZ8AX2ZCaPJwEOmXa3Da57ejW99Z2MWzePSdAyBgRQ0ZGOg+e7vIrqX7V5kYCEeWMeVzE8DqZrtipfCLHSeJsJf+v9vEhg6nu7WefDoF2GRDokW9vLzY9CB5YtyiXaWGepeB97hILy---IxXJ---G38VSfUXRDL---4o7iJOrAa0pXRlhO3RcXW+t8A6NhiOJ875P2suTGrQXAU6TBgTphX4suflRKeNaYZSMy2o7v5m1QAh41aLRXMaF4YeIbsNNI5y8QNM6oJVIPmDgCtdpIhCxUdBPeVFcEMxGjsCViYCczVSGDNGNhp2DNXzqr5ql6I2mS5v28WMLm5Br3SBD8X8+gVeERgA==';
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


if (PREFER_GOOGLE_TRANSCODE){

	if ($arglist =~ m%scale\=w\=1280\:h\=720%){
		$video .= '&preferred_quality=1&override=true';
	}elsif ($arglist =~ m%scale\=w\=720\:h\=406%){
		$video .= '&preferred_quality=2&override=true';
	}elsif ($arglist =~ m%scale\=w\=1920\:h\=1080%){
		$video .= '&preferred_quality=0&override=true';
	}elsif ($arglist =~ m%scale\=w\=3840\:h\=2160%){
		$video .= '&preferred_quality=3&override=true';
	}else{
		$video .= '&preferred_quality=0&override=true';
	}
}
if ($arglist =~ m% dash %){
	$arglist =~ s%\-i .* -f dash%\-i "$video" \-codec\:v\:0 copy \-copyts \-vsync \-1 \-codec\:a\:0 copy \-copypriorss\:a\:0 0 \-f dash%;

}elsif ($arglist =~ m%\-segment_format mpegts %){
	$arglist =~ s%\-i .* \-segment_format mpegts \-f ssegment%\-i "$video" \-codec\:v\:0 copy \-copyts \-vsync \-1 \-codec\:a\:0 copy \-copypriorss\:a\:0 0 \-segment_format mpegts \-f ssegment%;

}

print LOG "$PATH_TO_TRANSCODER $arglist\n\n";
close(LOG);
print "$PATH_TO_TRANSCODER $arglist \n\n";

`$PATH_TO_TRANSCODER $arglist`;





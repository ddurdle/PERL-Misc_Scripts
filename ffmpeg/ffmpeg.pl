#!/usr/bin/perl
my $start = time;
my $duration = 0;
my $duration_ptr = 0;
my $arglist = '';
my $filename_ptr = 0;
my $count = 1;
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
	}elsif ($ARGV[$current] =~ m%\.ts%){
		$ARGV[$current] =~ s%\.ts%\.$count\.mp4%;
		$count++;
		$filename_ptr = $current;
	}
   $arglist .= ' ' .$ARGV[$current];
}
my $now = -1;
while ($now < 0){
	print STDERR 'run /u01/ffmpeg-git-20171123-64bit-static/ffmpeg ' . $arglist . "\n";
	`/u01/ffmpeg-git-20171123-64bit-static/ffmpeg $arglist`;
	$now = time - $start - $duration + 5;
	my $hour = int($duration /60/60);
    my $min = int ($duration /60%60);
	my $sec = int ($duration %60);
	$ARGV[$duration_ptr] = ($hour<10? '0':'').$hour.":".($min <10? '0':'').$min.':' . ($sec<10?'0':'').$sec;
	$ARGV[$filename_ptr] =~ s%\.\d+\.mp4%\.$count\.mp4%;
	$count++;
	$arglist = '';
	foreach my $current (0 .. $#ARGV) {
		if ($ARGV[$current] =~ m%\s%){
	   	$arglist .= ' "' .$ARGV[$current] . '"';
		}else{$arglist .= ' ' .$ARGV[$current];}
	}
	print STDERR "time " .$now;
}

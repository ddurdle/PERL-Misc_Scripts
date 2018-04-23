#!/usr/bin/perl
my $start = time;
my $duration = 0;
my $duration_ptr = 0;
my $arglist = '';
my $filename_ptr = 0;
foreach my $current (0 .. $#ARGV) {
	# fetch how long to encode
	if ($ARGV[$current] =~ m%\d\d:\d\d:\d\d%){
		my ($hour,$min,$sec) = $ARGV[$current] =~ m%0?(\d+):0?(\d+):0?(\d+)%;
		$duration = $hour*60*60 + $min*60 + $sec;
		$duration_ptr = $current;
		$duration_replacement = $ARGV[$current];
	}elsif ($ARGV[$current] =~ m%\.ts%){
		$filename_ptr = $current;
	}
   $arglist .= ' ' .$ARGV[$current];
}
my $now = -1;
while ($now < 0){
	`ffmpeg $arglist`;
	$now = time - $start - $duration + 5;
	my $hour = int($duration /60/60);
    my $min = int ($duration /60%60);
	my $sec = int ($duration %60);
	$ARGV[$duration_ptr] = ($hour<10? '0':'').$hour.":".($min <10? '0':'').$min.':' . ($sec<10?'0':'').$sec;
	print STDERR "time " .$now;
}

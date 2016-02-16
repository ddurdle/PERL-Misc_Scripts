#
# changes the casing of filenames either from lowercase to UPPERCASE
#


######
#  Configuration
###
use FileHandle;


use Getopt::Std;
my $usage = "usage: $0 -d directory\n";

#my $resolution = '1024x768';
my $resolution = '2048x1536';


my %opt;
die ($usage) unless (getopts ('d:', \%opt));

die($usage) unless ($opt{d} ne '');

scanDir($opt{d});

sub scanDir($$){

my $directory = shift;
my $directoryDestination = shift;
if ($directoryDestination eq ''){
  $directoryDestination = $directory.'_resized';
}else{
  $directoryDestination = $directoryDestination.'_resized';
}
mkdir $directoryDestination if (!(-e $directoryDestination));

opendir(IMD, $directory) || die("Cannot open directory");
my @thefiles= readdir(IMD);

foreach my $f (@thefiles)
{

  unless ($f eq '.' or $f eq '..'){

    if (-d "$directory/$f"){
      print STDERR "navigating into $f\n";
      scanDir("$directory/$f","$directoryDestination/$f");
    }else{
      if (!(-e "$directoryDestination/$f")){
        print STDERR "start resize $f...";
		$f =~ s%\&%\\\&%g;
      	$f =~ s%\(%\\\(%g;
      	$f =~ s%\)%\\\)%g;
      	$f =~ s%\ %\\\ %g;
      	$f =~ s%\;%\\\;%g;
		my $printDirectory = $directory;
		$printDirectory =~ s% %\\ %g;
		my $printDirectoryDestination = $directoryDestination;
		$printDirectoryDestination =~ s% %\\ %g;
		`convert -resize $resolution $printDirectory/$f $printDirectoryDestination/$f`;
       # `convert -size $resolution "$directory/$f" -resize $resolution "$directoryDestination/$f"`;
        print STDERR "done\n";
      }else{
        print STDERR "start skipping $f\n";
      }

    }
  }

}
closedir(IMD);
}

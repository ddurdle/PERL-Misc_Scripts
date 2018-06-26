


######
#  Configuration
###
use FileHandle;


use Getopt::Std;
my $usage = "usage: $0 -d directory\n";

#my $resolution = '1024x768';
my $resolution = '2048x1536';


my %opt;
die ($usage) unless (getopts ('d:D:', \%opt));

die($usage) unless ($opt{d} ne '');

#my $destinationDIR = $opt{D};

scanDir($opt{d}, $opt{D});

sub scanDir($$){

my $directory = shift;
my $directoryDestination = shift;
if ($directoryDestination eq ''){
  $directoryDestinationLocal = $directory.'_resized';
}else{
  $directoryDestinationLocal = $directoryDestination.'_resized';
}

opendir(IMD, $directory) || die("Cannot open directory");
my @thefiles= readdir(IMD);

foreach my $f (@thefiles)
{

  unless ($f eq '.' or $f eq '..'){

    if (-d "$directory/$f"){
      print STDERR "navigating into $f\n";
      scanDir("$directory/$f","$directoryDestination/$f");
    }else{
	  mkdir -p $directoryDestinationLocal if (!(-e $directoryDestinationLocal));

      if (!(-e "$directoryDestinationLocal/$f")){
        print STDERR "start resize $f...";
		$f =~ s%\&%\\\&%g;
      	$f =~ s%\(%\\\(%g;
      	$f =~ s%\)%\\\)%g;
      	$f =~ s%\ %\\\ %g;
      	$f =~ s%\;%\\\;%g;
		my $printDirectory = $directory;
		$printDirectory =~ s% %\\ %g;
		my $printDirectoryDestination = $directoryDestinationLocal;
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

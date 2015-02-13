binmode(STDOUT, ":utf8");

my $USAGE="smallCapsImageCaption.pl <DB-XML>";
if(@ARGV!=1){print $USAGE; exit -1}
open image_index, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";

while (my $line = <image_index>){
	while($line=~/\$/){
		if($line=~/\$\w+|([A-Za-zäöüÄÖÜ\.\-]+)\s*(\w+|[A-Za-zäöüÄÖÜ\.\-]+)\$/){
			$line=~s/\$/\<span class=\"smallCaps\"\>/;
			$line=~s/\$/\<\/span\>/;
		}else{
			print STDERR "ERROR nomatch: ".$line;
		}
	}
	print $line;
}




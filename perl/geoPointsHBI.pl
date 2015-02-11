#!/usr/bin/perl

binmode(STDOUT, ":utf8");


my $USAGE="geoPoints.pl <XML-DB-File>";

if(@ARGV!=1){print $USAGE; exit -1}
open db_gp,  $ARGV[0] || die "cannot open ".$ARGV[0]."\n";


my @points=<db_gp>;
chomp@points;

my $BOOK="I";
# Writing the index
my $op='<field name="';
my $cls='">';
my $endtag='</field>';

print '<?xml version="1.0" encoding="UTF-8"?><add>';
for(my $i=0;$i<@points;$i++){
	if($points[$i]=~/\<field name=\"ID\"\>/){
		my $ID=&trimField($points[$i], "ID");
		my $articleID=&trimField($points[$i+1], "HB1ID");
		my $latitude=&trimField($points[$i+2], "lat");
		my $longitude=&trimField($points[$i+3], "lon");
			
			print "\n";
			print'<doc>';
			print $op."id".$cls."geoPoint-".$ID.$endtag;		
			print $op."book".$cls.$BOOK.$ID.$endtag;		
			print $op."articleID".$cls."I".$articleID.$endtag;
			print $op."doc-name".$cls."rf15_I_121220".$endtag;		
			print $op."type".$cls."geopoint".$endtag;		
			print $op."geoPointLatitude".$cls.$latitude.$endtag;		
			print $op."geoPointLongitude".$cls.$longitude.$endtag;		
			print'</doc>';
	}
}
print"</add>";


sub trimField{
	$line=shift(@_);
	$fieldname=shift(@_);
	if($line=~/\<\/field\>/){
	#$line=~s/\s*xsi:nil=\"true\"\s*//;
	$line=~s/\<field name=\"$fieldname\"\s*\>//;
        $line=~s/\<\/field\>//;
	$line=~s/\s*//;
	}else{ $line =''; }
	return $line;		
}



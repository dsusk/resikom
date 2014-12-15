#!/usr/bin/perl

my $USAGE="imagesIndex.pl <XML-File> <XML-DB-File> <XML-DB-File";

if(@ARGV!=2){print $USAGE; exit -1}
open db_images,  $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open db_imgreferences,  $ARGV[1] || die "cannot open ".$ARGV[1]."\n";


#my @images=<db_images>;
my @irf=<db_imgreferences>;
chomp@irf;

my %brefs; # {BildID}{{BID1, BID2, BID3}}
my %ubrefs; # {BildID}{{UBID1, UBID2, UBID3}}
for(my $i=0;$i<@irf;$i++){
	if($irf[$i]=~/\<field name=\"BV\"\>/){
		my $w=$irf[$i];
		$w=~s/\<field name=\"BV\"\>//;
		$w=~s/\<\/field\>//;
		my@q=split ' ',$w;
		my $bid=$irf[$i-2];
		$bid=~s/\<field name=\"BID\"\>//;
		$bid=~s/\<\/field\>//;
		$bid=~s/\s*//;
		my $ubid=$irf[$i-1];
		$ubid=~s/\<field name=\"UBID\"\>//;
		$ubid=~s/\<\/field\>//;
		$ubid=~s/\s*//;
		print "\n".$bid." ".$ubid."\n" ;	
		foreach(@q){
			print " Q: ".$_." ";
			if(exists($brefs{$_})){  # pruefen ob bid schon drin
				push(@{$brefs{$_}}, $bid);
			}else{
				my @b=($bid);
				$brefs{$_}=\@b;
			}

			if(exists($ubrefs{$_})){
				push(@{$ubrefs{$_}}, $ubid);
			}else{
				my @b=($ubid);
				$ubrefs{$_}=\@b;
			}
		}
	}

}

#foreach(keys(%brefs)){
#	print $_." - ".$brefs{$_}->[0]." ".$brefs{$_}->[1]." ".$brefs{$_}->[@{$brefs{$_}}-1]."\n"
#}


my %img; # {id}i{{BegriffID, UBID, Legende}}
foreach $line (@images){


}



#!/usr/bin/perl

my $USAGE="imageIndex.pl <XML-File> <XML-DB-File>";

if(@ARGV!=2){print $USAGE; exit -1}
open db_images,  $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open db_imgreferences,  $ARGV[1] || die "cannot open ".$ARGV[1]."\n";


my @images=<db_images>;
chomp@images;
my @irf=<db_imgreferences>;
chomp@irf;

my %brefs; # {BildID}{{BID1, BID2, BID3}}
for(my $i=0;$i<@irf;$i++){
	if($irf[$i]=~/\<field name=\"BV\"\>/){
		my $w=&trimField($irf[$i], "BV");
		my@q=split ' ',$w;
		my $bid=&trimField($irf[$i-2], "BID");
		my $ubid=&trimField($irf[$i-1], "UBID");
		foreach(@q){
			if($ubid != 0){
				if(exists($brefs{$_})){
					push(@{$brefs{$_}}, $ubid);
				}else{
					my @b=($ubid);
					$brefs{$_}=\@b;
				}
			}else{
				if(exists($brefs{$_})){ 
					if(grep(/$bid/,@{$brefs{$_}})==0){
						push(@{$brefs{$_}}, $bid);
					}
				}else{
					my @b=($bid);
					$brefs{$_}=\@b;
				}
			}
		}
	}
}


my %bid;
my %ubid;
my %legende;
my %abb_name;
my %filename;
# In-loop incremente!
my $ID;
for(my $i=0; $i<@images; $i++){
	if($images[$i]=~/\<field name=\"ID\"\>/){
		$ID=&trimField($images[$i], "ID");
		$bid{$ID}=&trimField($images[++$i],"BegriffID");
		$ubid{$ID}=&trimField($images[++$i],"UBID");
		$legende{$ID}=&trimField($images[$i+=2],"Legende");
	}elsif($images[$i]=~/\<field name=\"Name\"\>/){	
		$filename{$ID}=&trimField($images[$i],"Name");
		$abb_name{$ID}=&trimField($images[$i+=7], "Abbildung");
		$i+=3;
	}
}


# Writing the index
my $op='<field name="';
my $cls='">';
my $endtag='</field>';

print '<?xml version="1.0" encoding="UTF-8"?><add>';
foreach(keys(%bid)){
	print "\n";
	print'<doc>';
	print $op."ID".$cls.$_."-".$bid{$_}.$endtag;		
	if(exists($ubid{$_}) && $ubid{$_}!=0){
		print $op."articleID".$cls.$ubid{$_}.$endtag;
	}else{
		print $op."articleID".$cls.$bid{$_}.$endtag;
	}		
	print $op."dok-name".$cls."rf15_II_121207".$endtag;		
	print $op."type".$cls."image".$endtag;		
	print $op."image".$cls.$_.$endtag;		
	print $op."image_name".$cls.$abb_name{$_}.$endtag;		
	my $l =$legende{$_};
	$l=~s/^Abb\.*\s*\d+\.*://; 
	print $op."image_caption".$cls.$l.$endtag;		
	print $op."image_file".$cls.$filename{$_}.$endtag."\n";	
	foreach $x (@{$brefs{$_}}){	
		print $op."also_articleID".$cls.$x.$endtag;		
	}
	print'</doc>';
}
print'</add>';



sub trimField{
	$line=shift(@_);
	$fieldname=shift(@_);
	$line=~s/\<field name=\"$fieldname\"\>//;
        $line=~s/\<\/field\>//;
	$line=~s/\s*//;
	return $line;		
}

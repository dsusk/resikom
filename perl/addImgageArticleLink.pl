#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $USAGE="addImageArticleLink.pl <image_solr HBII od HBI> <article_ids (space separated) >";

if(@ARGV<2){print $USAGE; exit -1}
open article, '<:encoding(UTF-8)', $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @article=<article>;
chomp(@article);
close article;


my %aIDs;
foreach$a(@article){
	$a=~s/^\s*//;
	$a=~s/\s*$//;
	my @t=split /\s+/, $a;
	$t[0]=~s/\s*//g;
	$t[1]=~s/\s*//g;
	$aIDs{$t[0]}=$t[1];
}


open fh, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
my @refs=<fh>;
chomp(@refs);
close fh;
foreach$r(@refs){
	my $ID;
	if($r=~/ubid/){
		$r=~/\<field name=\"ubid\"\>(.*)\<\/field\>\<field name=\"docname\"\>/;
		$ID=$1;
	}else{
		$r=~/\<field name=\"article_id\"\>(.*)\<\/field\>\<field name=\"docname\"\>/;
		$ID=$1;
	}
	chomp($ID);
	$x="\<field name=\"article_link\"\>".$aIDs{$ID}."\<\/field\>\<\/doc\>";
	$r=~s/\<\/doc\>/$x/;
	print $r;
}

#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $USAGE="referencesIDJoin.pl <references_solr> <articleIDs (space separated) >";

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
	$r=~/\<field name="article_reference_id"\>(\w+)\<\/field\>\<\/doc\>/;
	$x="\<field name=\"reference_link\"\>".$aIDs{$1}."\<\/field\>\<\/doc\>";
	$r=~s/\<\/doc\>/$x/;
	print $r;
}

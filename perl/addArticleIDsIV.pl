#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $USAGE="addArticleID.pl <XML-File (HBIV)> <XML-solr-article>";

if(@ARGV!=2){print $USAGE; exit -1}


open solr, '<:encoding(UTF-8)', $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @ah=<solr>;
chomp(@ah);
close solr;
my %heads;
foreach$x(@ah){
        my @a=split('##', $x); #titel##ID##ID
	$a[0]=~s/^\s*//;
        $heads{$a[0]}=$a[1];
}
open book, '<:encoding(UTF-8)',   $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
my @hb=<book>;

foreach $line (@hb){
	if($line=~/\<head\>/){
		$line=~/\<head\>(.*)\<\/head\>/;
		my $x=$1;
		if(exists($heads{$x})){		
			$line=~s/\<head/\<head xml:id=\"$heads{$x}\"/
		}else{
			print STDERR "$x\n";
		}
	}
	print $line;
}


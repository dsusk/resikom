#!/usr/bin/perl

my $USAGE="addArticleIDs.pl <XML-File (HBIII)> <XML-DB-File>";

if(@ARGV!=2){print $USAGE; exit -1}
open xml,  $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open db,  $ARGV[1] || die "cannot open ".$ARGV[1]."\n";

my $fieldname="Artikel";
my @DB=<db>;
foreach $line (<xml>){
	if($line=~/\<head\>/){
		$line=~/\<head\>(.*)\<\/head\>/;
		my $x=$1;
		for(my $i=0; $i<@DB;$i++){
			if($DB[$i]=~/$fieldname/){
				$DB[$i]=~/\>(.*)\<\/field\>/;
                       		my $title= uc($1);
				$title=~tr/äöü/ÄÖÜ/;
				if($title eq $x){
					$DB[$i-1]=~/\>(.*)\<\/field\>/;
                       			my $id= $1;
					print STDERR $x."  $id \n";
					$line=~s/\<head/\<head xml:id=\"III$id\"/
				}
			}
		}
	}
	print $line;
}


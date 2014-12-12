#!/usr/bin/perl


my $USAGE="addArticleIDs.pl <XML-File> <XML-DB-File>";

if(@ARGV!=2){print $USAGE; exit -1}
open xml,  $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open db,  $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @DB=<db>;
foreach $line (<xml>){
	if($line=~/\<head\>/){
		$line=~/\<head\>(.*)\<\/head\>/;
		my $x=$1;
		for(my $i=0; $i<@DB;$i++){
			if($DB[$i]=~/Begriff/ ){
				$DB[$i]=~/\>(.*)\<\/field\>/;
                       		my $begriff= lc($1);
				if($begriff eq lc($x)){
					$DB[$i-1]=~/\>(.*)\<\/field\>/;
                       			my $id= $1;
					print STDERR $x."  $id \n";
					$line=~s/\<head/\<head xml:id=\"II$id\"/
				}
			}
		}
	}
	print $line;
}


#!/usr/bin/perl


my $USAGE="getRefs.pl <XML-File>";
my $WORDS_AFTER=5;

if(@ARGV!=1){print $USAGE; exit -1}
open xml, $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
while(<xml>){
	if($_=~/\$/){
		my @words = split(/\s+/, $_);
		for(my $i=0; $i<@words; $i++){
			if($words[$i]=~/\$/){
				for(my $j=$i; $j<($WORDS_AFTER+$i) && $j<@words; $j++){
					if($words[$j]=~/\$/ ){ 
						$i=$j;
						print "\n";
						break;}
					$words[$j]=~s/\$//;
					$words[$j]=~s/\&\#x\w+\;//g;
					$words[$j]=~s#\<\/?.*\>##g;
					#$words[$j]=~s#\<\/?(p|div|hi|(hi.+\"))\>##g;
					$words[$j]=~s/[,:();!?]//g;	
					print $words[$j]." ";
				}
				print "\n";			
			}
		}
	}
}

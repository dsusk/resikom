#!/usr/bin/perl


my $USAGE="matchRefs.pl <IN> <XML-File>";

if(@ARGV!=2){print $USAGE; exit -1}
open refs, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open xml, '<:encoding(UTF-8)', $ARGV[1] || die "cannot open ".$ARGV[1]."\n";

my @refs=<refs>;
chomp(@refs);
my @xml=<xml>;
chomp(@xml);

foreach $r (@refs){
	my @arr = split(' ', $r);
	my $a = join(' ', @arr[0 .. @arr]);
	$a=~s/^\s+|\s+$//g;	
	$a=lc($a);
	print " $a  ";
	foreach $x (@xml){
		if(lc($x) =~ /$a/ ){
			print  "| ".$x."\n";
		}
	}
}

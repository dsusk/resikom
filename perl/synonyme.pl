#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");

# Trennzeichen | Zeilen Ende $\w
my $USAGE="synonyme.pl <Abkuerzungen_HB_X.txt>";

if(@ARGV!=1){print $USAGE; exit -1}
open shorties, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";

while(<shorties>){
	my $t=$_;
	chomp($t);
	my @field=split('\|', $t);
	my $f=join(', ', @field[1..(@field-1)]);
	#$f=~s/,\w*$//;

	print $field[0]." => ".$f."\n";
}
close shorties;



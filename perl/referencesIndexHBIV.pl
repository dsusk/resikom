#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

# heads: alle mit xml:id A##WETTIN##I58
# refs-from-TEI: alle //div@type=references als Solr-xml
my $USAGE="referencesIndex.pl <heads> <refs-from-TEI>\n";

if(@ARGV<2){print $USAGE; exit -1}
open article_heads, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
my @ah=<article_heads>;
chomp(@ah);
close article_heads;
my %heads;
foreach$x(@ah){
	my @a=split('##', $x); # titel##ID
	$heads{$x}=\@a;
}
open references, '<:encoding(UTF-8)',   $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @references=<references>;
chomp(@references);

my %result;
for (my $i=0; $i<@references; $i++){
	if($references[$i]=~/\<field name=\"article_reference\"\>(.*)\<\/field\>\<field name=\"keyword\"/){
	my $tmp=$1;
	$tmp=~s/^\s*//;
	$tmp=~s/\s*$//;
	# ... article ; ... subarticle 
	my $exact_key_article;
	my $exact_key_subarticle;
	if($tmp =~/;/){
		my @s = split(';', $tmp);
		$exact_key_subarticle=$s[1];
		$exact_key_article=$s[0];
	
	}else{
		$exact_key_subarticle=0;
		$exact_key_article=$tmp;
	}

	my $flag=0;
	foreach$k(keys(%heads)){
                 my $s = $heads{$k}->[0]; 
                 $s=~s/\s+//g;
		 my $k_clean=$k;
		 $k_clean=~s/\s+//g;
		my $exact_key;
		if($exact_key_subarticle!=0){
			$exact_key=$exact_key_subarticle; # Männer
		}else{
			$exact_key = $exact_key_article; # A.Famile [enger]
			$exact_key=~s/^(A\.|B\.|C\.)//;
		}
		$exact_key=~s/\[/\\[/g;
		$exact_key=~s/\]/\\]/g;
		$exact_key=~s/\s*//g;
		$k_clean=~s/\s*//g;
		if($k_clean=~/$exact_key/i){
			if(!exists $result{$references[$i]}){  # 2D-Array
                       		push(@{$result{$references[$i]}}, $heads{$k});
                       	}else{
                               	my @a=($heads{k});
                      		$result{$referencesi[$i]}=\@a; }
                       $flag=1;
			next;
		}
	}
	if($flag){ # remove references with a match
		splice(@references,$i,1);
		$i--; }
	} # end foreach head
}

foreach(@references){
	print STDERR $_ ."\n";
}

print '<?xml version="1.0" encoding="UTF-8"?><add>';
foreach$k(keys%result){
	foreach$u(@{$result{$k}}){
		$k=~s/\<\/doc\>/\<field name=\"article_reference_id\"\>$u->[1]\<\/field\>\<\/doc\>/;
	}
	if(@{$result{$k}} >1){ print STDERR "Warining ".$k." more than one articel referred\n" ;}
	print $k."\n";
}
print '</add>';

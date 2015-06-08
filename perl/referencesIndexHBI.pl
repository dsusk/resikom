#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

# heads: alle mit xml:id A##WETTIN##I58
# refs-from-TEI: alle //div@type=references als Solr-xml
my $USAGE="referencesIndex.pl <heads> <refs-from-TEI>";

if(@ARGV<2){print $USAGE; exit -1}
open article_heads, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
my @ah=<article_heads>;
chomp(@ah);
close article_heads;
my %heads;
foreach$x(@ah){
	my @a=split('##', $x); # Char titel ID
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
	my @words=split('\s+', $tmp);
	my $exact_match;
	if($words[0]=~/^(A\.|B\.|C\.)/ && @words>1){
		$exact_key=join('', @words[1..scalar(@words)]);
	}else{
		$exact_key=join('', @words[0..scalar(@words)]);
	}
	$exact_key=~s/ß/ss/g;
	my $flag=0;
	foreach$k(keys(%heads)){
		 my $s;
                 my $s2;
                 if($heads{$k}->[0] eq 'C'){
                 	if($heads{$k}->[1]=~/\//){
                        	$heads{$k}->[1]=~/\[(.*)\/(.*)\]/;
                                $s=$1;
                                $s2=$2;
                                $s2=~s/\].*//;
                                        $s2=~s/\s+//g;
                                } else{
                                        $heads{$k}->[1]=~/\[(.*)\]/;
                                        $s=$1;
                                        $s=~s/\].*//;
                                        $s2='X';
                                }
                        }else{
                                $s=$heads{$k}->[0]; }
                        $s=~s/\s+//g;
			my $k_clean=$k;
			$k_clean=~s/\s+//g;
			if($k_clean=~/$exact_key/i){
                        	if($words[0]=~/$s/ || $words[0]=~/$s2/ || !($words[0]=~/^(A\.|B\.|C\.)/)){
				if(!exists $result{$references[$i]}){  # 2D-Array
                        		push(@{$result{$references[$i]}}, $heads{$k});
                        	}else{
                                	my @a=($heads{k});
                        		$result{$referencesi[$i]}=\@a; }
                        	$flag=1;
			}
		}else{ # try only the first word of the reference
			$words[1]=~s/\,.*$//;
			my $a=$words[1];
			$a=~s/ß/ss/g;
			$a=~s/\s+//g;
			if($k_clean=~/$a/i){
				if($words[0]=~/$s/ || $words[0]=~/$s2/ || !($words[0]=~/^(A\.|B\.|C\.)/)){
					if(!exists $result{$references[$i]}){  # 2D-Array
						push(@{$result{$references[$i]}}, $heads{$k});
					}else{
						my @a=($heads{k});
						$result{$referencesi[$i]}=\@a; }
				$flag=1;
			}
		}
		} # end !exact_match
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
		$k=~s/\<\/doc\>/\<field name=\"article_reference_id\"\>$u->[2]\<\/field\>\<\/doc\>/;
	}
	if(@{$result{$k}} >1){ print STDERR "Warining ".$k." more than one articel referred\n" ;}
	print $k."\n";
}
print '</add>';

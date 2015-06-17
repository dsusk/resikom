#!/usr/bin/perl

binmode(STDOUT, ":utf8");
	
my $USAGE="nestedDocs.pl <Article-Index> <img/hofinh/geop-index> <secIndex img/hofinha....>";

if(@ARGV<2){print $USAGE; exit -1}
open article, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
open nested,  '<:encoding(UTF-8)', $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @nested=<nested>;
close nested;

if(@ARGV>2){
	for(my $i=2; $i<@ARGV; $i++){
		open nested,  '<:encoding(UTF-8)', $ARGV[$i] || die "cannot open ".$ARGV[$i]."\n";
		my @n=<nested>;
		push(@nested, @n);
		close nested;
	}
}


my%docs;
for(my $i=0; $i<@nested; $i++){
	$nested[$i]=~s/\<\/?add\>//g;
	if($nested[$i]=~/\<field name\=\"article_id\"\>(\w+)\<\/field\>/){
		if(exists($docs{$1})){
                   push(@{$docs{$1}}, $nested[$i]);
                }else{
                  my @d=($nested[$i]);
                 	$docs{$1}=\@d;
		}                               
	}
}

my @article=<article>;
my $id;
my $ubid;
for(my$i=0; $i<@article; $i++){
	if($article[$i]=~/\<\/doc\>/){
		foreach $ndoc (@{$docs{$id}}){
			if($ndoc=~/\<field name\=\"ubid\"\>(\w+)\<\/field\>/){
				if($1 eq $ubid){
					print $ndoc;
				}
			}else{ # !ID of the nested
				if($ubid eq ''){
					print $ndoc;
				}
			}
		}
	}
	if($article[$i]=~/\<field name\=\"article_id\"\>(\w+)\<\/field\>/){
		$id=$1;
		$ubid='';
	}
	if($article[$i]=~/\<field name\=\"subarticle_id\"\>(\w+)\<\/field\>/){
                $ubid=$1;
        }
	print $article[$i];
}




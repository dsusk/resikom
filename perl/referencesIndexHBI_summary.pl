#!/usr/bin/perl

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

# heads: alle mit xml:id und solr-id (HB_I_jw)
# refs-from-TEI: alle //div@type=references als Solr-xml (_summary_edited.xml)
my $USAGE="referencesIndexHBI_summary.pl <heads> <refs-from-TEI>";

if(@ARGV<2){print $USAGE; exit -1}
open article_heads, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";
my @ah=<article_heads>;
chomp(@ah);
close article_heads;

my %article;
for(my $i=0;$i<@ah;$i++){
	my @t=split('##', $ah[$i]);
	$article{$t[0]." - ".$t[1]}=\@t;
}


open references, '<:encoding(UTF-8)',   $ARGV[1] || die "cannot open ".$ARGV[1]."\n";
my @references=<references>;
chomp(@references);

my @result;
for (my $i=0; $i<@references; $i++){
 	if($references[$i]=~/\<field name=\"article_reference\"\>(.*)\<\/field\>\<field name=\"keyword\"/){
		my $r=$1;
		$references[$i]=~/\<field name=\"id\"\>(.*)\<\/field\>\<field name=\"docname\"/;
		my $id=$1;
		my$count=0;		
		for$a(keys%article){
			if( $article{$a}->[0] =~ /$r/ ){
				$new_ref = $references[$i];
				my $repl="<\/field\>"
                                        ."\<field name=\"article_reference_id\"\>$article{$a}->[2]\<\/field\>"
                                        ."\<field name=\"article_link\"\>$article{$a}->[3]\<\/field\>"
                                        ."\<field name=\"keyword\"\>";
				$new_ref =~s#\<\/field\>\<field name=\"keyword\"\>#$repl#;
				$new_ref =~s#$r#$article{$a}->[1]#;
				my $new_id=$id."-".$count."jw";
				$new_ref=~s/$id/$new_id/;
				push(@result , $new_ref);		
				$count++;
			}
		}
	}
}

print "<?xml version=\"1.0\" encoding=\"UTF-8\"?><add>";
foreach(@result){
        print $_ ;
}
print "</add>";


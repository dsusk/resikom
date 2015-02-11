#!/usr/bin/perl

binmode(STDOUT, ":utf8");

my $USAGE="imageHBIII.pl <XML-DB-File (quellenverzeichnis)>";

if(@ARGV!=1){print $USAGE; exit -1}
open db_img, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";


my @img=<db_img>;
chomp@img;

my $BOOK='III';

# Writing the index
my $op='<field name="';
my $cls='">';
my $endtag='</field>';
print '<?xml version="1.0" encoding="UTF-8"?>';
print "\n<add>";
FOR: for(my $i=0;$i<@img;$i++){
	if($img[$i]=~/\<field name=\"ID\"\>/){
		my $Abbildung=&trimField($img[$i+4], "Abbildung");
		my $Farbtafel=&trimField($img[$i+5], "Farbtafel");
		my $filename;
		my $name;
		if($Farbtafel != ''){
			$filename="taf".$Farbtafel.".jpg";
			$name="Farbtafel ".$Farbtafel;
		} elsif($Abbildung != ''){
			$filename="fig".$Abbildung.".jpg";
			$name="Abbildung ".$Abbildung;
		} else{ 
			$i+=8; # can skip at least 9 lines
			next FOR; 
		}
		my $ID=&trimField($img[$i], "ID");
		my $articleID=&trimField($img[$i+3], "TextID");
		my $caption=&trimField($img[$i+2], "Quellentitel");
		my $nachweis; # can have several lines
		for(my $j=$i+6; $j<@img; $j++){	
			last if $img[$j]=~/\<\/row\>/;
			$nachweis.=$img[$j]." ";
		}
		$nachweis=&trimField($nachweis, "Nachweis");
		print "\n";
		print'<doc>';
		print $op."id".$cls."imgIII-".$ID.$endtag;		
		print $op."book".$cls.$BOOK.$endtag;		
		print $op."articleID".$cls."III".$articleID.$endtag;
		print $op."doc-name".$cls."rf15_III".$endtag;		
		print $op."type".$cls."image".$endtag;		
		print $op."image".$cls.$ID.$endtag;		
		print $op."image_name".$cls.$name.$endtag;
       		print $op."image_caption".$cls.$caption.$endtag;
 	        print $op."image_file".$cls.$filename.$endtag."\n";
 	        print $op."image_nachweis".$cls.$nachweis.$endtag."\n";
		print'</doc>';
      } # end if articleID
}

# two manual entrys for article 5 (devisen und embleme)
print "\n";
print'<doc>';
print $op."id".$cls."imgIII-1a".$endtag;              
print $op."book".$cls.$BOOK.$endtag;            
print $op."articleID".$cls."III5".$endtag;
print $op."doc-name".$cls."rf15_III".$endtag;           
print $op."type".$cls."image".$endtag;          
print $op."image".$cls."1a".$endtag;             
print $op."image_name".$cls."Farbtafel 1a".$endtag;
print $op."image_file".$cls."taf2.jpg".$endtag."\n";
print'</doc>';
        
print "\n";
print'<doc>';
print $op."id".$cls."imgIII-XX".$endtag;              
print $op."book".$cls.$BOOK.$endtag;            
print $op."articleID".$cls."III5".$endtag;
print $op."doc-name".$cls."rf15_III".$endtag;           
print $op."type".$cls."image".$endtag;          
print $op."image".$cls."XX".$endtag;             
print $op."image_name".$cls."Abbildung 8a".$endtag;
print $op."image_caption".$cls.". Devise mit Chiffrenschlüssel und in Kombination mit Skala aeio".$endtag;
print $op."image_file".$cls."figXX.jpg".$endtag."\n";
print $op."image_nachweis".$cls."Lhotsky, »Devise«, S. 221 Nr. 9".$endtag."\n";
print'</doc>';


print"</add>";


sub trimField{
	$line=shift(@_);
	$fieldname=shift(@_);
	if($line=~/\<\/field\>/){
	#$line=~s/\s*xsi:nil=\"true\"\s*//;
	$line=~s/\<field name=\"$fieldname\"\s*\>//;
        $line=~s/\<\/field\>//;
	$line=~s/\s*//;
	}else{ $line =''; }
	return $line;		
}



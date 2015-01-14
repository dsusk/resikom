#!/usr/bin/perl

binmode(STDOUT, ":utf8");

my $USAGE="hofinhaberIndex.pl <XML-DB-File>";

if(@ARGV!=1){print $USAGE; exit -1}
open db_hib, '<:encoding(UTF-8)', $ARGV[0] || die "cannot open ".$ARGV[0]."\n";


my @hib=<db_hib>;
chomp@hib;


# Writing the index
my $op='<field name="';
my $cls='">';
my $endtag='</field>';

print '<?xml version="1.0" encoding="UTF-8"?>';
print "\n<add>";
for(my $i=0;$i<@hib;$i++){
	if($hib[$i]=~/\<field name=\"ID\"\>/){
		my $ID=&trimField($hib[$i], "ID");
		my $articleID=&trimField($hib[$i+6], "DynaID");

		if($articleID != ''){
			my $inhab=&trimField($hib[$i+4], "Hofinhaber");
			my $dynastie=&trimField($hib[$i+2], "Dynastie");
			my $linie=&trimField($hib[$i+3], "Linie");
			my $amtszeit=&trimField($hib[$i+5], "Amtszeit");
			my $az_von=substr($amtszeit, 0,4);
			my $az_bis;
			my $az_weitere_von;
			my $az_weitere_bis;
			$amtszeit=~s/\s//g;
			my $prefix=substr($amtszeit,0, 2);
                        if($amtszeit =~/\-/ && length($amtszeit)>5){
                        	if($amtszeit =~/(.+)\/(.+)/){
					my $erste=$1;
					my $weitere=$2;
                                        if(length($erste) == 4){
                                                # 1404/20-68  # 1375/92-1413
						$az_bis=$az_von;
                                        }elsif($erste=~/-/ && length($erste)-index($erste, '-')-1==4){
                                                # 1391-1416/40  
                                                $az_bis=substr($erste, 5,4);
						$prefix=substr($erste, index($erste, '-')+1, 2);
					}elsif($erste=~/-/ && length($erste)-index($erste, '-')-1==2){ # 1625-34/1661-70
                                                $az_bis=$prefix.substr($erste, 5,2);
					}else{
                                                $az_bis=substr($erste, 0, 3).substr($erste,5);
					}
                                        if($weitere=~/\-/){
						my $p=index($weitere, '-');
						if($p==2){ # 1515/27-41 # 1434/45-1478 
                                                	$az_weitere_von=$prefix.substr($weitere, 0,$p);
						}else{ # 1625-34/1661-70
                                                	$az_weitere_von=substr($weitere, 0,$p);
							$prefix=substr($weitere, 0, 2);
						}
						if(length($weitere)-$p-1 == 4){
                                                	$az_weitere_bis=substr($weitere, $p+1);
						}else{
                                                	$az_weitere_bis=$prefix.substr($weitere, $p+1);
						}
					}elsif(length($weitere) == 4){  # 1595/1604
						$az_weitere_von=$weitere;
						$az_weitere_bis=$weitere;
                                        }else{   # 1362-48/50  1391-1416/40
						$az_weitere_von=$prefix.$weitere;
						$az_weitere_bis=$az_weitere_von;
                                        }
                              }else{      # end if /
				if(($amtszeit=~s/\-/\-/g) == 1){ #1422-36 #1391-1416 
					if(length($amtszeit)-index($amtszeit, '-')-1 == 2){
						$az_bis=$prefix.substr($amtszeit, index($amtszeit, '-')+1);
					}elsif(length($amtszeit)-index($amtszeit, '-')-1 ==4){
						$az_bis=substr($amtszeit, index($amtszeit, '-')+1);
					}else{
						$az_bis=substr($amtszeit, 0,3).substr($amtszeit, index($amtszeit, '-')+1);
					}	
                               }elsif (($amtszeit=~s/\-/\-/g) == 2) { #  1422-36-77
					my @t=split('-', $amtszeit);
					if(length($t[1])==4){
						$az_bis=$t[1];
						$az_weitere_von=$az_bis;
						$prefix=substr($t[1], 0, 2);
					}else{
						if(length($t[1])==2){
							$az_bis=$prefix.$t[1];
						}elsif(length($t[1])==1){
							$az_bis=substr($az_von, 0, 3).$t[1];
						}else{
							$az_bis=$t[1];
							$prefix=substr($t[1], 0, 2);
						}
					}
					$az_weitere_von=$az_bis;
					if(length($t[2]) ==2){
						$az_weitere_bis=$prefix.$t[2];
					}elsif(length($t[2])==1){
							$az_weitere_bis=substr($az_weitere_von, 0, 3).$t[2];
					}else{
							$az_weitere_bis=$t[2];
					}
				}
			   } # end else /
                       }elsif($amtszeit=~/\/(.+)/){   # end if '-'
                                $az_bis=$az_von;
				my $weitere = $1;
                                if(length($weitere) == 1){ #1365/7
                                	$az_weitere_von=substr($amtszeit, 0, 3).$weitere;
                                }elsif(length($weitere) ==2){ #1365/77 {
                                	$az_weitere_von=substr($amtszeit, 0, 2).$weitere;
                                }else{  #1395/1403
                                    	$az_weitere_von=$weitere;
                                }
                                $az_weitere_bis=$az_weitere_von;
                      }elsif($amtszeit=~/\+/){    # 1391+
                     		$amtszeit=~s/\+//;
                                $az_bis=$amtszeit+1;
                       }elsif(length($amtszeit) ==4 && $amtszeit=~/^\d+$/){
                                $az_bis=$amtszeit;
                       }else{    # -1625     # †1654
                        	$amtszeit=~s/\D//;
                        	$az_von=$amtszeit;
                                $az_bis=$amtszeit;
                        }
			print "\n";
			print'<doc>';
			print $op."id".$cls."hofinh-".$ID.$endtag;		
			print $op."articleID".$cls."I".$articleID.$endtag;
			print $op."doc-name".$cls."rf15_I_121220".$endtag;		
			print $op."type".$cls."hofinhaber".$endtag;		
			print $op."hofinhaber".$cls.$inhab.$endtag;		
			print $op."hofinhaber_dynastie".$cls.$dynastie.$endtag;		
			print $op."hofinhaber_linie".$cls.$linie.$endtag;		
			print $op."hofinhaber_amtszeit_von".$cls.$az_von.$endtag;		
			print $op."hofinhaber_amtszeit_bis".$cls.$az_bis.$endtag;		
			if($az_weitere_von){
				print $op."hofinhaber_amtszeit_weitere_von".$cls.$az_weitere_von.$endtag;		
				print $op."hofinhaber_amtszeit_weitere_bis".$cls.$az_weitere_bis.$endtag;
			}		
			print'</doc>';
               } # end if articleID
	}
}
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



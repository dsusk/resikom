<?php
$location="./DIR/";
 
$db = mysql_connect("localhost", 'XXX', 'YYYYYY');
mysql_select_db("DB)-NAME",$db);
 
$sql="select bilder.ID, bilder.Abbildung, bilder.File, bilder.BegriffID, bilder.Name from bilder";
 
$rs = mysql_query($sql,$db);
 
echo "<h2>EXPORTING INTO $location</h2>";
$counter=0;
while ($row=mysql_fetch_object($rs)) {
//  echo " $location.$row->Abbildung";
  $name=preg_replace("/\s+/", '_', $row->Abbildung);
  $name=preg_replace("/[:.]/","",$name);

  #$filename=$location.$row->ID.'_'.$row->BegriffID.'_'.$name . '.jpg';
  $filename=$location.$row->Name;
  mb_convert_encoding($filename, 'UTF-8', 'latin1');
  echo "$filename :\n";
  $file=fopen($filename,'w');
  if (fwrite($file,$row->File)) {
   echo "OK<br />";
  } else echo 'fail **<br>';
}
 
//echo "<h2>$counter images exported</h2>";
?>

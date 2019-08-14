<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
          "http://www.w3.org/TR/html4/loose.dtd">
<html>
<HEAD>
<Title>Dateiablage</title>
<LINK REL="SHORTCUT ICON" HREF="favicon.ico">
<META HTTP-EQUIV="Pragma" content="no-cache">
<META HTTP-EQUIV="Cache-Control" content="no-cache, must-revalidate">
<META HTTP-EQUIV="Expires" content="0">
<STYLE TYPE="text/css">
<!--
P.breakhere { page-break-before: always; }
table.border { border-color:#000000; border-style:solid; }
td { padding-left:5px; padding-right:5px; border-color:#000000; border-style:solid; border-bottom-style:solid; border-width:0px; border-bottom-width:0px; font-family:Verdana; font-size:13px; }

a:link    { font-family:Verdana,Arial; font-size:13px;  color:#cc0000; text-decoration:none; }
a:visited { font-family:Verdana,Arial; font-size:13px;  color:#999999; text-decoration:none; }
a:active  { font-family:Verdana,Arial; font-size:13px;  color:#cc0000; text-decoration:none; }
a:hover   { font-family:Verdana,Arial; font-size:13px;  color:#cc0000; text-decoration:none; background-color:#C8D8E0; }

a:link.head    { font-family:Verdana,Arial; font-size:13px;  color:#000040; text-decoration:underline; }
a:visited.head { font-family:Verdana,Arial; font-size:13px;  color:#000040; text-decoration:underline; }
a:active.head  { font-family:Verdana,Arial; font-size:13px;  color:#000040; text-decoration:underline; }
a:hover.head   { font-family:Verdana,Arial; font-size:13px;  color:#000040; text-decoration:underline; }

-->
</STYLE>
</HEAD>
<body bgcolor="#ffffff">
<?php

// Pre - Init
date_default_timezone_set('Europe/Berlin');
$ONEDAY = 60*60*24;
$today = time();
$time_start = microtime_float();
$unchanged = true;

// const
define('SortOrderFileName',"sort.txt");
define('cGREEN_FNAME',"green.txt");
define('cRED_FNAME',"red.txt");
define('cORANGE_FNAME',"orange.txt");
define('cIS_NEUTRAL',"0");
define('cIS_ORANGE',"1");
define('cIS_GREEN',"2");
define('cIS_RED',"3");
$auto_detect_line_endings=true;

// var
$filename = array();
$filedate = array();
$c_green = array();
$c_red = array();
$c_orange = array();

// #####################
// B E G I N  --  F  U  N  C  T  I  O  N  S
// #####################

function saveSort($s)
{ $fp = fopen(SortOrderFileName,"w");
  fputs($fp,$s);
  fclose($fp);
}

function loadSort()
{ $fp = fopen(SortOrderFileName,"r");
  $s = trim(fgets($fp,10));
  fclose($fp);
  return $s; 
}

function saveArray($theArray,$fileName) {

 global $unchanged;

 $f=fopen($fileName,"w");
 foreach($theArray as $line) {
             fputs($f,trim($line) . "\r\n"); 
 }
 fclose($f);
 $unchanged = false;
}

function microtime_float()
{
  //  list($usec, $sec) = explode(" ", microtime());
  //  return ((float)$usec + (float)$sec);
  return microtime(true);
}

function getColor($oneFile,$default_color) {

 global $c_green;
 global $c_red;
 global $c_orange;
 
  $oneFile = $oneFile . "\r\n";
  
  if (in_array($oneFile,$c_green)) {
   //return "#CCFFCC";
   return "#66CC00";
   }
  
  if (in_array($oneFile,$c_red)) {
//   return "#FF9999";
   return "#CC3333";
   }

  if (in_array($oneFile,$c_orange)) {
   return "#FFCC66";
   }
   
// return "#E8F4F8";
 return $default_color;
}

function getState($oneFile) {

  global $c_green;
  global $c_red;
  global $c_orange;
 
  $oneFile = $oneFile . "\r\n";
  
  if (in_array($oneFile,$c_green)) {
   return cIS_GREEN;
   }
  
  if (in_array($oneFile,$c_red)) {
   return cIS_RED;
   }

  if (in_array($oneFile,$c_orange)) {
   return cIS_ORANGE;
   }
   
  return cIS_NEUTRAL;
 
}

// ###################
// E N D  --  F  U  N  C  T  I  O  N  S
// ###################

// Eingangsparameter vorbereiten!
$_GLOBALS = array("sortorder","sC","wC");
foreach ($_GLOBALS as $var) if (isset($_REQUEST[$var])) { $$var = $_REQUEST[$var]; }

// Dateien laden!
 if (file_exists(cGREEN_FNAME)) {
  $c_green = file(cGREEN_FNAME);
 }
 
 if (file_exists(cRED_FNAME)) {
  $c_red = file(cRED_FNAME);
 } 
 
 if (file_exists(cORANGE_FNAME)) {
  $c_orange = file(cORANGE_FNAME);
 } 


if (isset($sC)) {
  
  if ($wC==getState($sC)) {
   // echo $sC . "<br>";
   // echo "im Link: " . $wC . "<br>";
   // echo "auf Disk: " . getState($sC) . "<br>";  

  // 
  $sC = $sC . "\r\n";

  while (true) {

   if (in_array($sC,$c_orange)) {
     $c_orange = array_diff ($c_orange,array($sC));
     saveArray($c_orange, cORANGE_FNAME);
     $c_green[count($c_green)]  = $sC;
     saveArray($c_green, cGREEN_FNAME);
     break; 
   }
   if (in_array($sC,$c_green)) {
     $c_green = array_diff ($c_green,array($sC));
     saveArray($c_green, cGREEN_FNAME);
     $c_red[count($c_red)]  = $sC;
     saveArray($c_red, cRED_FNAME);
     break; 
   }
   if (in_array($sC,$c_red)) {
     $c_red = array_diff ($c_red,array($sC));
     saveArray($c_red, cRED_FNAME);
     break; 
   }

   $c_orange[count($c_orange)]  = $sC;
   saveArray($c_orange, cORANGE_FNAME);
   break;
 
  }
  }
}


// S T A R T
if (false)
if ($_SERVER['SERVER_PORT']==80) {

 // Meldung, dass jetzt SSL verfügbar ist:
 $fullpath = getcwd();
 $actpath = substr($fullpath,strrpos($fullpath,"/"));
 $NewLink = "https://secure.orgamon.com" . $actpath ."/";
 echo "<center>";
 echo "Eine <a href=\"http://de.wikipedia.org/wiki/Hypertext_Transfer_Protocol_Secure\">SSL</a>-gesicherte Variante dieser Dateiablage ist nun verfügbar: Bitte verwenden Sie falls möglich diesen neuen Link:<br><br>";
 echo "<a href=\"" . $NewLink . "\" . >" . $NewLink . "</a><br><br>";
 echo "</center>";

}

if (false)
if (strpos($_SERVER['HTTP_HOST'],"netzumbau")==0) {

 $fullpath = getcwd();
 $actpath = substr($fullpath,strrpos($fullpath,"/"));
 $NewLink = "http:/" . $actpath. ".netzumbau.de/";
 echo "<center>";
 echo "Alternativ steht Ihnen ein schnellerer Zugang zur Verfügung:<br><br>";
 echo "<a href=\"" . $NewLink . "\" . >" . $NewLink . "</a><br><br>";
 echo "(Sie greifen im Moment über http://" . $_SERVER['HTTP_HOST'] . "/ zu)<br><br>";
 echo "</center>";
}

echo "<center>";
echo "<h1>" . $_SERVER['HTTP_HOST'] . "</h1>";
echo "<a href=senden.html>Info über Handy-Abrufe</a><br>";
echo "<a href=up.php?info=JA>Status des XMLRPC-Servers</a><br>";
echo "<a href=-neu.html>Ausstehende -Neu Umbenennungen</a><br>";
echo "<br>";
echo "<a href=ausstehende-fotos.html>Foto-Upload: Überblick</a><br>";
echo "<a href=ausstehende-details.html>Foto-Upload: Details</a><br>";
echo "<br>";
echo "<a href=geraete.html>Info über freie Geräte-Nummern</a><br>";
echo "<a href=vertrag.html>Vertrags-Info</a><br>";
echo "<br>";
echo "</center>";


// Beim allerersten Skriptaufruf
if (!file_exists(SortOrderFileName) AND !isset($sortorder)) 
{ $sortorder = "name";  // Standard-Einstellung
  saveSort($sortorder);
}

// Beim jeweils ersten Skriptaufruf
if (file_exists(SortOrderFileName) AND !isset($sortorder)) { $sortorder = loadSort(); }

// Beim erneuten Skriptaufruf
if (file_exists(SortOrderFileName) AND isset($sortorder)) { saveSort($sortorder); }

?>
<center>

<table class=border cellpadding=0 cellspacing=2 border=1 width=600>
<tr><td colspan=4><br><br><b>Foto-Dateiablage [<a href="http://orgamon.org/index.php5/CMS.Dateiablage">Hilfe</a>]</b>
</td></tr>
<tr>
<td bgcolor="#C8D8E0">
Status
</td>
 
  <td width=70% bgcolor="#C8D8E0"><font face="Verdana" size=-1><a class="head" href="./index.php?sortorder=name"><b>
<?php
 echo "Dateiname</b></a>";
 if ($sortorder=="name")
 {
  echo "&nbsp;v";
 }
?>
</td>
<td bgcolor="#C8D8E0">
Farbe
</td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size=-1><a class="head" href="./index.php?sortorder=date"><b>
<?php

 echo "Aufnahmezeitpunkt</b></a>";
 if ($sortorder=="date") {
  echo "&nbsp;v";
 }
?>
</td>
</tr>
<?php


$n = 0;
if ($handle = opendir('.')) { 
 while (false !== ($file = readdir($handle))) { 

    //
    if ((strpos($file,".jpg") !== false) && (strpos($file,"$$$") === false)) { 
	  // 
      $file_time = filemtime($file);
	  if ( (($today - $file_time) / $ONEDAY) < 51 ) {
	  
       // add entry 
	   $filename[$n] = $file;
       $filedate[$n] = $file_time; 
	   $n++;
	  }
    }
 } closedir($handle);
}


switch($sortorder)
{ case("name") : array_multisort($filename, SORT_ASC, $filedate, SORT_DESC);
                 break;
  case("date") : array_multisort($filedate, SORT_DESC, $filename, SORT_ASC); 
                 break;
}

for ($i = 0; $i < $n; $i++) 
 { $fn = $filename[$i];
   $fd = $filedate[$i];
   if ($i%2==0) {
    $bgcolor = "#E9E9E9";
   } else
   {
    $bgcolor = "#E8F4F8";
   }
   echo "<tr>\n";
 
   // Farbe
   echo " <td bgcolor=";
   echo getColor($fn,$bgcolor);
   echo ">&nbsp;</td>\n";
 
   // Datei-Name
   if (strpos($fn,".html")>1) {
    echo " <td bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
    echo "<a href=\"" . rawurlencode($fn) . "\">";
    echo $fn; 
    echo "</a></td>\n";
   } 
   else {
    echo " <td align=left bgcolor=$bgcolor>";
	echo "<font face=\"Courier New\" size=+2>";
    echo "<a href=\"" . rawurlencode($fn) . "\">";
    echo "<b>" . $fn . "</b>"; 
    echo "</a></td>\n";
   }

   echo " <td align=center bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
   echo "<a href=\"./index.php";
   echo "?sC=" . urlencode($fn);
   echo "&wC=" . getState($fn);
   echo "\"><img src=\"ampel-horizontal.gif\" border=0></a>";
   echo "</td>\n";
 
   // Datei-Datum
   echo " <td bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
   echo date ("d.m.Y", $fd);
   echo "&nbsp;&nbsp;";
   echo date ("H:i:s", $fd);
   echo "</td>\n";

   echo "</tr>\n"; 
 }

 
 

?>


<tr><td colspan=4><br><br><b>zip-Dateiablage [<a href="http://orgamon.org/index.php5/CMS.Dateiablage">Hilfe</a>]</b><br>
</td></tr>
<tr>
<td bgcolor="#C8D8E0">
Status
</td>
 
  <td width=70% bgcolor="#C8D8E0"><font face="Verdana" size=-1><a class="head" href="./index.php?sortorder=name"><b>
<?php
 echo "Dateiname</b></a>";
 if ($sortorder=="name")
 {
  echo "&nbsp;v";
 }
?>
</td>
<td bgcolor="#C8D8E0">
Farbe
</td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size=-1><a class="head" href="./index.php?sortorder=date"><b>
<?php

 echo "Ablagedatum</b></a>";
 if ($sortorder=="date") {
  echo "&nbsp;v";
 }
?>
</td>
</tr>
<?php


// Datentabelle

$filename = array();
$filedate = array();

$n = 0;
if ($handle = opendir('.')) { 
 while (false !== ($file = readdir($handle))) { 

    //
    if ((strpos($file,".zip") !== false) && (strpos($file,"$$$") === false)) { 

	// 
      $file_time = filemtime($file);
	  if ( (($today - $file_time) / $ONEDAY) < 51 ) {
	  
       // add entry 
	   $filename[$n] = $file;
       $filedate[$n] = $file_time; 
	   $n++;
	  }
    }
 } closedir($handle);
}


switch($sortorder)
{ case("name") : array_multisort($filename, SORT_ASC, $filedate, SORT_DESC);
                 break;
  case("date") : array_multisort($filedate, SORT_DESC, $filename, SORT_ASC); 
                 break;
}

for ($i = 0; $i < $n; $i++) 
 { $fn = $filename[$i];
   $fd = $filedate[$i];
   if ($i%2==0) {
    $bgcolor = "#E9E9E9";
   } else
   {
    $bgcolor = "#E8F4F8";
   }
   echo "<tr>\n";
 
   // Farbe
   echo " <td bgcolor=";
   echo getColor($fn,$bgcolor);
   echo ">&nbsp;</td>\n";
 
   // Datei-Name
   if (strpos($fn,".html")>1) {
    echo " <td bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
    echo "<a href=\"" . rawurlencode($fn) . "\">";
    echo $fn; 
    echo "</a></td>\n";
   } 
   else {
    echo " <td align=left bgcolor=$bgcolor>";
	
	echo "<font face=\"Courier New\" size=+2>";
    echo "<a href=\"" . rawurlencode($fn) . "\">";
    echo "<b>" . $fn . "</b>"; 
    echo "</a></td>\n";
   }

   // Farb-Umschaltung
   echo " <td align=center bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
   echo "<a href=\"./index.php";
   echo "?sC=" . urlencode($fn);
   echo "&wC=" . getState($fn);
   echo "\"><img src=\"ampel-horizontal.gif\" border=0></a>";
   echo "</td>\n";
 
   // Datei-Datum
   echo " <td bgcolor=$bgcolor><font face=\"Verdana\" size=-1>";
   echo date ("d.m.Y", $fd);
   echo "&nbsp;&nbsp;";
   echo date ("H:i:s", $fd);
   echo "</td>\n";

   echo "</tr>\n"; 
 }

?>

</table>
<font face="Verdana" size=-2>
OrgaMon&trade; Rev 8.133 &copy;1987-2015 http://www.orgamon.org, 
<?php
$time = round( (microtime_float()  - $time_start) * 1000.0, 1);
if ($unchanged) {
 echo " [aufgelistet in $time ms]";
} else {
 echo " [gespeichert in $time ms]";
} 
?>
<br>
</center>
</body>
</html>
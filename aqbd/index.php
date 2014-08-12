<?php

//
$Version="1.036";

// REST - Parameter
$pBLZ="";
$pKontoNummer="";
$pDatum="";
$FunktionsName="";

// Pfade
$AqRoot = "/srv/aqb/";
$AqJob = $AqRoot . "jobs/";
$AqError = $AqRoot . "error/";
$AqErfolg = $AqRoot . "results/";
$AqInfo = $AqRoot . "logs/";

while (1) {

  $JobID = rand(100000,999999);

  if (file_exists($AqErfolg . $JobID . ".job" )) 
    continue;
  if (file_exists($AqError . $JobID . ".job" )) 
    continue;

  break;	
}

header("Server: phpREST/" . $Version);
header("Content-Type: text/plain");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
header("Pragma: no-cache");
header("ETag: \"" . $JobID . "\"");

//HttpResponse::setETag($JobID);

// TOOLS

function tunnel($DateiName) {

     $line = file($DateiName);
     foreach ($line as $out)
     {
       echo utf8_decode ($out);
     }
}

function halt_timeout() {
  
  global $JobID; 

  echo "ERROR: 500 - TIMEOUT bei Job $JobID\n\r";
}

function halt_error($Info) {

 echo "ERROR: 400 - $Info\n\r";
}

function pin(){

 // Lese zu einem Konto den PIN-File
 global $AqRoot;
 global $pBLZ;
 global $pKontoNummer;
 
 $FName = $AqRoot . "pin.$pBLZ.$pKontoNummer.txt";

 // pin-Datei sollte nur eine Zeile haben!!
 if (file_exists($FName)) {
 
   $lines = implode(file($FName));
   return ($lines);
 } else {
 
   return ("");
 }
}

function aqJob($JobStr)
{

 global $AqJob;
 global $JobID;

 // Datei erzeugen
 $job = fopen($AqJob . $JobID, "w");
 fwrite ($job, $JobStr ."\n" );
 fclose ($job); 

 // Datei sichtbar machen 
 rename($AqJob . $JobID, $AqJob . $JobID . ".job");

}

function aqTAN($pTAN)
{

 global $AqJob;
 global $JobID;

 // Datei erzeugen
 $job = fopen($AqJob . $JobID, "w");
 fwrite ($job, $pTAN );
 fclose ($job); 

 // Datei sichtbar machen 
 rename($AqJob . $JobID, $AqJob . $JobID . ".tan");

}

class tREST {

function info(){

 global $AqError,$AqErfolg,$AqInfo;
 global $JobID;
 global $Version;
 global $JobID;

 aqJob("-V");

 $Erfolg = false;
 $TimeOut = true;
 $Gewartet = 0;

 while ($Gewartet<5) 
 {

   sleep(1);
   $Gewartet++;

   if (file_exists($AqErfolg . $JobID . ".job" )) {

     // Job erfolgreich durchgefuehrt
     $TimeOut = false;
     $Erfolg = true;
     tunnel($AqErfolg . $JobID . ".Version.csv");
     
     break; 
   } 
 
   if (file_exists($AqError . $JobID . ".job" )) {

     // Es wurden Probleme gemeldet
     $TimeOut = false;
     tunnel($AqInfo . $JobID . ".log.txt");
     

     break; 
   }
 
 }
 
 if ($Erfolg==false) 
 {
  echo "Modul;Version\n\r";
  echo "aqbd;OFFLINE\n\r";
 }
 echo "aqb-REST;$Version\n\r";

}

function saldo() 
{
 // Parameter
 global $pBLZ;
 global $pKontoNummer;
 global $AqError,$AqErfolg,$AqInfo;
 global $JobID;
 
 $pPIN = pin();
 if ($pPIN=="") {
  halt_error("Kombination BLZ/Kontonummer ist unbekannt");
  return;
 }
 
 aqJob("-S $pBLZ $pKontoNummer $pPIN");
        
 $Erfolg = false;
 $TimeOut = true;
 $Gewartet = 0;
 
 while ($Gewartet<28) 
 {

   sleep(1);
   $Gewartet++;

   if (file_exists($AqErfolg . $JobID . ".job" )) 
   {

     // Job erfolgreich durchgefuehrt
     $TimeOut = false;
     $Erfolg = true;
     tunnel($AqErfolg . $JobID . ".Saldo.csv");
     break; 
   }
 
   if (file_exists($AqError . $JobID . ".job" )) {

     // Es wurden Probleme gemeldet
     $TimeOut = false;
     tunnel($AqInfo . $JobID . ".log.txt");
     break; 
   }
 
 }

 if ($TimeOut) 
 {
  halt_timeout();
 }
 
 if ($Erfolg==false) 
 {
  echo "ERROR: Saldenbereitstellung erfolglos\n\r";
 }
 
}

function umsatz() 
{ 
 //Parameter
 global $pBLZ;
 global $pKontoNummer;
 global $pDatum;
 global $AqError, $AqErfolg, $AqInfo;
 global $JobID; 
 
 $pPIN = pin();
 if ($pPIN=="") {

  halt_error("Kombination BLZ/Kontonummer ist unbekannt");
  return;
 }
 
 aqJob("-u $pBLZ $pKontoNummer $pPIN $pDatum" );

 $Erfolg = false;
 $TimeOut = true;
 $Gewartet = 0;

 while ($Gewartet<60) 
 {

   sleep(1);
   $Gewartet++;

   if (file_exists($AqErfolg . $JobID . ".job" )) {

     // Job erfolgreich durchgefuehrt
     $TimeOut = false;
     $Erfolg = true;
     tunnel($AqErfolg . $JobID . ".Umsatz.csv");
     break; 
   }
 
   if (file_exists($AqError . $JobID . ".job" )) 
   {

     // Es wurden Probleme gemeldet
     $TimeOut = false;
     tunnel($AqInfo . $JobID . ".log.txt");
     break; 
   }
 
 }

 if ($TimeOut) 
 {
  halt_timeout();
 }
 
 if ($Erfolg==false) 
 {
  echo "ERROR: Umsatzbereitstellung erfolglos\n\r";
 }

}

function ablage() {

 global $pBLZ;
 global $AqErfolg;

 $Erfolg = false;

 if (file_exists($AqErfolg . $pBLZ . ".Umsatz.csv" )) {

     // Job erfolgreich durchgefuehrt
     $Erfolg = true;
     tunnel($AqErfolg . $pBLZ . ".Umsatz.csv");
     return; 
 }

 if ($Erfolg==false) {
  echo "ERROR: " . $AqErfolg . $pBLZ . ".Umsatz.csv nicht gefunden\n\r";
 }

}

function log() {

 global $pBLZ;
 global $AqInfo;

 $Erfolg = false;
 if (file_exists($AqInfo . $pBLZ . ".log.txt" )) {

     // Job erfolgreich durchgefuehrt
     $Erfolg = true;
     tunnel($AqInfo . $pBLZ . ".log.txt");
     return; 
 }

 if ($Erfolg==false) {
  echo "ERROR: Log " . $pBLZ . " nicht gefunden\n\r";
 }
}


function lastschrift()
{
  global $pBLZ;
  global $pKontoNummer;
  global $AqError, $AqErfolg, $AqInfo, $AqJob;
  global $JobID;
 
  // erst die Lastschrift csv schreiben
  if($_FILES['Datei']['tmp_name'])  {

    $pPIN = pin();
    if ($pPIN=="") {
 
      halt_error("Kombination BLZ/Kontonummer ist unbekannt");
      return;
    }

    move_uploaded_file($_FILES['Datei']['tmp_name'], $AqJob . $JobID . ".csv" );
 
    // nun den Job schreiben
    aqJob("-L $pBLZ $pKontoNummer " . pin() . " " . $JobID . ".csv" );

  $Erfolg = false;
  $TimeOut = true;
  $Gewartet = 0;
  while($Gewartet < 15)
  {

    //Warten auf die TAN-Anfrage...
    sleep(1);
    $Gewartet++;
    if (file_exists($AqErfolg . $JobID . ".tan-anfrage.txt" )) 
    {
      // Tan-Anfrage da!!!
      echo ($JobID . "\r\n"); 
      $TimeOut = false;
      $Erfolg = true;
      tunnel($AqErfolg . $JobID . ".tan-anfrage.txt");
      break; 
    }
    
    if (file_exists($AqError . $JobID . ".job" )) 
    {

      // Es wurden Probleme gemeldet
      $TimeOut = false;
      tunnel($AqInfo . $JobID . ".log.txt");
      break; 
    }
    
    
  }

 if ($TimeOut) 
 {
  halt_timeout();
 }
 
 if ($Erfolg==false) 
 {
  echo "ERROR: Lastschrift erfolglos\n\r";
 }

 } else {

header("Content-Type: text/html");

 
?> 
<html>
<head>
<title>Datei-Upload</title>
<link rel="shortcut icon" href="/favicon.ico" />
</head>
<body>
<form action="<?php echo$_SERVER['PHP_SELF']; ?>" enctype="multipart/form-data" method="post">
<input name="Datei" type="file"><br>
<input name="Send" type="submit" value="Upload">
</form>
</body>
</html>
<?php


 }
  
}

function sammellastschrift()
{
  global $pBLZ;
  global $pKontoNummer;
  global $AqError, $AqErfolg, $AqInfo, $AqJob;
  global $JobID;
 
  // erst die Lastschrift csv schreiben
  if($_FILES['Datei']['tmp_name'])  {

    $pPIN = pin();
    if ($pPIN=="") {
 
      halt_error("Kombination BLZ/Kontonummer ist unbekannt");
      return;
    }

    move_uploaded_file($_FILES['Datei']['tmp_name'], $AqJob . $JobID . ".csv" );
 
    // nun den Job schreiben
    aqJob("-L $pBLZ $pKontoNummer " . pin() . " " . $JobID . ".csv" );

  echo ($JobID . "\r\n"); 
  echo ("SammelLastschrift=JA\r\n");
  echo ("INFO: Rückmeldung der Bank erfolgt, bitte warten ...\r\n");

 } else {

header("Content-Type: text/html");

 
?> 
<html>
<head>
<title>Datei-Upload</title>
<link rel="shortcut icon" href="/favicon.ico" />
</head>
<body>
<form action="<?php echo$_SERVER['PHP_SELF']; ?>" enctype="multipart/form-data" method="post">
<input name="Datei" type="file"><br>
<input name="Send" type="submit" value="Upload">
</form>
</body>
</html>
<?php


 }
  
}

function meldung() {

 global $JobID;
 global $pBLZ;
 global $pKontoNummer;
 global $AqErfolg, $AqError, $AqInfo;
 
 // aktuelle JobID verwerfen und "alte" ID verwenden!
 $JobID = $pBLZ;
 while(true) {

    if (file_exists($AqErfolg . $JobID . ".tan-anfrage.txt" )) {

	  // Tan-Anfrage da!!!
      echo ($JobID . "\r\n"); 
      $TimeOut = false;
      $Erfolg = true;
      tunnel($AqErfolg . $JobID . ".tan-anfrage.txt");
      break; 
    }
    
    if (file_exists($AqError . $JobID . ".job" )) {

      // Es wurden Probleme gemeldet
      $TimeOut = false;
      tunnel($AqInfo . $JobID . ".log.txt");
      break; 
    }
    
    echo "INFO: [NA] Bisher keine Rückmeldung der Bank.\r\n";
    break;
  
 }
}


function itan() {

 global $JobID;
 global $pBLZ;
 global $pKontoNummer;
 global $AqErfolg, $AqError, $AqInfo;
 
 // aktuelle JobID verwerfen und "alte" ID verwenden!
 $JobID = $pBLZ;

 // TAN liefern
 aqTAN($pKontoNummer);

 $Erfolg = false;
 $TimeOut = true;
 $Gewartet = 0;
 
 while ($Gewartet<28) 
 {

   sleep(1);
   $Gewartet++;

   if (file_exists($AqErfolg . $JobID . ".job" )) 
   {

     // Job erfolgreich durchgefuehrt
     $TimeOut = false;
     $Erfolg = true;
     echo ("OK!\r\n");
     break; 
   }
 
   if (file_exists($AqError . $JobID . ".job" )) {

     // Es wurden Probleme gemeldet
     $TimeOut = false;
     tunnel($AqInfo . $JobID . ".log.txt");
     break; 
   }
 
 }

 if ($TimeOut) 
 {
  halt_timeout();
 }
 
 if ($Erfolg==false) 
 {
  echo "ERROR: iTAN ohne Erfolg\n\r";
 }
 
}

function nop() {
}

}
 
// Programm-Parameter aufbereiten
$_GLOBALS = array("rest","f");
foreach ($_GLOBALS as $var) {
  if (isset($_REQUEST[$var])) {
    $$var = $_REQUEST[$var];
  } else {
    $$var = "";
  }
  
}

list($FunktionsName, $pBLZ, $pKontoNummer, $pDatum) = array_pad(split("/", $rest),4,"");

// Bearbeitung des Funktionsnamens
$FunktionsName=strtolower($FunktionsName);
if ($FunktionsName=="") {
 $FunktionsName="info";
}
if ($FunktionsName=="version") {
 $FunktionsName="info";
}

// Debug-Ausgaben
if ($f=="debug") {

  echo"jobID: ". $JobID ."\n";
  echo "\$rest='". $rest . "'\r\n";
  echo "\$f='" . $f . "'\r\n";
  echo "\$HOME=" . getenv("HOME") . "\r\n";
  echo "Funktion: " . $FunktionsName . "\n";
  echo "BLZ: " . $pBLZ . "\n";
  echo "KTO: " . $pKontoNummer . "\n";
  echo "Date: " . $pDatum . "\n";
}

// REST Server Funktion rufen
tREST::$FunktionsName();

?>
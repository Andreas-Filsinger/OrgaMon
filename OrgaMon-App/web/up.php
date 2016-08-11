<?php
date_default_timezone_set('Europe/Berlin');

// Projekt Includes
include("t_errorlist.inc.php5");
include("t_xmlrpc.inc.php5");

// Projekt Konstanten
define("XMLRPCHost","raib23");
#define("XMLRPCHost","KHAO");
define("XMLRPCPort",3049);
define("XMLRPCPath","");

// Elaubte Aufruf-Parameter
$_GLOBALS = array("id","tan","proceed","data","info","m");
foreach ($_GLOBALS as $var) if (isset($_REQUEST[$var])) { $$var = $_REQUEST[$var]; }

$server_info = array();
$xmlrpc = txmlrpc::create(XMLRPCHost, XMLRPCPort, XMLRPCPath, 10);
$debug = "";

ob_start();  // START OUTPUT BUFFERING
$output = "";


function base_plug()
{ 
  global 
    $server_info, $xmlrpc;

  $server_info = $xmlrpc->sendRequest("jonda.BasePlug");
  return ($server_info!=NULL);
}

function get_new_tan($id)
{ 
  global 
   $xmlrpc;
  return $xmlrpc->sendRequest("jonda.StartTAN",array($id));
}

function proceed_tan($tan)
{ 
  global 
   $xmlrpc;
  return $xmlrpc->sendRequest("jonda.ProceedTAN",array($tan));
}

do {

// ID übergeben und neue TAN zurückliefern
// iGeraeteNo; iTAN ; VERSION ; iOptionen ; getTimestamp ; IMEI
if (isset($id)) { 
  if ($id != "") { 
    if (base_plug() == true) { 
	  $tan = get_new_tan($id);
      if ($tan != "00000") { 
	    $output = $tan; 
      }	else {
	    $output = "Geräte-ID ist ungültig.";
	  }	
    } else { 
	  $output = "XMLRPC-Server nicht verfuegbar.";
	  header("HTTP/1.1 500 Service Unavailable");
	}
  } 
  else {
    $output = "Es wurde keine ID übergeben."; 
  }
  break;
}
//*************

//
// Datensätze empfangen und abspeichern
// RID ; ZAEHLER_KORR ; ZAEHLER_NEU ; ZAEHLER_STAND_NEU ; 
// ZAEHLER_STAND_ALT ; REGLER_KORR ; REGLER_NEU ; PROTOKOLL ; 
// EINGABE_DATUM ; EINGABE_UHR
// 
if (isset($tan) AND isset($data)) 
{ 
  if (($tan != "") AND ($data != "")) 
  { 
    $filename = $tan . ".txt";

    $fp = fopen($filename, "a");
	if ($fp) 
	{
      if (flock($fp,LOCK_EX)) 
	  {
        fputs($fp,$data . ";" . date("d.m.Y - H:i:s")  . chr(0x0D) . chr(0x0A));
        flock($fp,LOCK_UN);
        fclose($fp);
	  }
	  else
	  {
	    $output = "Konnte keine LOCK auf $filename setzen.";
	    header("HTTP/1.1 500 Internal Server Error"); 
	    break;
	  }
	}
	else
	{
	  $output = "Konnte $filename nicht oeffnen.";
	  header("HTTP/1.1 500 Internal Server Error"); 
	  break;
	}
    
	// $debug = "*" . ob_get_contents() . "*";
	
    if (ob_get_length() == 0) 
	{ 
	 $output = "OK"; 
	}
    else
	{ 
	  $output = "Beim Speichern ist ein Fehler aufgetreten.";
	  header("HTTP/1.1 500 Internal Server Error"); 
	}
  } 
  else $output = "Es wurde keine TAN übergeben.";
  break;
}
//***************

// Meldung empfangen und abspeichern
if (isset($m) AND isset($data)) 
{ if (($m != "") AND ($data != "")) 
  { 
	  // NNN.txt, Gerätedatei
    $filename = "m-" . $m . ".txt";
    $fp = fopen($filename, "a");
    flock($fp,LOCK_EX);
    fputs($fp,$data . ";" . date("d.m.Y - H:i:s")  . chr(0x0D) . chr(0x0A));
    flock($fp,LOCK_UN);
    fclose($fp);
    
    // 000.txt, Sicherheitskopie aller Meldungen
    $filename = "m-000.txt";
    $fp = fopen($filename, "a");
    flock($fp,LOCK_EX);
    fputs($fp,$data . ";" . date("d.m.Y - H:i:s")  . ";" . $m . chr(0x0D) . chr(0x0A));
    flock($fp,LOCK_UN);
    fclose($fp);
    
	// $debug = "*" . ob_get_contents() . "*";
	
    if (ob_get_length() == 0) { $output = "OK"; }
    else
	{ $output = "Beim Speichern ist ein Fehler aufgetreten.";
	  header("HTTP/1.1 500 Internal Server Error"); 
	}
  } 
  else 
  {
   $output = "Geraete-No oder Daten erwartet";
  } 

  // fertig
  break;
}
//***************

// Transaktion verarbeiten durch XMLRPC-Aufruf
if (isset($proceed))
{ if ($proceed != "") 
  { if (base_plug() == true)
    { $result = proceed_tan($proceed);
      if ($result == 0) 
      { $output = "OK";
      }
      else 
      { $output = "MondaServer-Fehlercode: " . $result;
        header("HTTP/1.1 500 Internal Server Error");
      }
    }
  }
  else $output = "Es wurde keine TAN übergeben.";
  break;
}
//*********************

// Server-Info abrufen
if (isset($info)) 
{ if (base_plug() == true) { foreach($server_info as $value) $output .= $value . "<br />"; }
  else 
  { $output = "XMLRPC-Server nicht verfügbar.";
    header("HTTP/1.1 500 Service Unavailable"); 
  }
  break;
}

} while(false);

// OUTPUT BUFFER LEEREN UND BUFFERING BEENDEN
ob_end_clean();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<META HTTP-EQUIV="Pragma" content="no-cache">
<META HTTP-EQUIV="Cache-Control" content="no-cache, must-revalidate">
<META HTTP-EQUIV="Expires" content="0">
</HEAD>


<BODY><?php 
  echo $output;
  if ($debug != "") 
  { echo $debug; 
  }
?></BODY>
</HTML>
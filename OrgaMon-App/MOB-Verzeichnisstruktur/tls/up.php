<?php

//
//                          _
//       _   _ _ __   _ __ | |__  _ __
//      | | | | '_ \ | '_ \| '_ \| '_ \
//      | |_| | |_) || |_) | | | | |_) |
//       \__,_| .__(_) .__/|_| |_| .__/
//            |_|    |_|         |_|
//
//       (c) 2012 - 2021  Andreas Filsinger
//
//       Rev. 8.642
//


date_default_timezone_set('Europe/Berlin');
define("CRLF","\r\n");

//
// Projekt Includes
//
include("xmlrpc_client.php");

// Projekt Konstanten
$ini = parse_ini_file("../dat/cOrgaMon.ini");

$xmlrpc_host = $ini['host'];
$xmlrpc_port = $ini['port'];

// Elaubte Aufruf-Parameter
//
$_GLOBALS = array("id","tan","proceed","data","info","m");
foreach ($_GLOBALS as $var) 
 if (isset($_REQUEST[$var])) { 
  $$var = $_REQUEST[$var]; 
}

// Prüfen ob das Cookie passt
error_log ( "salt=" . $_COOKIE["salt"] );

//
// Globale Variable
//
$server_info = array();
$debug = "";
$output = "";

//
// Client für einen XMLRPC-Server erstellen 
//
$xmlrpc = new txmlrpc_client();
$xmlrpc->add(new tserver_identity($xmlrpc_host, $xmlrpc_port));

// *************************************************************

function base_plug() { 
  global 
    $server_info, $xmlrpc;

  $server_info = $xmlrpc->sendRequest("jonda.BasePlug");
  return ($server_info!=NULL);
}

// *************************************************************

function get_new_tan($id) { 
  global 
   $xmlrpc;

  return $xmlrpc->sendRequest("jonda.StartTAN",array($id));
}

// *************************************************************

function proceed_tan($tan) { 
  global 
   $xmlrpc;

  return $xmlrpc->sendRequest("jonda.ProceedTAN",array($tan));
}

//
// Haupt-Programm
//
do {

ob_start();  // START OUTPUT BUFFERING

// ID übergeben und neue TAN zurückliefern, 
// TTTTT.txt ist dann bereits erstellt
// $id = iGeraeteNo; iTAN ; VERSION ; iOptionen ; getTimestamp ; IMEI ; SALT
if (isset($id)) { 
  if ($id != "") { 
    if (base_plug() == true) { 
	  $tan = get_new_tan($id);
      if ($tan != "00000") { 
	    $output = $tan; 
      }	else {
	    $output = "Geraete-ID ist ungueltig.";
	  }	
    } else { 
	  $output = "XMLRPC-Server nicht verfuegbar.";
	  header("HTTP/1.1 500 Service Unavailable");
	}
  } 
  else {
    $output = "Es wurde keine ID uebergeben."; 
  }
  break;
}
//*************

//
// Datensätze empfangen und hinzufügen zu .\TTTTT.txt
//
// RID;ZAEHLER_KORR;ZAEHLER_NEU;ZAEHLER_STAND_NEU;ZAEHLER_STAND_ALT;REGLER_KORR;REGLER_NEU;PROTOKOLL;EINGABE_DATUM;EINGABE_UHR
// 
if (isset($tan) AND isset($data)) { 

  if (($tan != "") AND ($data != "")) { 

    $filename = $tan . ".txt";
    $fp = fopen($filename, "a");

	if ($fp) {
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
	
  if (ob_get_length() == 0) { 
	 $output = "OK"; 
	}
    else
	{ 
	  $output = "Beim Speichern ist ein Fehler aufgetreten.";
	  header("HTTP/1.1 500 Internal Server Error"); 
	}
  } 
  else $output = "Es wurde keine TAN uebergeben.";
  break;
}
//***************

// Meldung empfangen und abspeichern
if (isset($m) AND isset($data)) { 
 if (($m != "") AND ($data != "")) { 

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
    
    if (ob_get_length() == 0) { 
     $output = "OK"; 
    } else { 
     $output = "Beim Speichern ist ein Fehler aufgetreten.";
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
  else $output = "Es wurde keine TAN uebergeben.";
  break;
}
//*********************

// Server-Info abrufen
if (isset($info)) { 

 // Angesprochene OrgaMon-App-Server
 $output = $xmlrpc_host . ":" . $xmlrpc_port . "<br>";
 
 if (base_plug() == true) { 

  if (is_array($server_info)) 
  {
   foreach($server_info as $value) $output .= $value . "<br />"; 
  } else 
  {
   $output .= print_r($server_info);
  }
 }
 else { 

    $output .= "ERROR: XMLRPC-Server nicht verfuegbar.";
    header("HTTP/1.1 500 Service Unavailable"); 
    
 }
 break;
}
//*********************


} while(false);

// OUTPUT BUFFER LEEREN UND BUFFERING BEENDEN
ob_end_clean();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<HTML>
<HEAD>
 <title><?php 
  echo $ini['ftpuser'];
 ?>
 </title>
 <META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
 <META HTTP-EQUIV="Pragma" content="no-cache">
 <META HTTP-EQUIV="Cache-Control" content="no-cache, must-revalidate">
 <META HTTP-EQUIV="Expires" content="0">
</HEAD>


<BODY><?php 
  echo $output;
  if ($debug != "") { 
   echo $debug; 
  }
?></BODY>
</HTML>

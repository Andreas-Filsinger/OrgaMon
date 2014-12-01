<?php

// Kasse Rev 1.021

date_default_timezone_set('Europe/Berlin');
mb_internal_encoding("UTF-8");
ini_set('ibase.timestampformat', "%d.%m.%Y %H:%M:%S");
ini_set('ibase.dateformat', "%d.%m.%Y");
ini_set('ibase.timeformat', "%H:%M:%S");

header("Content-type: application/jsonrequest");

include("i_config.inc.php5");
include("t_errorlist.inc.php5");
include("t_xmlrpc.inc.php5");
include("t_ibase.inc.php5");
include("t_cryption.inc.php5");

$server_info = array();
$debug = "";

function base_plug()
{ 
  global 
   $server_info, $debug;

  $xmlcon = txmlrpc::create(XMLRPCHost, XMLRPCPort, XMLRPCPath, 5);
  $response = $xmlcon->sendRequest("abu.BasePlug");

  if (($response != NULL) AND (!$xmlcon->error)) {
  
    $server_info = $response;
    $xmlrpc = true;  
  }	else { 
   $xmlrpc = false; 
  }
  
  return $xmlrpc;
}

function decodePassword($password) 
  { if (strlen($password) == 48) // Password ist verschl�sselt
    { $hex = $password;
      $str = "";
      while (strlen($hex) > 1) 
	  { $str .= chr(hexdec(substr($hex,0,2)));
		$hex = substr($hex,2);
      }
	  $cryption = new tcryption("anfisoftOrgaMon");
	  $result = trim($cryption->decrypt($str));
	  unset($cryption);
    } 
	else  // Password ist in Klartext
	{ $result = $password;
    }
	return $result;
}

function logPOST(){

 global
  $HTTP_RAW_POST_DATA;  

    // Log 
    $fp = fopen("kasse.log.txt","a");
    flock($fp,LOCK_EX);
	fputs($fp,"--------------------------- " . date("d.m.Y - H:i:s") . "\n\r");
//	fputs($fp,$server_info[19] . "@" . $server_info[0] . "\n\r");
    fputs($fp,urldecode($HTTP_RAW_POST_DATA) . "\n\r");
    flock($fp,LOCK_UN);
    fclose($fp);

}
  
 logPOST();
 
 if (base_plug() == true) { 
 
 
    while (true) {
	
    // Datenbank �ffnen
    $ibase = tibase::create($server_info[0],
                           $server_info[17],
		                   decodePassword($server_info[19]) );
	if (is_null($ibase)) {
      echo ("{ ERROR: \"".$server_info[17]." konnte Datenbank '".$server_info[0]."' nicht oeffnen\" }");
	  break;
	}
						   
	// Ereignis-RID erzeugen!
	$rid = $ibase->gen_id("EREIGNIS_GID");
	if ($rid<1) {
      echo ("{ ERROR: \"Ereignis RID nicht erhalten\" }");
	  break;
	}

	// Anfrage reinschreiben Firebird Server 2.x
    if (!$ibase->insert(
	  "insert into EREIGNIS (RID,ART,INFO) values (" .
	  " " . $rid . "," .
	  " 17," .
	  " '" . $HTTP_RAW_POST_DATA . "')")) {
      echo ("{ ERROR: \"Einf�gen in die Datenbank ohne Erfolg\" }");
	  break;
	} 
	unset($ibase);

    // Ergebnis JSON Formatiert ausgeben
    echo ("{ Buch: \"" . $rid . "\" }");
	unset($rid);

    break;
	 
	}

 } else { 
  echo ("{ ERROR: \"XMLRPC l�uft nicht\" }");
 }
 
 

?>
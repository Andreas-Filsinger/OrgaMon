<?php
if (file_exists($includefile = "i_xmlrpc_ip.inc.php5")) include_once($includefile);
// VERBINDUNGSDATEN
if (!defined("XMLRPC_HOST")) define("XMLRPC_HOST","NEMO");
define("XMLRPC_PORT",3049);
define("XMLRPC_PATH","");

// PFADE
define("MP3_PATH","./music/");

// STANDARDWERTE
define("DEFAULT_LANGUAGE","english");
define("DEFAULT_CURRENCY","$");
define("TERMS_OF_BUSINESS","tob.txt");
?>
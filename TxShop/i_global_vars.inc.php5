<?php
define("_PROJECTNAME","TFakeShop");

$_PHPEXTENSIONS = array("xmlrpc","interbase","session","mcrypt");
$_GLOBALS = array("site","action","id", // ALLGEMEIN
                  "expression",         // SUCHE  
                  "quantity",           // EINKAUFSWAGEN
                  "name","address","city","state_country","zip","phone","email" // BESTELLUNG
				 );

define("LF","\n");				 
define("CRLF","\r\n");
define("TAB","\t");

foreach ($_GLOBALS as $_GLOBAL) if (isset($_REQUEST[$_GLOBAL])) { $$_GLOBAL = $_REQUEST[$_GLOBAL]; }

//PFADE (MIT ABSCHLIESSENDEM SLASH)
define("__PNG_PATH","./png/");
define("__CLASS_PATH","./class/");

// TABELLENNAMEN
define("TABLE_ARTICLE","ARTIKEL");
define("TABLE_CART","WARENKORB");
define("TABLE_CATEGORY","SORTIMENT");
define("TABLE_DOCUMENT","DOKUMENT");
define("TABLE_GENUS","GATTUNG");
define("TABLE_MUSICIAN","MUSIKER");
define("TABLE_PERSON","PERSON");
define("TABLE_PUBLISHER","VERLAG");

?>
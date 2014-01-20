<?php
define("__LANG_PATH","./lang/");

if (!isset($s_language)) { $s_language = DEFAULT_LANGUAGE; }
$_SESSION["s_language"] = $s_language;

if (file_exists($includefile = __LANG_PATH . "l_" . $s_language . ".inc.php5")) include_once($includefile);
else include_once(__LANG_PATH . "l_default.inc.php5"); 

?>
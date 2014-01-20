<?php

define("CRLF","\r\n");
define("CSV_SEPARATOR",";");
define("VERSION","4.011");

$_GLOBALS = array("country","street","number","city","district","zip","x","y","z","profile");
foreach ($_GLOBALS as $_GLOBAL) if (isset($_REQUEST[$_GLOBAL])) { $$_GLOBAL = $_REQUEST[$_GLOBAL]; }

?>
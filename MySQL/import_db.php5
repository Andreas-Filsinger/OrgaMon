<?php
include_once("i_include_path.inc.php5");
include_once("t_db_connection.inc.php5");

include_once((file_exists(INCLUDE_PATH."i_global_funcs.inc.php5")) ? INCLUDE_PATH."i_global_funcs.inc.php5" : "i_global_funcs.inc.php5"); // Globale Funktionensammlung
include_once(INCLUDE_PATH."i_db_config.inc.php5");
include_once(INCLUDE_PATH."i_custom_vars.inc.php5");  // Sicherheitsrelevante Inhalte wie Zuganskennungen und Passwörter
include_once(INCLUDE_PATH."i_global_vars.inc.php5");  // Globale Konstanten und Registrierung der globalen Variablen (register_globals=off)

include_once((file_exists(INCLUDE_PATH."t_errorlist.inc.php5")) ? INCLUDE_PATH."t_errorlist.inc.php5" : "t_errorlist.inc.php5"); // Klasse zur Fehlerausgabe
include_once((file_exists(INCLUDE_PATH."t_dbase.inc.php5")) ? INCLUDE_PATH."t_dbase.inc.php5" : "t_dbase.inc.php5");        // Klasse zur Datenbank-Anbindung

$import_file = $_REQUEST["import_file"];

$db = $db_toggle[MYSQL_NAME];

$errorlist = terrorlist::create();
$dbase = tdbase::create($db->host,$db->user,$db->password,$db->name);
$statements = preg_split("/;\r+\n+/",file_get_contents($import_file));
foreach($statements as $sql)
{ $sql = trim($sql); 
  if ($sql != "") 
  { $dbase->query($sql);
	if ($errorlist->error) { echo $errorlist->getAsString(); }
  }
}
$count = $dbase->get_field("SELECT COUNT(RID) AS COUNT FROM ARTIKEL","COUNT");

echo "<html>\r\n<head>\r\n</head>\r\n<body>\r\n";
echo "COUNT=$count\r\n";
echo "</body>\r\n</html>";

?>
<?php
include_once("i_include_path.inc.php5");
include_once("t_db_connection.inc.php5");
include_once(INCLUDE_PATH."i_db_config.inc.php5");
include_once(INCLUDE_PATH."i_custom_vars.inc.php5");

// var_dump($mysql_dbs);
// echo MYSQL_NAME;

$template = file_get_contents("i_db_config.inc.unchanged.php5");
$db = $db_toggle[MYSQL_NAME];
file_put_contents(INCLUDE_PATH."i_db_config.inc.php5",$db->integrate($template));

echo "<html>\r\n<head>\r\n</head>\r\n<body>\r\n";
echo "DB=$db->name\r\n";
echo "</body>\r\n</html>";

?>
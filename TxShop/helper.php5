<?php
define("MYSQL_IMPORT_FILE","mysql.dump.txt");

$lines = file(MYSQL_IMPORT_FILE);

$data = "";
for($i=1; $i < count($lines); $i++) $data.= $lines[$i]; 

file_put_contents(MYSQL_IMPORT_FILE,$data);


?>
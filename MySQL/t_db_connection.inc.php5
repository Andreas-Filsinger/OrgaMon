<?php
define("MYSQL_HOST_01","db288.perfora.net");
define("MYSQL_NAME_01","db152895239");
define("MYSQL_USER_01","dbo152895239");
define("MYSQL_PASSWORD_01","9WDyvt3J");

define("MYSQL_HOST_02","db327.perfora.net");
define("MYSQL_NAME_02","db158476282");
define("MYSQL_USER_02","dbo158476282");
define("MYSQL_PASSWORD_02","wAqqD8ka");

class tdb_connection
{ public $host = "";
  public $name = "";
  public $user = "";
  public $password = "";
  
  public function __construct($host,$user,$password,$name)
  { $this->host = $host;
    $this->user = $user;
	$this->password = $password;
	$this->name = $name;
  }
  
  public function integrate($template)
  { $template = str_replace("~MYSQL_HOST~",$this->host,$template);
    $template = str_replace("~MYSQL_USER~",$this->user,$template);
	$template = str_replace("~MYSQL_PASSWORD~",$this->password,$template);
	$template = str_replace("~MYSQL_NAME~",$this->name,$template);
	$template = str_replace("~IBASE_NAME~",$this->host,$template);
	$template = str_replace("~IBASE_USER~",$this->user,$template);
	$template = str_replace("~IBASE_PASSWORD~",$this->password,$template);
	$template = str_replace("~IBASE_NAME~",$this->name,$template); 
	return $template;
  }
  
  public function info()
  { return "Host: {$this->host}\r\nName: {$this->name}";
  }
}

$db_toggle = array(MYSQL_NAME_01 => new tdb_connection(MYSQL_HOST_02,MYSQL_USER_02,MYSQL_PASSWORD_02,MYSQL_NAME_02), 
                   MYSQL_NAME_02 => new tdb_connection(MYSQL_HOST_01,MYSQL_USER_01,MYSQL_PASSWORD_01,MYSQL_NAME_01));

?>
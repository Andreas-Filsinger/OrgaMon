<?php

define("DBASE","MYSQL"); // "MYSQL" oder "IBASE" möglich

class tdbase
{ static private $instance = NULL;
  
  static public function create($host = "", $user = "", $pass = "", $name = "")
  { include_once("t_" . strtolower(DBASE) . ".inc.php5");
    if (tdbase::$instance == NULL) 
	{ switch(DBASE)
      { case("MYSQL"):
	    { tdbase::$instance = tmysql::create($host,$user,$pass,$name); break; }
        case("IBASE"):
	    { tdbase::$instance = tibase::create($host,$user,$pass); break; }	
      }
	}
	return tdbase::$instance; 
  }
  
  public function __destruct()
  { tdbase::$instance->__destruct();
  }
}

?>
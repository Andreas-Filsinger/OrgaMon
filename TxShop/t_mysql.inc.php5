<?php

define("MYSQL_DEFAULT_HOST","");
define("MYSQL_DEFAULT_NAME","");
define("MYSQL_DEFAULT_USER","");
define("MYSQL_DEFAULT_PASSWORD","");

class tmysql
{ static private $instance = NULL;
  static public $connected = false;
  private $handle = 0;
  private $result = 0;
  private $errorlist = NULL;
  
  public $sql = "";
  private $insert_id = 0;  
  
  static private $errormsg = array("Die Datenbankverbindung konnte nicht hergestellt werden [~ERROR~]");
  
  static public $name = "PHP5CLASS T_MYSQL";
  
  private function __construct($host, $user, $passwd, $name)
  { $this->errorlist = terrorlist::create();
    $this->handle = @mysql_connect($host,$user,$passwd);
    if ($this->handle == false) 
	{ $this->set_error(0);
	  tmysql::$connected = false; 
	}
    else 
	{ if ($name != "") 
	  { mysql_select_db($name,$this->handle); 
	  }
	  tmysql::$connected = true;
	}
  }
  
  static public function create($host = MYSQL_DEFAULT_HOST, $user = MYSQL_DEFAULT_USER, $passwd = MYSQL_DEFAULT_PASSWORD, $name = MYSQL_DEFAULT_NAME)
  { if (!tmysql::$instance)
    { tmysql::$instance = new tmysql($host,$user,$passwd,$name);
	  if (tmysql::$connected == false) { tmysql::$instance = NULL; } 
	}
    return tmysql::$instance;
  }

  public function __destruct()
  { if (tmysql::$connected) { mysql_close($this->handle); }
	$this->instance = false;
  }
  
  public function query($sql = "")
  { if ($sql == "" AND $this->sql != "") { $sql = $this->sql; }
    $this->result = mysql_query($sql,$this->handle);
	//if (($error = mysql_error()) != "") $this->errorlist->add($error);
	if (!$this->result) $this->errorlist->add(mysql_error());
	$this->sql = $sql;
    return $this->result;
  }
  
  public function insert($sql)
  { return $this->query($sql);
  }
  
  public function update($sql)
  { return $this->query($sql);
  }
  
  public function fetch_object($result = false)
  { if (!$result) { $result = $this->result; }
    return mysql_fetch_object($result); 
  }
  
  public function fetch_array($result = false)
  { if (!$result) { $result = $this->result; }
    return mysql_fetch_array($result);
  }
  
  public function fetch_assoc($result = false)
  { if (!$result) { $result = $this->result; }
    return mysql_fetch_assoc($result); 
  }
  
  public function serialize_result($result = false, $separator = ",")
  { if (!$result) { $result = $this->result; }
    $serialized = "";
    while($data = mysql_fetch_row($result)) { $serialized .= implode($separator, $data) . $separator;	}
	return substr($serialized,0,-strlen($separator));
  }
  
  public function get_field($sql,$name = "RID")
  { $this->query($sql);
    $data = $this->fetch_object();
    $this->free_result();
    return (isset($data->{$name})) ? ($data->{$name}) : (false);
  }
  
  public function get_list_as_string($sql,$name = "RID", $separator = ",")
  { $this->query($sql);
    $str = "";
    while($data = $this->fetch_object()) { $str.= $data->{$name} . $separator; }
    $this->free_result();
    return substr($str,0,-strlen($separator));;
  }
  
  public function get_list_as_array($sql, $name = "RID")
  { if ($sql == "") { $sql = $this->sql; }
    $this->query($sql);
    $arr = array();
    while($data = $this->fetch_object()) { $arr[] = $data->{$name}; }
	$this->free_result();
	return $arr;
  }
  
  public function get_list_as_associated_array($sql, $name = "RID", $index = "RID")
  { $this->query($sql);
    $arr = array();
    while($data = $this->fetch_object()) { $arr[$data->{$index}] = $data->{$name}; }
	$this->free_result();
	return $arr;
  }
  
  public function get_fields($table)
  { $this->sql = "SHOW COLUMNS FROM $table";
    $this->query();
	$fields = array();
	while($data = $this->fetch_array()) $fields[] = $data[0];
	return $fields;
  }
  
  public function insert_id()
  { $this->insert_id = mysql_insert_id($this->handle);
    return $this->insert_id;
  }
  
  public function free_result($result = false)
  { if (!$result) { $result = $this->result; }
    mysql_free_result($result); 
  }
  
  public function error()
  { return array(strval(abs(mysql_errno())),mysql_error());
  }
  
  static function flip_date($datetime, $separator = "-")
  { return substr($datetime,8,2) . $separator . substr($datetime,5,2) . $separator . substr($datetime,0,4); 
  }
  
  static function iso_date($date)
  { return substr($date,6,4) . "-" . substr($date,3,2) . "-" . substr($date,0,2);
  }
  
  static function date($datetime, $separator = "-")
  { return substr($datetime,0,4) . $separator . substr($datetime,5,2) . $separator . substr($datetime,8,2);
  }
  
  static function time($datetime)
  { return substr($datetime,11,5); 
  }
  
  private function set_error($i)
  { $this->errorlist->add($this->__toString() . ": ". str_replace("~ERROR~",trim(implode($this->error(),":")),tmysql::$errormsg[$i]));
  }
  
  public function __toString()
  { return tmysql::$name; }
  
}

?>
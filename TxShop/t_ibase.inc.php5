<?php

define("IBASE_DEFAULT_HOST","");
define("IBASE_DEFAULT_NAME","");
define("IBASE_DEFAULT_USER","");
define("IBASE_DEFAULT_PASSWORD","");

class tibase
{ static private $instance = NULL;
  static public $connected = false;
  private $handle = 0;
  private $result = 0;
  private $errorlist = NULL;
  
  public $sql = "";
  private $insert_id = 0;
  
  static private $errormsg = array("Die Datenbankverbindung konnte nicht hergestellt werden [~ERROR~]");
  
  static private $name = "PHP5CLASS T_IBASE";

  private function __construct($name, $user, $passwd)
  { $this->errorlist = terrorlist::create();
    $this->handle = @ibase_connect($name,$user,$passwd);
    if ($this->handle == "") 
	{ $this->set_error(0);
	  tibase::$connected = false;
	} 
	else 
	{ tibase::$connected = true; 
	}
  }
  
  
  
  
  static public function create($name = IBASE_DEFAULT_NAME, $user = IBASE_DEFAULT_USER, $passwd = IBASE_DEFAULT_PASSWORD)
  { if (!tibase::$instance)
    { tibase::$instance = new tibase($name,$user,$passwd);
	  if (tibase::$connected == false) { tibase::$instance = NULL; }
	}
	return tibase::$instance;
  }

  public function __destruct()
  { if (tibase::$connected) { ibase_close($this->handle); }
	$this->instance = NULL;
  }
  
  public function query($sql = "")
  { if (($sql == "") AND ($this->sql != "")) { $sql = $this->sql; }
    $this->result = ibase_query($this->handle,$sql);
	if (($error = ibase_errmsg()) != "") $this->errorlist->add($error);
	$this->sql = $sql;
    return $this->result;
  }
  
  public function insert($sql = "", $table = "")
  { $transaction = ibase_trans(IBASE_COMMITTED,$this->handle);
  	$insert = ibase_query($transaction,$sql);
	if ($table != "") 
	{ $sql = "SELECT GEN_ID(GEN_DOKUMENT,0) AS RID FROM RDB\$DATABASE";
      $result = ibase_query($transaction,$sql);
	  $data = $this->fetch_object($result);
	  $this->free_result($result);
	  $this->insert_id = $data->RID;
	}
	ibase_commit($transaction);
	return $insert; 
  }
  
  public function update($sql = "")
  { $transaction = ibase_trans(IBASE_COMMITTED,$this->handle);
  	$update = ibase_query($transaction,$sql);
	ibase_commit($transaction);
	return $update;
  }
  
  public function fetch_object($result = false)
  { if (!$result) { $result = $this->result; }
    return ibase_fetch_object($result); 
  }
  
  public function fetch_assoc($result = false)
  { if (!$result) { $result = $this->result; }
    return ibase_fetch_assoc($result); 
  }
  
  public function serialize_result($result = false, $separator = ",")
  { if (!$result) { $result = $this->result; }
    $serialized = "";
    while($data = ibase_fetch_row($result)) { $serialized .= implode($separator, $data) . $separator;	}
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
  
  public function get_list_as_array($sql = "", $name = "RID")
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
  
  public function insert_id()
  { return $this->insert_id;
  }
  
  public function free_result($result = false)
  { if (!$result) { $result = $this->result; }
    ibase_free_result($result); 
  }
  
  public function error()
  { return array(strval(abs(ibase_errcode())),ibase_errmsg());
  }
  
  static function flip_date($date, $separator = "-")
  { return substr($date,8,2) . $separator . substr($date,5,2) . $separator . substr($date,0,4); 
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
  { $this->errorlist->add($this->__toString() . ": ". str_replace("~ERROR~",trim(implode($this->error(),":")),tibase::$errormsg[$i]));
  }
  
  public function __toString()
  { return tibase::$name; }
}

?>
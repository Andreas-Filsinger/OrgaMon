<?php
// TXMLRPC CLASS, PHP5
// by Thorsten Schroff, 2011

//[08-Dec-2011 05:33:53] PHP Warning:  DOMDocument::saveXML(): string is not in UTF-8 in /srv/www/htdocs/hebu-music/t_xmlrpc.inc.php5 on line 55

define("XMLRPC_DEFAULT_HOST","localhost");
define("XMLRPC_DEFAULT_PORT",3049);
define("XMLRPC_DEFAULT_PATH","");
define("XMLRPC_DEFAULT_USER","");
define("XMLRPC_DEFAULT_PASSWORD","");
define("XMLRPC_DEFAULT_TIMEOUT",80);
define("XMLRPC_DEFAULT_RETRIES",2); //TS 23-04-2012: wie oft wird nach dem ersten Fehlschlagen wiederholt? Wert 2 bedeutet: insgesamt 3 Versuche
                                    //TS 23-04-2012: ToDo: noch nicht von Aussen (i_config.inc.php5) setzbar
define("XMLRPC_DEFAULT_LOG","xmlrpc.log"); //TS 23-04-2012: ToDo: noch nicht Aussen (i_config.inc.php5) abgebildet, aber setzbar über Konstruktor 

require_once("t_host.inc.php5");

class txmlrpc
{ const CRLF = "\r\n";
  const BLOCK_SIZE = 32768;
  
  const CLASS_NAME = "PHP5CLASS T_XMLRPC";

  static public function encodeRequest($method, $params)
  { $xml = new DOMDocument();
    $x_methodCall = $xml->createElement("methodCall");
	//echo $method;
    $x_methodName = $xml->createElement("methodName");
    $x_methodName->appendChild($xml->createTextNode($method));
	$x_params = $xml->createElement("params");  
	if ($params == NULL)
	{ $x_param = $xml->createElement("param");
      $x_value = $xml->createElement("value");
	  $x_type = $xml->createElement("string");
	  $x_value->appendChild($x_type);
	  $x_param->appendChild($x_value);
	  $x_params->appendChild($x_param);
	}
	if (is_array($params))
	{ foreach($params as $param)
      { $x_param = $xml->createElement("param");
        $x_value = $xml->createElement("value");
        switch(true)
	    { case(is_int($param))   : { $x_type = $xml->createElement("int");    break; }
	      case(is_double($param)): { $x_type = $xml->createElement("double"); break; }
	      case(is_string($param)): { $x_type = $xml->createElement("string"); break; }
	      case(is_array($param)) : { $x_type = $xml->createElement("array");  break; }
	      case(is_object($param)): { $x_type = $xml->createElement("object"); break; }
		  case(is_bool($param))  : { $x_type = $xml->createElement("boolean"); break; }
          default: { $xtype = $xml->createElement("unknown type"); break; }
        } // switch
	    $x_type->appendChild($xml->createTextNode(htmlentities($param)));
	    $x_value->appendChild($x_type);
	    $x_param->appendChild($x_value);
	    $x_params->appendChild($x_param);
	  }
    }
    $x_methodCall->appendChild($x_methodName);
    $x_methodCall->appendChild($x_params);
    $xml->appendChild($x_methodCall);
    return $xml->saveXML();
  }
  
  static private function getAsPHPVariable($xml_var)
  { switch($xml_var->nodeName)
    { case("array"):
      { $xml = new DOMDocument();
	    $xml->appendChild($xml->importNode($xml_var,true));
	    $xp = new DOMXPath($xml);
	    $php_var = array();
	    foreach($xp->query("//array/data/value/child::*") as $xml_var) $php_var[] = self::getAsPHPVariable($xml_var);
	    unset($xml);
	    unset($xp);
	    break;
	  }
	  case("string"):  { $php_var = strval($xml_var->nodeValue); break; }
	  case("int"):     { $php_var = intval($xml_var->nodeValue); break; }
	  case("double"):  { $php_var = doubleval($xml_var->nodeValue); break; }
	  case("boolean"): { $php_var = (intval($xml_var->nodeValue) == 0) ? false : true; break; }
	  default:         { $php_var = "return type unknown"; break; }
    }
    return $php_var;
  }
  
  static public function encodeResponse($xml)
  { $xml = DOMDocument::loadXML(utf8_encode($xml));
    try
	{ $xp = new DOMXPath($xml);
	  $xml_vars = $xp->query("//params/param/value/child::*");
      switch($xml_vars->length)
      { case(0): { $result = NULL ; break; }
        case(1): { $result = self::getAsPHPVariable($xml_vars->item(0)); break; }
	    default: 
	    { $result = array();
	      foreach($xml_vars as $xml_var) $result[] = self::getAsPHPVariable($xml_var); 
	      break; 
	    }
      }
	}
	catch(Exception $e)
	{ $result = NULL;
	}
    return $result;
  }
  
  static public function decodeResponse($xml)
  { $xml = DOMDocument::loadXML(utf8_encode($xml));
    try
	{ $xp = new DOMXPath($xml);
	  $xml_vars = $xp->query("//params/param/value/child::*");
      switch($xml_vars->length)
      { case(0): { $result = NULL ; break; }
        case(1): { $result = self::getAsPHPVariable($xml_vars->item(0)); break; }
	    default: 
	    { $result = array();
	      foreach($xml_vars as $xml_var) $result[] = self::getAsPHPVariable($xml_var); 
	      break; 
	    }
      }
	}
	catch(Exception $e)
	{ $result = NULL;
	}
    return $result;
  }
  
  static public function crlf($n = 1)
  { $crlf = ""; 
    for ($i = 0; $i < $n; $i++) $crlf .= self::CRLF;
	return $crlf;
  }
  
}

class txmlrpc_client
{ static private $instance = NULL;

  private $id = "";
  
  private $hosts = array(); // TS 09-05-2012: array of thost
  private $count = 0;       // TS 09-05-2012: Anzahl der Hosts - 1
  private $active = 0;      // TS 09-05-2012: aktiver Host
  private $bad = array();   // TS 10-05-2012: Gedächtnis für "schlechte" Hosts (die einen Fehler erzeugt haben)
    
  //public $server = "";
  //public $port = 0;
  //public $path = "";
  //public $timeout = 0;
  //private $log = "";
  
  private $method = "";
  private $params = "";
  private $xml = "";
  private $php = NULL;
  
  private $try = 0;
  
  public $xml_request = "";
  public $xml_response = "";
  
  //private $user = "";
  //private $password = "";
  
  public $error = false;
  public $errno = 0;
  public $errstr = "";
  
  private $time_sub_method_level = 0;
  private $time_started = 0.0;
  private $time_stopped = 0.0;
  private $time_needed  = 0.0;
  
  const CLASS_NAME = "PHP5CLASS T_XMLRPC_CLIENT";
      
  private function __construct($host,$port,$path,$timeout,$retries)
  { //$this->errorlist = terrorlist::create();
    if (is_string($host) OR is_object($host))
	{ $this->addHost($host,$port,$path,XMLRPC_DEFAULT_USER,XMLRPC_DEFAULT_PASSWORD,$timeout,$retries);
	}
	else if (is_array($host)) 
	{ $this->setHosts($host);
    }
  }

  static public function create($host = XMLRPC_DEFAULT_HOST, $port = XMLRPC_DEFAULT_PORT, $path = XMLRPC_DEFAULT_PATH, $timeout = XMLRPC_DEFAULT_TIMEOUT, $retries = XMLRPC_DEFAULT_RETRIES)
  { if (!self::$instance) 
    { self::$instance = new txmlrpc_client($host,$port,$path,$timeout,$retries);
	}
	return self::$instance;
  }
  
  private function addHost($host,$port,$path,$user,$password,$timeout,$retries)
  { if (is_string($host))
    { $this->hosts[] = new thost($host,$port,$path,$user,$password,$timeout,$retries);
	}
	if (is_object($host)) 
	{ $this->hosts[] = $host;
	}
	$this->countHosts();
  }
  
  private function setHosts($hosts)
  { $this->hosts = $hosts;
    $this->countHosts();  
  }
  
  private function countHosts()
  { $this->count = count($this->hosts);
    return $this->count;
  }
  
  public function getHost()
  { return $this->hosts[$this->active];
  }
  
  private function incHost()
  { $tmp = $this->active;
    $this->active++;
    if ($this->active >= $this->count)
	{ $this->active = 0;
	}
    //TS 10-05-2012: Prüfen! Kann hier eine Endlos-Schleife entstehen, wenn alle Hosts ausfallen?
	//               -> Lösung: den Block nur aufrufen, solange noch mindestens ein Host funktioniert (2. Bedingung in der nächsten Zeile)
	if ($this->isBadHost($this->active) AND count($this->bad) < $this->count)
    { $this->incHost();
	}
	return true;
  }
  
  private function markHostAsBad($id)
  { $this->bad[$id] = $id;
    // TS 10-05-2012: $id auch als Index, um sicherzugehen, dass jeder schlechte Host nur ein Array-Elemet erzeugt
  }
  
  private function isBadHost($id)
  { return in_array($id, $this->bad);
  }
  
  private function buildID()
  { //die ersten 8 Zeichen eines MD5?
    //mit was wird der md5 gefüttert? Methodenname und Parameter, Datum, Uhrzeit, Remote-IP? Letzteres wäre ziemlich eindeutig.
	$this->id = strtoupper(substr(md5($this->getID() . "_" . $this->getMethod() . "_" . date("Y-m-d H:i:u") . "_" . $_SERVER["REMOTE_ADDR"]),0,8));
	return $this->id;
  }
  
  public function getID()
  { return $this->id;
  }
  
  private function setMethod($method = "")
  { $this->method = $method; 
  }
  
  public function getMethod()
  { return $this->method; 
  }
  
  private function setParams($params)
  { $this->params = $params; 
  }
  
  private function getParams()
  { return $this->params;
  }
 
  //public function setUser($user = XMLRPC_DEFAULT_USER)
  //{ $this->user = $user; 
  //}
  
  //public function getUser()
  //{ return $this->user; 
  //}
 
  //public function setPassword($password = XMLRPC_DEFAULT_PASSWORD)
  //{ $this->password = $password; 
  //}
  
  private function getHeader()
  { $auth = "";
    if ($this->getHost()->getUser() != "") { $auth = "Authorization: Basic " . base64_encode($this->getHost()->getUser() . ":" . $this->getHost()->getPassword()) . txmlrpc::crlf(); }
    $header = "POST {$this->getHost()->getPath()} HTTP/1.0".txmlrpc::crlf()."User-Agent: ".self::CLASS_NAME.txmlrpc::crlf()."Host: {$this->getHost()->getName()}".txmlrpc::crlf().
	          "{$auth}Content-Type: text/xml".txmlrpc::crlf()."Content-Length: " . strlen($this->xml) . txmlrpc::crlf(2);
    return $header;
  }
  
  private function cutHeader($payload)
  { //var_dump($payload);
    $pos = strpos($payload,txmlrpc::crlf(2)."<?xml",1);
    if ($pos !== false) 
	{ $this->xml_response = substr($payload,$pos+strlen(txmlrpc::crlf(2))); 
	}
	else 
	{ $this->setError(102,"Keine Antwort"); $this->xml_response = ""; 
	}
	return $this->xml_response;
  }
     
  private function toXML()
  { if (in_array("xmlrpc",get_loaded_extensions()))
    { $this->xml_request = xmlrpc_encode_request($this->method,$this->params); 
	}
    else 
	{ $this->xml_request = txmlrpc::encodeRequest($this->method,$this->params); 
	}
	//echo "<pre>" . htmlentities($this->xml_request) . "</pre>";
	return $this->xml_request;
  }
  
  private function fromXML()
  { //echo "<pre>" . htmlentities($this->xml) . "</pre>";
    if (in_array("xmlrpc",get_loaded_extensions()))
	{ $this->php = xmlrpc_decode_request($this->xml,$this->method); 
	}
	else 
	{ $this->php = txmlrpc::decodeResponse($this->xml); 
	}
	return $this->php;
  }
  
  private function resetTry()
  { $this->try = 0;
  }
  
  private function incTry()
  { $this->try++;
  }
  
  public function getTry()
  { return $this->try;
  }

  private function overHTTP($timeout)
  { //echo wrap($timeout);
    $result = false;
	$active = $this->active; 
	
	do
	{ $this->resetTry();
	  $this->resetError();
	  
	  //trigger_error($this->active, E_USER_NOTICE);
	 
	  $server = $this->getHost()->getName();
	  $port = $this->getHost()->getPort();
	  $timeout = ($timeout == 0) ? $this->getHost()->getTimeout() : $timeout;
	  $retries = $this->getHost()->getRetries();
	
	  while($result == false AND $this->getTry() <= $retries)
	  { $this->incTry();
		
		//trigger_error($server, E_USER_NOTICE);
			
	    $fp = @fsockopen($server, $port, $errno, $errstr, $timeout);
		
        if (!$fp) 
	    { $this->setError(100, $server . "::" . $port . ": " . "Socketverbindung konnte nicht geoeffnet werden");
	      trigger_error("XMLRPC(100): was unable to open socket " . $server . ":" . $port , E_USER_WARNING);
	      //return(false);
		  continue;
	    }

	    $payload = $this->getHeader().$this->xml;
	    if (!@fputs($fp,$payload,strlen($payload))) 
	    { $this->setError(101,"Fehler beim Senden");
	      trigger_error("XMLRPC(101): error when sending", E_USER_WARNING); 
          @fclose($fp);
	      //return(false);
		  continue;
	    }
	
	    $payload = "";
	    @stream_set_timeout($fp, $timeout); // ts 13-08-2007: deprecated: socket_set_timeout($fp, $timeout);

	    while($data = @fread($fp, txmlrpc::BLOCK_SIZE)) 
	    { $payload .= $data; 
	    }
	
        $info = @stream_get_meta_data($fp);
	    if ($info["timed_out"])
	    { $this->setError(102,"Timeout der Verbindung nach $timeout Sekunden"); 
	      trigger_error("XMLRPC(102): timeout after $timeout seconds", E_USER_WARNING);
          @fclose($fp);
	      //return false;
		  continue;
	    }
	    @fclose($fp);
	    //return $payload;
	    $result = $payload;
	  }
	  
	  if($this->error == true) $this->markHostAsBad($this->active);
	  
	  $this->incHost();
	  
	  if ($this->error != true) break;
	  
	} while($this->active != $active);
	return $result;
  }
  

  public function sendRequest($method, $params = "", $timeout = 0)
  { $this->startTime();
  	
    if ($method != "") 
	{ $this->setMethod($method);
	  if ($params != "") 
	  { $this->setParams($params); 
	  }
	  $this->buildID();
	  //$this->addToLog("START / ID: " . $this->getID() . " / METHOD: " . $method . " / PARAMCOUNT: " . count($this->getParams()));
	  $this->xml = $this->toXML();
	  $response = $this->overHTTP($timeout);
	}
    else 
	{ $this->setError(800,"Es wurde keine Methode angegeben"); 
	  $response = false;
	}
	
	if ($response == false)
	{ $result = NULL;
	  //echo "NULL";
	}
	else 
	{ $this->xml = $this->cutHeader($response);
	  if ($this->xml == "") 
	  { $result = NULL; 
	  } 
	  else
	  { $result = $this->fromXML();
	    if (is_array($result) AND array_key_exists("faultCode",$result)) 
		{ $this->setError($result["faultCode"],$result["faultString"]); 
		  $result = NULL; 
		}
	  }
	}
	
	$this->stopTime();
	//$this->addToLog("STOP  / ID: " . $this->getID() . " / METHOD: " . $method . " / XMLCOUNT: " . strlen($this->xml) . " / TRIES: " . $this->getTry() . " / NEEDED: " . $this->getTime());
	return $result;
  }
  
  
  private function setError($no, $str)
  { $this->error = true;
    $this->errno = $no;
	$this->errstr = $str . " [method: " . $this->method . "]";
	//$this->errorlist->add($this->__toString() . ": " . $this->errstr);
  }
  
  private function resetError()
  { $this->error = false;
    $this->errno = 0;
	$this->errstr = "";
  }
  
  private function startTime()
  { if ($this->time_sub_method_level == 0) 
    { $this->time_started = microtime(true);
    }
    $this->time_sub_method_level++;
  }
  
  private function stopTime()
  { $this->time_sub_method_level--;
    if ($this->time_sub_method_level == 0) 
	{ $this->time_stopped = microtime(true);
	  $this->time_needed += $this->time_stopped - $this->time_started;
    }
  }
  
  public function getTime()
  { return $this->time_needed;
  }
  
  public function addToLog($entry)
  { if (!empty($this->log)) 
    { $entry = date("d-m-Y H:i:s") . " --- " . $entry . txmlrpc::crlf(); 
      file_put_contents($this->log,$entry,FILE_APPEND);
	}
  }
  
  public function __wakeup()
  { self::$instance = $this;
    //$this->time_started = 0.0;
    //$this->time_stopped = 0.0;
    //$this->time_needed  = 0.0;
  }
  
  public function __toString()
  { return self::CLASS_NAME;
  }
 
}



class txmlrpc_server
{ static private $instance = NULL;

  private $xml = NULL;
  private $xp = NULL;
  
  private $methods = array();
  
  const CLASS_NAME = "PHP5CLASS T_XMLRPC_SERVER";
  
  private function __construct()
  { 
  }
  
  static public function create()
  { if (!self::$instance) 
    { self::$instance = new txmlrpc_server(); 
	}
	return self::$instance;
  }
  
  public function readXMLFromInput()
  { $this->xml = DOMDocument::loadXML(utf8_encode(trim(file_get_contents("php://input"))));
    $this->xp = new DOMXPath($this->xml);
  }
  
  public function registerMethod($name, $callback)
  { $this->methods[$name] = $callback;  
  }
  
  public function getMethod()
  { try
    { $result = $this->xp->query("//methodCall/methodName/self::*")->item(0)->nodeValue;
    }
	catch(Exception $e)
    { $result = NULL;
    }
	return $result;
  }
  
  //doesnt process arrays yet
  public function getParams()
  { try
    { $result = array();
      $values = $xp->query("//methodCall/params/param/value/child::*");
      foreach($values as $value)
      { switch($value->nodeName)
        { case("int"):     { $result[] = intval($value->nodeValue); break; }
	      case("string"):  { $result[] = strval($value->nodeValue); break; }
	      case("boolean"): { $result[] = (intval($value->nodeValue) == 1) ? true : false; break; }
	    }
      }
    }
    catch(Exception $e)
    { $result = NULL;
    } 
	return $result;
  }
  
  public function handleRequest()
  { $this->readXMLFromInput();
    call_user_func($this->methods[$this->getMethod], $this->getParams());
  }
  
  public function __wakeup()
  { self::$instance = $this;
  }
  
  public function __toString()
  { return self::CLASS_NAME;
  }
  
}

?>
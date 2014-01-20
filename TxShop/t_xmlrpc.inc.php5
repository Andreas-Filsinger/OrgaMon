<?php
// TXMLRPC CLASS, PHP5, TWEBSHOP
// by Thorsten Schroff, 2005, thorsten.schroff@cargobay.de

define("XMLRPC_DEFAULT_HOST","localhost");
define("XMLRPC_DEFAULT_PORT",3049);
define("XMLRPC_DEFAULT_PATH","");
define("XMLRPC_DEFAULT_USER","");
define("XMLRPC_DEFAULT_PASSWORD","");
define("XMLRPC_DEFAULT_TIMEOUT",3);

class txmlrpc 
{ static private $instance = NULL;
    
  private $errorlist = NULL;

  public $server = "";
  public $port = 0;
  public $path = "";
  public $timeout = 0;
  
  private $method = "";
  private $params = "";
  private $xml = "";
  private $php = NULL;
  
  public $xml_request = "";
  public $xml_response = "";
  
  private $user = "";
  private $password = "";
  
  public $error = false;
  public $errno = 0;
  public $errstr = "";
  
  static private $crlf = "\r\n";
  static private $block = 32768;
  
  const CLASS_NAME = "PHP5CLASS T_XMLRPC";
  
  
  private function __construct($server,$port,$path,$timeout)
  {  $this->errorlist = terrorlist::create();
     $this->server = $server;
     $this->port = $port;
	 $this->path = $path;
	 $this->timeout = $timeout;
  }

  static public function create($server = XMLRPC_DEFAULT_HOST, $port = XMLRPC_DEFAULT_PORT, $path = XMLRPC_DEFAULT_PATH, $timeout = XMLRPC_DEFAULT_TIMEOUT)
  { if (!txmlrpc::$instance) 
    { txmlrpc::$instance = new txmlrpc($server,$port,$path,$timeout); }
	return txmlrpc::$instance;
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
 
  public function setUser($user = XMLRPC_DEFAULT_USER)
  { $this->user = $user; 
  }
  
  public function getUser()
  { return $this->user; 
  }
 
  public function setPassword($password = XMLRPC_DEFAULT_PASSWORD)
  { $this->password = $password; 
  }
  
  private function getHeader()
  { $auth = "";
    if ($this->user != "") { $auth = "Authorization: Basic " . base64_encode($this->user . ":" . $this->password) . txmlrpc::$crlf; }
    $header = "POST {$this->path} HTTP/1.0".txmlrpc::$crlf."User-Agent: ".txmlrpc::CLASS_NAME.txmlrpc::$crlf."Host: {$this->server}".txmlrpc::$crlf.
	          "{$auth}Content-Type: text/xml".txmlrpc::$crlf."Content-Length: " . strlen($this->xml) . txmlrpc::crlf(2);
    return $header;
  }
  
  private function cutHeader($payload)
  { $pos = strpos($payload,txmlrpc::crlf(2)."<?xml",1);
    if ($pos !== false) { $this->xml_response = substr($payload,$pos+4); }
	else { $this->setError(102,"Keine Antwort"); $this->xml_response = ""; }
	return $this->xml_response;
  }
   
  static public function encodeRequest($method, $params)
  { $xml = new DOMDocument();
    $x_methodCall = $xml->createElement("methodCall");
    $x_methodName = $xml->createElement("methodName");
    $x_methodName->appendChild($xml->createTextNode($method));
	$x_params = $xml->createElement("params");  
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
          default: break;
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
	    foreach($xp->query("//array/data/value/child::*") as $xml_var) $php_var[] = txmlrpc::getAsPHPVariable($xml_var);
	    unset($xml);
	    unset($xp);
	    break;
	  }
	  case("string"): { $php_var = strval($xml_var->nodeValue); break; }
	  case("int"):    { $php_var = intval($xml_var->nodeValue); break; }
	  case("double"): { $php_var = doubleval($xml_var->nodeValue); break; }
    }
    return $php_var;
  }
  
  static public function decodeRequest($xml)
  { $xml = DOMDocument::loadXML(utf8_encode($xml));
    try
	{ $xp = new DOMXPath($xml);
	  $xml_vars = $xp->query("//params/param/value/child::*");
      switch($xml_vars->length)
      { case(0): { $result = NULL ; break; }
        case(1): { $result = txmlrpc::getAsPHPVariable($xml_vars->item(0)); break; }
	    default: 
	    { $result = array();
	      foreach($xml_vars as $xml_var) $result[] = txmlrpc::getAsPHPVariable($xml_var); 
	      break; 
	    }
      }
	}
	catch(Exception $e)
	{ error_log("xmlrpc.decodeRequest(): Ein Fehler ist aufgetreten, Zeile 143 ff. in t_xmlrpc.inc.php5");
	  $result = NULL;
	}
    return $result;
  }
     
  private function toXML()
  { if (in_array("xmlrpc",get_loaded_extensions()))
    { $this->xml_request = xmlrpc_encode_request($this->method,$this->params); }
    else 
	{ $this->xml_request = txmlrpc::encodeRequest($this->method,$this->params); }
	//echo "<pre>" . htmlentities($this->xml_request) . "</pre>";
	return $this->xml_request;
  }
  
  private function fromXML()
  { //echo "<pre>" . htmlentities($this->xml) . "</pre>";
    if (in_array("xmlrpc",get_loaded_extensions()))
	{ $this->php = xmlrpc_decode_request($this->xml,$this->method); }
	else 
	{ $this->php = txmlrpc::decodeRequest($this->xml); }
	return $this->php;
  }

  private function overHTTP($timeout)
  { //echo wrap($timeout);

  $fp = @fsockopen($this->server, $this->port, $errno, $errstr, $timeout);
    if (!$fp) { 

      $this->setError(100,
	  $this->server . "::" . 
	  $this->port . ": " .
	  "Socketverbindung konnte nicht geoeffnet werden"
	  );
	  //trigger_error("XMLRPC(100): was unable to open socket", E_USER_WARNING);
	  return(false);
	}

	$payload = $this->getHeader().$this->xml;
	if (!@fputs($fp,$payload,strlen($payload))) 
	{ $this->setError(101,"Fehler beim Senden");
	  //trigger_error("XMLRPC(101): error when sending", E_USER_WARNING); 
      @fclose($fp);
	  return(false); 
	}
	

	$payload = "";
	@stream_set_timeout($fp, $timeout); // ts 13-08-2007: deprecated: socket_set_timeout($fp, $timeout);

	while($data = @fread($fp, txmlrpc::$block)) { $payload .= $data; }
	
    $info = @stream_get_meta_data($fp);
	if ($info["timed_out"])
	{ $this->setError(102,"Timeout der Verbindung nach $timeout Sekunden"); 
	  //trigger_error("XMLRPC(102): timeout after $timeout seconds", E_USER_WARNING);
      @fclose($fp);
	  return(false); 
	}
	
	@fclose($fp);
	return ($payload);
  }
  

  public function sendRequest($method, $params = "", $timeout = 0)
  { // AF 
	global $perf_needed_for_xmlrpc;
    $start_time = microtime(true);
  
    $timeout = ($timeout == 0) ? $this->timeout : $timeout;
    if ($method != "") { $this->setMethod($method); }
    else { $this->setError(800,"Es wurde keine Methode angegeben"); return NULL; }
	if ($params != "") { $this->setParams($params); }
	else { $params = array(); }
	$this->xml = $this->toXML();
	$response = $this->overHTTP($timeout);

    // AF 
	$perf_needed_for_xmlrpc += microtime(true) - $start_time;
	
	if ($response == false) { return NULL; }
	else { $this->xml = $this->cutHeader($response); }
	if ($this->xml == "") { return NULL; }
	$result = $this->fromXML();
	if (is_array($result) AND array_key_exists("faultCode",$result)) { $this->setError($result["faultCode"],$result["faultString"]); return NULL; }
	else return $result;
  }
  
  
  private function setError($no, $str)
  { $this->error = true;
    $this->errno = $no;
	$this->errstr = $str . " [method: " . $this->method . "]";
	$this->errorlist->add($this->__toString() . ": " . $this->errstr);
  }
  

  static public function crlf($n)
  { $crlf = ""; 
    for ($i = 0; $i < $n; $i++) $crlf .= txmlrpc::$crlf;
	return $crlf;
  }
  
  public function __wakeup()
  { self::$instance = $this;
  }
  
  public function __toString()
  { return self::CLASS_NAME;
  }
 
}

?>
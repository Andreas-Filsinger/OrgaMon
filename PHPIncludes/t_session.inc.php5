<?php

class tsession
{ static private $instance = NULL;
  private $session_tmp_vars = array();

  const CLASS_NAME = "PHP5CLASS T_SESSION";  

  private function __construct()
  { $this->session_tmp_vars = array();
  }
  
  public function __destruct()
  { $this->registerVar("self",$this);
    //echo self::debug_list();
  }
  
  public function __wakeup()
  { self::$instance = $this;
  }
  
  static public function create()
  { session_start();
    if (self::$instance == NULL) 
    { self::$instance = self::get(self::getSessionVarName("self"), new tsession());
	}
	//echo self::debug_list();
    return self::$instance;
  }
  
  static public function free()
  { self::$instance->destroy();
    self::$instance = NULL;
  }
  
  public function destroy()
  { session_destroy();
  }
  
  public function getSize()
  { return sizeof($_SESSION);
  }
  
  static private function buildDebugListing()
  { $list = "";
    foreach($_SESSION as $_VAR => $_VALUE)
    { $list .= "$_VAR: " . gettype($_VALUE) . CRLF;
	  if (is_string($_VALUE)) 
	  { $list.= "  '" . strval($_VALUE) . "'" . CRLF;
	  }
	  if (is_object($_VALUE)) 
	  { foreach($_VALUE as $name => $value)
	    { $list.= "  $name: $value" . CRLF;
		}
	  }
	}
	return $list;
  }
  
  public function getDebugListing()
  { return self::buildDebugListing();
  }
  
  public function printDebugListing()
  { echo "<pre>" . nl2br(self::buildDebugListing()) . "</pre>";
  }
  
  public function getID()
  { return session_id();
  }
  
  public function getFile()
  { return session_save_path() . "/sess_" . $this->getID(); 
  }
    
  static private function getSessionVarName($_VAR)
  { return "session_" . $_VAR;
  }
  
  static private function getSessionTmpVarName($_VAR, $context = "")
  { return "session_tmp_" . $context . "_" . $_VAR;
  }
  
  static private function registered($_SESSION_VAR)
  { return isset($_SESSION[$_SESSION_VAR]); 
  }
  
  public function isRegistered($_VAR)
  { return self::registered(self::getSessionVarName($_VAR));
  }
  
  public function isRegisteredTmp($_VAR, $context)
  { return self::registered(self::getSessionTmpVarName($_VAR, $context));
  }
  
  static private function get($_SESSION_VAR, $default)
  { return self::registered($_SESSION_VAR) ? $_SESSION[$_SESSION_VAR] : $default;
  }
  
  public function getVar($_VAR, $default = NULL)
  { return self::get(self::getSessionVarName($_VAR),$default);
  }
  
  public function getTmpVar($_VAR, $context, $default = NULL)
  { //echo "get: $context<br />";
    return self::get(self::getSessionTmpVarName($_VAR, $context),$default);
  }
  
  static private function register($_SESSION_VAR, $value)
  { $_SESSION[$_SESSION_VAR] = $value;
  }
  
  public function registerVar($_VAR, $value)
  { self::register(self::getSessionVarName($_VAR),$value);
  }
  
  public function registerVars($_VARS = array())
  { foreach($_VARS as $_VAR)
    { global $$_VAR;
	  self::registerVar($_VAR, $$_VAR);	
	}
  }
  
  public function registerTmpVar($_VAR, $value, $context)
  { //echo "register: $context<br />";
    $_SESSION_VAR = self::getSessionTmpVarName($_VAR,$context);
    $this->session_tmp_vars[$_SESSION_VAR] = $context;
    self::register($_SESSION_VAR,$value); 
  }
  
  static private function unregister($_SESSION_VAR)
  { //session_unregister($_SESSION_VAR);
    unset($_SESSION["$_SESSION_VAR"]);
    //echo "Session-Registrierung von $_SESSION_VAR wurde aufgehoben<br />";
  }
    
  public function unregisterVar($_VAR)
  { self::unregister(self::getSessionVarName($_VAR));
  }
  
  public function unregisterTmpVar($_VAR, $context)
  { $_SESSION_VAR = self::getSessionTmpVarName($_VAR,$context);
    self::unregister($_SESSION_VAR);  
    $this->removeFromTmpVarsList($_SESSION_VAR);
  }
    
  public function cleanupTmpVars($context)
  { //echo "unregister: $context<br />";
    foreach($this->session_tmp_vars as $_SESSION_VAR => $_CONTEXT)
    { //echo $_SESSION_VAR . "@" . $_CONTEXT . BR;
	  if ($_CONTEXT != $context)
	  { self::unregister($_SESSION_VAR);
	    //echo wrap(count($this->session_tmp_vars));
	    $this->removeFromTmpVarsList($_SESSION_VAR);
		//echo wrap(count($this->session_tmp_vars));
	  }
	} 
  }
  
  private function removeFromTmpVarsList($_SESSION_VAR)
  { $this->session_tmp_vars = array_diff_key($this->session_tmp_vars,array($_SESSION_VAR => NULL));
  }
    
  public function __toString()
  { return self::CLASS_NAME;
  }
  
}

?>
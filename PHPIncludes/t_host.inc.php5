<?php

class thost
{ private $name = "";
  private $port = NULL;
  private $path = "";
  private $user = "";
  private $password = "";
  private $timeout = 0;
  private $retries = 0;
  
  const CLASS_NAME = "PHP5CLASS T_HOST";
  
  public function __construct($name, $port, $path, $user, $password, $timeout, $retries)
  { $this->name = $name;
    $this->port = intval($port);
	$this->path = $path;
	$this->user = $user;
	$this->password = $password;
	$this->setTimeout($timeout);
	$this->setRetries($retries);
  }
      
  public function setTimeout($timeout)
  { $this->timeout = intval($timeout);
  }
  
  public function setRetries($retries)
  { $this->retries = intval($retries);
  }
  
  public function getName()
  { return $this->name;
  }
  
  public function getPort()
  { return $this->port;
  }
  
  public function getPath()
  { return $this->path;
  }
  
  public function getUser()
  { return $this->user;
  }
  
  public function getPassword()
  { return $this->password;
  }
  
  public function getTimeout()
  { return $this->timeout;
  }
  
  public function getRetries()
  { return $this->retries;
  } 
   
}

?>
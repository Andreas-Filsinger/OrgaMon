<?php

class tmemory
{ private $file = "";
  private $active = false;

  public function __construct($file)
  { $this->file = $file;
    if (file_exists($this->file))
	{ unlink($this->file); 
	}
  } 
  
  public function activate()
  { $this->active = true;
  }
  
  public function deactivate()
  { $this->deactivate = false;
  }
  
  public function logMemory($token)
  { if ($this->active) 
	{ $memory = sprintf("%10d",memory_get_usage(false));
      $fp = fopen($this->file,"a");
      fwrite($fp, $memory . ": " . $token . "\r\n");
      fclose($fp);
	}
  }

}

?>
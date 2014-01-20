<?php

class tapplication
{ private $id = 0;
  private $action_id = 0;
  
  private $current_site = "";
  private $last_site = "";
  
  private $vars = array();
   
  const CLASS_NAME = "PHP5CLASS T_APPLICATION";
  
  public function __construct($id)
  { $this->id = $id; 
  }
  
  public function getID()
  { return $this->id;
  }
  
  public function setSite($site)
  { if ($site != $this->current_site) 
    { $this->last_site = $this->current_site;
	  $this->current_site = $site;
    }
	return $this->current_site;
  }
  
   public function getCurrentSite()
  { return $this->current_site;
  }
  
  public function getLastSite()
  { return $this->last_site;
  }
  
  public function setActionID($action_id = 0)
  { $this->action_id = $action_id;
  }
  
  public function getActionID()
  { return $this->action_id;
  }
  
  public function getNextActionID()
  { return $this->action_id + 1;
  }
  
  public function clearVars($context = "")
  { if ($context == "") $this->vars = array();
    else $this->vars[$context] = array();
  }
  
  public function saveVar($context, $_VAR, $_VALUE)
  { $this->vars[$context][$_VAR] = serialize($_VALUE);
  }
    
  public function saveVars($context, $_VARS)
  { $this->clearVars($context);
    foreach($_VARS as $_VAR)
    { global $$_VAR;
	  if (isset($$_VAR)) $this->saveVar($context, $_VAR, $$_VAR);
	} 
  }
  
  public function loadVars($context)
  { if (array_key_exists($context,$this->vars)) 
    { foreach($this->vars[$context] as $_VAR => $_VALUE)
      { global $$_VAR;
	    $$_VAR = unserialize($_VALUE);
		if ($_VAR == "aid") $$_VAR = $this->action_id + 1;
	  }
	  $this->clearVars($context);
	}
  }
  
  public function loadVarsIfDontExist($context)
  { if (array_key_exists($context,$this->vars)) 
    { foreach($this->vars[$context] as $_VAR => $_VALUE)
      { global $$_VAR;
	    if (!isset($$_VAR)) $$_VAR = unserialize($_VALUE);
	  }
	  $this->clearVars($context);
	}
  }
   
  public function getVars($context = "")
  { $result = false;
    if (array_key_exists($context,$this->vars))
    { $result = $this->vars[$context];
	}
	if ($context == "") 
	{ $result = $this->vars;
	}
    return $result;
  }
         
  public function __toString()
  { return self::CLASS_NAME;
  }
}
?>
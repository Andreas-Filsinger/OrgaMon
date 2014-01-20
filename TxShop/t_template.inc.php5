<?php

class ttemplate
{ private $objects = array();
  public $count = 0;

  public function __construct($array = "")
  { if ($array != "") 
    { $this->setTemplates($array);
	}
  }
  
  public function setTemplate($object, $template)
  { $this->objects[] = $object;
    $this->count = count($this->objects);
    $this->{$object} = $template;
  }
  
  public function getTemplate($object)
  { return (isset($this->{$object})) ? $this->{$object} : NULL;
  }

  public function setTemplates($array)
  { foreach($array as $object => $template)
    { $this->setTemplate($object,$template); 
	}
	$this->objects = array_unique($this->objects);
  }
  
  public function getObjects()
  { return $this->objects;
  }
    
}

?>
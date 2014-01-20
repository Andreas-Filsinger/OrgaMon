<?php

class ttemplate
{ private $classes = array();
  public $count = 0;
  
  const CLASS_NAME = "PHP5CLASS T_TEMPLATE";

  public function __construct($array = NULL)
  { if ($array != NULL) 
    { $this->setTemplates($array);
	}
  }
    
  public function setTemplate($class, $template)
  { $this->classes[] = $class;
    $this->count = count($this->classes);
    $this->{$class} = $template;
  }
  
  public function getTemplate($class)
  { return (isset($this->{$class})) ? $this->{$class} : NULL;
  }

  public function setTemplates($array)
  { $this->classes = array();
    $this->count = 0;
    foreach($array as $class => $template)
    { $this->setTemplate($class, $template); 
	}
	$this->classes = array_unique($this->classes);
  }
  
  public function getObjects() //TS 05.12.2011: deprecated
  { return $this->getClasses();
  }
  
  public function getClasses()
  { return $this->classes;
  }
    
}

?>
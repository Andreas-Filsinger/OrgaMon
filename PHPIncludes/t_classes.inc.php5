<?php

/* 
* 20.03.2011
* NEU:  In den vererbten Klassen als "private" deklarierte Eigenschaften werden NICHT serialisiert 
*       (und daher auch nicht mit in die Session �bernommen)
* NEU:  In dieser Klasse (tvisual) als "private" deklarierte WERDEN serialisiert
* NEU:  Alle als "public" oder "protected" deklarierte Eigenschaften WERDEN serialisiert (wenn sie nicht mit "_" beginnen)
* NEU:  Alle mit "_" beginnenden Eigenschaften werden (per Implementierung in __sleep()) NICHT serialisiert
* ABER: Hier als "private" deklarierte Eigenschaften k�nnen in vererbten Klassen nicht mehr per __sleep() zur 
*       Serialisierung gezwungen werden bzw. haben dann in der Serialisierung den Wert NULL
* ALSO: Eigenschaften in dieser Klasse (tvisual) am besten immer als "protected" oder "public" deklarieren und 
*       per "_" f�r die Serialisierung deaktivieren, falls in dieser unerw�nscht
* 
*/

class tvisual
{ protected $_options = array();
  
  protected $_template = NULL;
  protected $_ttemplate = NULL;
  
  const CLASS_NAME = "PHP5CLASS_T_VISUAL";
  protected $CLASS_NAME = self::CLASS_NAME; 
  //TS 05.12.2011: Die letzte Zeile ist wichtig zur Template-Unterscheidung, siehe unten, (self::CLASS_NAME funktioniert nicht, da self auch bei Nachfahren immer PHP5CLASS_T_VISUAL liefert)
  //			   Allerdings wird diese Zeile nur in der obersten Parent-Klasse ben�tigt, in allen vererbten Klassen reicht const CLASS_NAME = "..." aus 
  
  static private $_template_selector = "";

  public function addOption($name, $template = "")
  { $name = strtoupper($name);
    $this->_options["$name"] = new toption($template);
  }
  
  public function clearOptions()
  { //unset($this->_options);
    $this->_options = array();
  }
  
  public function setHTMLTemplate($template)
  { if (is_object($template) AND is_a($template,"ttemplate")) 
	{ $this->_ttemplate = $template;
	  $this->_template = ($this->_ttemplate->getTemplate($this->CLASS_NAME) != NULL) ? $this->_ttemplate->getTemplate($this->CLASS_NAME) : $this->_template;
	  //echo "{$this->CLASS_NAME}->setHTMLTemplate()<br />";
	  //echo self::CLASS_NAME . "->setHTMLTemplate()<br />";
	} 
	else 
	{ $this->_template = $template;
	}
	return $this->getHTMLTemplate();
  }
  
  public function clearHTMLTemplate()
  { $this->_ttemplate = NULL;
    $this->_template = NULL;
	//echo "{$this->_CLASS_NAME}->clearHTMLTemplate()<br />"
  }
         
  public function getHTMLTemplate()
  { if (is_array($this->_template)) 
    { $index = 0;
	  if (function_exists(self::$_template_selector))
	  { $index = call_user_func(self::$_template_selector,$this);
	    if ($index > count($this->_template)) 
	    { $index = 0;
	    } 
	  }
	  $template = $this->_template[$index];
	  unset($index);
	}
	else 
	{ $template = $this->_template;
	}
    return $template;
  }
  
  public function getFromHTMLTemplate($template = NULL)//, $clear = false)
  { $template = ($template == NULL) ? $this->getHTMLTemplate() : $this->setHTMLTemplate($template);
   
	foreach($this->_options as $name => $option)
	{ $template = str_replace("~OPTION_$name~",$option->getFromHTMLTemplate($this->_ttemplate),$template);
	  //echo $this->_CLASS_NAME . ": $name<br />" . CRLF;
	}
	
 /**
  	if ($clear)
 * 	{ $this->clearHTMLTemplate();
 * 	}
 */
	return $template;
  }
  
  public function __sleep()
  { $sleep = array();
    foreach($this as $name => $value)
    { if (substr($name,0,1) != "_") 
	  { $sleep[] = $name;
	    /*
		echo $name;
		if ($name == "CLASS_NAME") 
		{ echo ": $value";
		}
		echo "<br />";
		*/
	  }
	  unset($name);
	  unset($value);
	}
	return $sleep;
  }
  
  public function __wakeup()
  {
  }
         
  public function __toString()
  { return self::CLASS_NAME;
  } 
  
  static public function setTemplateSelector($functionname)
  { self::$_template_selector = $functionname;
  }
    
}

?>
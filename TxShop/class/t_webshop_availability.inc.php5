<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_availability
{ private $article_r = 0;
  private $version_r = 0;
  
  private $status = 0;
  
  private $string = "";
  private $days = 0;
  private $quantity = 0;
  private $date = "";
  
  private $template = "";
  private $ttemplate = NULL;

  static public $name = "PHP5CLASS T_WEBSHOP_AVAILABILITY";
  
  public function __construct($article_r, $version_r)
  { $this->article_r = $article_r;
    $this->version_r = $version_r;
    $orgamon = torgamon::create();
    $this->status = $orgamon->getAvailability($this->version_r, $this->article_r);
    unset($orgamon);
	$this->evaluateStatus();
  }
  
  public function evaluateStatus()
  { // DEBUG $this->status = 20060313;
    switch(true)
    { case ($this->status < 10):
	  { switch($this->status)
	    { case (0): { $this->string = SENTENCE_NO_INFORMATION; break; } // GELB
		  case (1): { $this->string = SENTENCE_PERMANENTLY_OUT_OF_PRINT; break; } // ROT
		  case (2): { $this->string = SENTENCE_TEMPORARILY_OUT_OF_PRINT; break; } // ROT
		  case (3): { $this->string = SENTENCE_TEMPORARILY_OUT_OF_PRINT; break; } // ROT
	    }
	    break;
	  }
      case ($this->status < 100): //GRUEN
	  { $this->days = $this->status - 10;  
	    $this->string = $this->getDaysString();
	    break;
	  }
	  case ($this->status < 10000000): // kleiner als die kleinste 8-stellige Zahl = kein Datum
	  { $this->quantity = $this->status - 100;
		$this->string = str_replace("~QUANTITY~",$this->quantity,VARIABLE_SENTENCE_X_INSTANCES_AVAILABLE);
		break;
	  }
	  case ($this->status > 20000000): // müsste ein Datum sein
	  { $this->date = substr("{$this->status}",6,2) . "." . substr("{$this->status}",4,2) . "." . substr("{$this->status}",0,4);
	    $this->string = $this->date; 
	    break;
	  }	
	}  
  }
  
  private function getDaysString()
  { switch(true)
    { case($this->days == 0): { $string = SENTENCE_AVAILABLE_TODAY; break; }
	  case($this->days == 1): { $string = SENTENCE_AVAILABLE_TOMORROW; break; }
	  default: { $string = str_replace("~DAYS~",$this->days,VARIABLE_SENTENCE_AVAILABLE_IN_X_DAYS); }
	}
	return $string;
  }
  
  public function setHTMLTemplate($template)
  { if (is_object($template) AND is_a($template,"ttemplate")) 
	{ $this->ttemplate = $template;
	  $this->template = ($this->ttemplate->getTemplate(self::$name) != NULL) ? $this->ttemplate->getTemplate(self::$name) : $this->template;
	} 
	else $this->template = $template;
	return $this->template;
  }
      
  public function getHTMLTemplate()
  { return $this->template;
  }
  
  public function getFromHTMLTemplate($template = NULL)
  { $template = ($template == NULL) ? $this->template : $this->setHTMLTemplate($template);
    $template = str_replace("~DATE~",$this->date,$template);
	$template = str_replace("~DAYS~",$this->days,$template);
	$template = str_replace("~STATUS~",$this->status,$template);
	$template = str_replace("~STRING~",$this->string,$template);
    return $template;
  }
  
  public function __toString()
  { return twebshop_availability::$name;
  }

}

// GELBE STATI
   //  0=keine Info ?erf?eit vorhanden
   //
   // ROTE STATI:
   //  1=entg?vergriffen
   //  2=zur Zeit vergriffen, Neuauflage jedoch ungewiss
   //  3=zur Zeit vergriffen, Neuauflage jedoch sicher
   //
   //
   // GR?E STATI:
   //  10=heute lieferbar  (=ist am Lager, ohne Mengenangabe)
   //  11=morgen lieferbar (=wurde z.B. mit dieser Zusage bereits bestellt und kommt morgen)
   //  12=in 2 Tagen lieferbar... (=ist z.B. in dieser Zeit zu beschaffen)
   //  13=in 3 Tagen lieferbar...
   //  14= ... usw ...
   //
   // GR?E STATI:
   //  101= heute lieferbar  (=ist am Lager, Lagermenge=1)
   //  102= heute lieferbar  (=ist am Lager, Lagermenge=2)
   //  103= heute lieferbar  (=ist am Lager, Lagermenge=3)
   //  ... usw.
   //
   //  GR?E STATI:
   // >20020101= Konkretes Lieferdatum (z.B. Erscheinungsdatum!)
   //  20031003= am 03.10.2003 lieferbar (da es z.B. an diesem Tag erscheint)
   //            (Vorbestellungen nat? m?ch)


?>
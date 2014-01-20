<?php

//**** KLASSE ZUR ABBILDUNG DER VERKETTETEN MUSIKER ****************************************************************************************** 
class twebshop_musician_list
{ public $root = 0;
  public $list = "";
  
  static public $name = "PHP5CLASS T_WEBSHOP_MUSICIAN_LIST";

  public function __construct($musician_r)
  { $this->root = $musician_r;
    $this->list = $this->makeList($this->root);
  }
  
  static public function makeList($musician_r)
  { $list = "";
    $musician = new twebshop_musician($musician_r);
		
	if ($musician->MUSIKER_R != NULL) $list.= twebshop_musician_list::makeList($musician->MUSIKER_R) . " " . $musician->EVL_TRENNER;
	else $list.= trim($musician->VORNAME." ".$musician->NACHNAME) . " " . $musician->EVL_TRENNER;
	
	if ($musician->EVL_R != NULL) $list.= twebshop_musician_list::makeList($musician->EVL_R);
	unset($musician);
	return $list;
  }
  
  public function __toString()
  { return twebshop_musician_list::$name . ": " . $this->list; }
}

?>
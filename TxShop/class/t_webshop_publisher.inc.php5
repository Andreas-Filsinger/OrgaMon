<?php

//**** KLASSE ZUR ABBILDUNG DES VERLAGS **********************************************************************************************
class twebshop_publisher
{ static public $properties = array("PERSON_R");
  public $rid = 0;
  public $person = NULL;
  public $text = "";
  
  static public $name = "PHP5CLASS T_WEBSHOP_PUBLISHER";
    
  public function __construct($rid = 0)
  { $this->rid = $rid;
	$this->getProperties();
  }
  
  public function getProperties()
  { $dbase = tdbase::create();
	$sql = "SELECT " . implode(",",twebshop_publisher::$properties) . " FROM " . TABLE_PUBLISHER . " WHERE RID=" . $this->rid;
	$dbase->query($sql);
	$data = $dbase->fetch_object();
	$dbase->free_result();
    foreach(twebshop_publisher::$properties as $name) { $this->{$name} = $data->{$name}; }
  }
  
  public function getPerson()
  { $this->person = new twebshop_person($this->PERSON_R);    
  }
  
  public function __toString()
  { return twebshop_publisher::$name; }
}

?>
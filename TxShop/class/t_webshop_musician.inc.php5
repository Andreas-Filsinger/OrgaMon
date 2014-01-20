<?php

//**** KLASSE ZUR ABBILDUNG DES MUSIKERS **********************************************************************************************
class twebshop_musician
{ static public $properties = array("VORNAME","NACHNAME","EVL_R","EVL_TRENNER","MUSIKER_R");
  public $rid = 0;
  
  static public $name = "PHP5CLASS T_WEBSHOP_MUSICIAN";
    
  public function __construct($rid = 0)
  { $this->rid = $rid;
	$this->getProperties();
  }
  
  public function getProperties()
  { $dbase = tdbase::create();
	$sql = "SELECT " . implode(",",twebshop_musician::$properties) . " FROM " . TABLE_MUSICIAN . " WHERE RID=" . $this->rid;
	$dbase->query($sql);
	$data = $dbase->fetch_object();
	$dbase->free_result();
    foreach(twebshop_musician::$properties as $name) { $this->{$name} = $data->{$name}; }
  }
  
  public function __toString()
  { return twebshop_musician::$name; }
}

?>
<?php

//**** KLASSE ZUR ABBILDUNG DER PERSON ****************************************************************************************
class twebshop_person
{ static public $properties = array("VORNAME","NACHNAME","PRIV_ANSCHRIFT_R","GESCH_ANSCHRIFT_R","EMAIL","USER_ID","GEBURTSTAG",
                                    "WEBSHOP_VERSANDART","WEBSHOP_TEILLIEFERUNGEN","WEBSHOP_TREFFERPROSEITE","WEBSHOP_RABATT");
  public $rid = 0;
  
  static public $name = "PHP5CLASS TWEBSHOP_PERSON"; 

  public function __construct($rid = 0)
  { $this->rid = $rid;
	if ($this->rid != 0) $this->getProperties();
  }
  
  public function getProperties()
  { $dbase = tdbase::create();
	$sql = "SELECT " . implode(",",twebshop_person::$properties) . " FROM " . TABLE_PERSON . " WHERE RID=" . $this->rid;
	$dbase->query($sql);
	$data = $dbase->fetch_object();
	$dbase->free_result();
    foreach(twebshop_person::$properties as $name) { $this->{$name} = $data->{$name}; }
  }
      
  function __toString()
  { return twebshop_person::$name;
  }
}

?>
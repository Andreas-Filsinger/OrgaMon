<?php

class twebshop_parent
{ static public $properties = array();
  public $rid = 0;
  public $version_r = 0;
  public $person_r = 0;

  public $quantity = 1;
  public $detail = "";
  public $price = NULL;
  
  public $availability = NULL;
  
  public $composer = "";
  public $arranger = "";
  public $publisher = "";
  
  public $thumbs = array();
  public $images = array();
  public $sounds = array();
  public $options = array();
  
  private $template = "";
  
  static public $name = "PHP5CLASS T_WEBSHOP_ARTICLE";

  public function __construct($rid, $version_r = 0, $person_r = 0, $quantity = 1, $detail = "")
  { $this->rid = (int)($rid);
    $this->version_r = $version_r;
	$this->person_r = $person_r;
	$this->quantity = $quantity;
	$this->detail = $detail;
    $this->getProperties();
	$this->price = new twebshop_price($this->rid,$this->version_r,$this->person_r,$this->quantity);
  }
  
  private function getProperties()
  { $dbase = tdbase::create();
    if (count($properties = twebshop_article::$properties) == 0) { $properties = $dbase->get_fields(TABLE_ARTICLE); }
	//arr_dump($properties);
	$sql = "SELECT " . implode(",",$properties) . " FROM " . TABLE_ARTICLE . " WHERE RID={$this->rid}"; // " LIMIT 1"; // nur 1 Datensatz
	$dbase->query($sql);
	$data = $dbase->fetch_object();
	$dbase->free_result();
	foreach($properties as $name) { $this->{$name} = $data->{$name}; }
  }
    
  public function getComposer()
  { $this->composer = $this->KOMPONIST;
	return $this->composer;
  }
  
  public function getArranger()
  { $this->arranger = $this->ARRANGEUR;
	return $this->composer;
  }
  
  public function getThumbs()
  { $dbase = tdbase::create();
    $dbase->sql = "SELECT RID FROM " . TABLE_DOCUMENT . " WHERE ARTIKEL_R=" . $this->rid;
    $dbase->query();
	while($data = $dbase->fetch_object()) { $this->thumbs[] = "./upload/" . sprintf("%08d",$data->RID) . "th.jpg"; }
	$dbase->free_result();
	return $this->thumbs;
  }
  
  public function getThumb($index = 0)
  { return $this->thumbs[$index]; 
  }
  
  public function getImages()
  { $dbase = tdbase::create();
    $dbase->sql = "SELECT RID FROM " . TABLE_DOCUMENT . " WHERE ARTIKEL_R=" . $this->rid;
    $dbase->query();
	while($data = $dbase->fetch_object()) { $this->images[] = "./upload/" . sprintf("%08d",$data->RID) . ".jpg"; }
	$dbase->free_result();
	return $this->images;
  }
  
  public function getImage($index = 0)
  { return $this->images[$index];
  }
  
  private function getMediaName()
  { return $this->NUMERO;
  }
  
  public function getSounds($path)
  { $this->sounds = file_search($path,"^({$this->getMediaName()})[a-zA-Z]{0,1}\.[mM]{1}[pP]{1}(3)$");
    return $this->sounds;
  }
         
  public function getPublisher()
  { if ($this->VERLAG_R == NULL) { $this->VERLAG_R = 0; }
    if ($this->LAND_R == NULL)   { $this->LAND_R   = 0; }
	$orgamon = torgamon::create(); 
	$this->publisher = $orgamon->getPublisher($this->LAND_R,$this->VERLAG_R);
	unset($orgamon);
  }
  
  public function getAvailability()
  { $this->availability = new twebshop_availability($this->rid, $this->version_r);
   	return $this->availability;
  }
  
  public function getAll()
  { $this->getComposer();
    $this->getArranger();
	$this->getThumbs();
	$this->getImages();
	$this->getPublisher();
	$this->getAvailability();
  }
  
  public function addOption($name, $template = "")
  { $name = strtoupper($name);
    $this->options["$name"] = new toption($template);
  }
  
  public function setVersion($version_r = 0)
  { $this->version_r = $version_r;
    $this->setPrice();
  }
  
  public function setPerson($person_r = 0)
  { $this->person_r = $person_r;
    $this->setPrice();
  }
  
  public function setQuantity($quantity = 1)
  { $this->quantity = $quantity;
    $this->setPrice();
  }
  
  private function setDetail($detail = "")
  { $this->detail = $detail;
  }
  
  private function setPrice()
  { $this->price->resetValues($this->version_r,$this->quantity,$this->PERSON_R);  
  }
  
  public function setHTMLTemplate($template)
  { $this->template = $template;
  }
          
  public function getHTMLTemplate()
  { return $this->template;
  }
  
  public function getFromHTMLTemplate($template = "")
  { if ($template == "") $template = $this->template;
    foreach($this->options as $name => $option)
	{ $template = str_replace("~OPTION_$name~",$option->getFromHTMLTemplate(),$template);
	}
	$template = str_replace("~ARRANGER~",$this->arranger,$template);
	$template = str_replace("~AVAILABILITY~",($this->availability != NULL) ? $this->availability->getFromHTMLTemplate() : "",$template);
    $template = str_replace("~COMPOSER~",$this->composer,$template);
	$template = str_replace("~DAUER~",$this->DAUER,$template);
	$template = str_replace("~IMAGE~",(count($this->images) > 0) ? image_tag($this->getImage(0)) : "",$template);
	$template = str_replace("~NUMERO~",$this->NUMERO,$template);
	$template = str_replace("~PRICE~",($this->price != NULL) ? $this->price->getFromHTMLTemplate() : "",$template);
	$template = str_replace("~PUBLISHER~",$this->publisher,$template);
	$template = str_replace("~QUANTITY~",$this->quantity,$template);
	$template = str_replace("~RID~",$this->rid,$template);
   	$template = str_replace("~SCHWER_GRUPPE~",$this->SCHWER_GRUPPE,$template);
	$template = str_replace("~SCHWER_DETAILS~",$this->SCHWER_DETAILS,$template);
	$template = str_replace("~THUMB~",(count($this->thumbs) > 0) ? image_tag($this->getThumb(0)) : "",$template);
	$template = str_replace("~TITEL~",$this->TITEL,$template);
	return $template;
  }
  
  public function __toString()
  { return twebshop_article::$name;
  }
}

?>
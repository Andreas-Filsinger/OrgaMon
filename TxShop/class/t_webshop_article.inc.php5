<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_article extends tvisual
{ static public $properties = array();
  private $rid = 0;
  private $uid = "";
  public $version_r = 0;
  public $person_r = 0;
  public $cart_r = 0;
  public $position = 0;
  
  public $quantity = 1;
  public $detail = "";
  public $price = NULL;
  
  public $availability = NULL;
  
  public $composer = "";
  public $arranger = "";
  public $publisher = "";
  public $info = NULL;
  public $notice = "";
  
  public $thumbs = array();
  public $images = array();
  public $sounds = array();
  public $members = array();
  
  const MEDIUM_R_SOUND   = TWEBSHOP_ARTICLE_MEDIUM_R_SOUND;
  const MEDIUM_R_IMAGE   = TWEBSHOP_ARTICLE_MEDIUM_R_IMAGE;
  const CONTEXT_R_RECORD = TWEBSHOP_ARTICLE_CONTEXT_R_RECORD;
  
  const TABLE = TABLE_ARTICLE;
  const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE";
  protected $_CLASS_NAME = self::CLASS_NAME;

  public function __construct($rid, $version_r = 0, $person_r = 0, $quantity = 1, $detail = "", $cart_r = 0)
  { $this->rid = (ereg("^[0-9]{1,8}$",strval($rid))) ? intval($rid) : twebshop_article::decryptRID($rid);
    //echo $this->rid;
	$this->version_r = $version_r;
	$this->person_r = $person_r;
	$this->quantity = $quantity;
	$this->detail = $detail;
	$this->cart_r = $cart_r;
    $this->getProperties();
	$this->price = new twebshop_price($this->rid,$this->version_r,$this->person_r,$this->quantity);
  }
  
  private function getProperties()
  { $dbase = tdbase::create();
    if (count($properties = twebshop_article::$properties) == 0) { self::$properties = $dbase->get_fields(TABLE_ARTICLE); }
    $sql = "SELECT " . implode(",",self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}"; // " LIMIT 1"; // nur 1 Datensatz
	//echo $sql;
	$dbase->query($sql);
	$data = $dbase->fetch_object();
	$dbase->free_result();
	foreach(self::$properties as $name) 
	{ $this->{$name} = $data->{$name}; 
	}
	unset($dbase);
  }
    
  public function getComposer()
  { $this->composer = $this->KOMPONIST;
	return $this->composer;
  }
  
  public function getArranger()
  { $this->arranger = $this->ARRANGEUR;
	return $this->composer;
  }
  
  public function getInfo()
  { //echo wrap($this->INTERN_INFO);
    if ($this->info == NULL)
    { $this->info = new tmultistringlist();
	  if ($this->INTERN_INFO != "") 
	  { $dbase = tdbase::create();
        $this->info->assignString($dbase->get_blob($this->INTERN_INFO,4096));
		//file_put_contents("blob.txt",$dbase->get_blob($this->INTERN_INFO,4096));
	    //$this->info->writeFile("info.txt",";\r\n");
        unset($dbase);
	  }
	}
    return $this->info;
  }
  
  public function getNotice()
  { if ($this->notice == "") 
    { if ($this->info == NULL) 
      { $this->getInfo(); 
	  }
	  //$this->notice = $this->info->getValueByName("BEM");
	  $this->notice = torgamon::processText($this->info->getValueByName("BEM"));
	}
	return $this->notice;
  }
  
  public function getThumbs()
  { $this->thumbs = self::getArticleThumbs($this->rid);
    return $this->thumbs;
  }
  
  public function getThumb($index = 0)
  { return $this->thumbs[$index]; 
  }
  
  public function getImages()
  { $this->images = self::getArticleImages($this->rid);
    return $this->images;
  }
  
  public function getImage($index = 0)
  { return $this->images[$index];
  }
  
  private function getMediaName()
  { return $this->NUMERO;
  }
  
  public function getSounds($path)
  { $this->sounds = file_search($path,"^({$this->getMediaName()})[A-Z]{0,1}\.[mM]{1}[pP]{1}(3)$");
    asort($this->sounds);
    return $this->sounds;
  }
  
  public function getMiniScore($path)
  { $file = path_format($path,true,true,"") . $this->NUMERO . ".pdf";
    //echo $file;
    return (file_exists($file)) ? $file : false; 
  }
  
  public function getMembers()
  { $this->members = array();
    $sql = "SELECT COALESCE( A.RID, 0) AS RID, M.POSNO||'. '||COALESCE( M.TITEL, A.TITEL ) AS TITEL FROM " . TABLE_ARTICLE_MEMBER . " AS M LEFT JOIN " . 
	       self::TABLE . " AS A ON M.ARTIKEL_R=A.RID WHERE M.MASTER_R={$this->rid} ORDER BY M.POSNO";	
  	//echo wrap($sql);
    $dbase = tdbase::create();
	$result = $dbase->query($sql);
	while($data = $dbase->fetch_object($result))
	{ $id = $data->RID;
	  $title = $data->TITEL;
	  if ($id != 0) 
	  { $this->members[$id] = new twebshop_article_link(self::encryptRID($id),$title,"");
	  }
	  else
	  { $this->members[] = $title;
	  }
	}
	unset($result);
	unset($sql);
	unset($dbase);
	return $this->members;
  }
  
  public function existRecords()
  { $dbase = tdbase::create();
	$sql = "SELECT COUNT(*) FROM " . TABLE_ARTICLE_MEMBER . " WHERE (ARTIKEL_R={$this->rid}) AND (MASTER_R != {$this->rid}) AND (CONTEXT_R=" . self::CONTEXT_R_RECORD . ")";
	$count = $dbase->get_field($sql,"COUNT");
	unset($dbase);
	if ($this->info == NULL) { $this->getInfo(); }
	return (($this->info != NULL AND trim($this->info->getValueByName("CDRID")) != "") OR $count > 0);
  }
        
  public function getPublisher()
  { $this->publisher = $this->VERLAG;
    return $this->publisher;
  }
  
  public function getAvailability()
  { $this->availability = new twebshop_availability($this->rid, $this->version_r);
   	return $this->availability;
  }
  
  public function getDuration()
  { return ($this->DAUER != "") ? ($this->DAUER."&nbsp;min") : "";
  }
  
  public function getiRID()
  { return $this->rid;
  }
  
  public function getRID()
  { return twebshop_article::encryptRID($this->rid);
  }
  
  public function getUID()
  { $this->uid = self::buildUID($this->getRID(),$this->version_r,$this->detail);
	return $this->uid;
  }
  
  public function getAll()
  { $this->getComposer();
    $this->getArranger();
	$this->getThumbs();
	$this->getImages();
	$this->getPublisher();
	$this->getAvailability();
  }
  
  public function setVersion($version_r = 0)
  { $tmp_version_r = $this->version_r;
    $this->version_r = $version_r;
    if ($this->version_r != $tmp_version_r)
	{ $this->setPrice();
	  $this->getUID();
	}
  }
  
  public function getVersion($null = false)
  { return ($this->version_r == 0 AND $null) ? "NULL" : $this->version_r;
  }
  
  public function setPerson($person_r = 0)
  { $tmp_person_r = $this->person_r;
    $this->person_r = $person_r;
    if ($this->person_r != $tmp_person_r) $this->setPrice();
  }
  
  public function setQuantity($quantity = 1)
  { $tmp_quantity = $this->quantity;
    $this->quantity = $quantity;
    if ($this->quantity != $tmp_quantity) $this->setPrice();
  }
  
  public function incQuantity($quantity = 1)
  { $this->setQuantity($this->quantity + $quantity);
  }
  
  public function setDetail($detail = "")
  { $this->detail = $detail;
    $this->getUID();
  }
  
  private function setPrice()
  { $this->price->resetValues($this->version_r, (isset($this->person_r)) ? $this->person_r : 0, $this->quantity); 
  }
   
  public function getFromHTMLTemplate($template = NULL)
  { $template = parent::getFromHTMLTemplate($template);
	
	$template = str_replace("~ARRANGER~",($this->arranger == "") ? $this->getArranger() : $this->arranger,$template);
	$template = str_replace("~AVAILABILITY~",($this->availability != NULL) ? $this->availability->getFromHTMLTemplate($this->ttemplate) : "",$template);
	//$template = str_replace("~BEM~",($this->info != NULL AND ($tmp = $this->getNotice()) != "") ? nl2br($tmp) : SENTENCE_NO_FURTHER_INFORMATION_AVAILABLE,$template);
	//$template = str_replace("~CID~",$this->cart_r,$template);
    $template = str_replace("~COMPOSER~",($this->composer == "") ? $this->getComposer() : $this->composer,$template);
	$template = str_replace("~DAUER~",$this->getDuration(),$template);
	//$template = str_replace("~DETAIL~",$this->detail,$template);
	//$template = str_replace("~UID~",($this->uid == "") ? $this->getUID() : $this->uid,$template);
	$template = str_replace("~IMAGE~",(count($this->images) > 0) ? $this->getImage(0) : "",$template);
	//$template = str_replace("~IMAGES~",(count($this->images) > 0) ? implode(",",$this->images) : "",$template);
	//$template = str_replace("~MEMBERS~",$members,$template);
	$template = str_replace("~NUMERO~",$this->NUMERO,$template);
	//$template = str_replace("~POSITION~",$this->position,$template);
	$template = str_replace("~PRICE~",($this->price != NULL) ? $this->price->getFromHTMLTemplate($this->ttemplate) : "",$template);
	$template = (strpos($template,"~PUBLISHER~",0) !== false) ? str_replace("~PUBLISHER~",($this->publisher == "") ? $this->getPublisher() : $this->publisher,$template) : $template;
	$template = str_replace("~QUANTITY~",$this->quantity,$template);
	$template = str_replace("~RID~",urlencode(twebshop_article::encryptRID($this->rid)),$template);
	//$template = str_replace("~RID_INT~",$this->rid,$template);
	$template = str_replace("~RID_RAW~",twebshop_article::encryptRID($this->rid),$template);
	//$template = str_replace("~SCHWER_DETAILS~",(($this->SCHWER_DETAILS != NULL) ? ("(".$this->SCHWER_DETAILS.")") : ""),$template);
	//$template = str_replace("~SCHWER_GRUPPE~",$this->SCHWER_GRUPPE,$template);
	$template = str_replace("~SCHWER~",$this->SCHWER,$template);
	$template = str_replace("~THUMB~",(count($this->thumbs) > 0) ? $this->getThumb(0) : "",$template);
	$template = str_replace("~TITEL~",$this->TITEL,$template);
	//$template = str_replace("~TITEL_NO_QUOTES~",stripquotes($this->TITEL),$template);
	//$template = str_replace("~TREE_CODE~",$this->getTreeCode(),$template);
	//$template = str_replace("~TREE_PATH~",$this->getTreePath(),$template);
	//$template = str_replace("~VERSION~",(isset($versions)) ? $versions->getFromHTMLTemplate($this->ttemplate) : "",$template);
	//$template = str_replace("~VERSION_R~",$this->version_r,$template);
	
	unset($members);
	unset($versions);
	return $template;
  }
  
  static public function buildUID($article_r, $version_r, $detail)
  { return md5($article_r.$version_r.$detail);
  }
  
  static public function encryptRID($id)
  { $crypt_ID = tcryptID::create();
    return $crypt_ID->encrypt($id);
  }
  
  static public function decryptRID($id)
  { $crypt_ID = tcryptID::create();
    return $crypt_ID->decrypt($id);
  }
  
  static public function getArticleThumbs($article_r)
  { $orgamon = torgamon::create();
    $dbase = tdbase::create();
    $dbase->sql = "SELECT RID FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_IMAGE . " AND ARTIKEL_R=$article_r)";
    $dbase->query();
	$thumbs = array();
	while($data = $dbase->fetch_object()) { 
	 $thumbs[] = $orgamon->getThumbFileName($data->RID); 
    }
	$dbase->free_result();
	return $thumbs;
  }
  
  static public function getArticleImages($article_r)
  { $orgamon = torgamon::create();
    $dbase = tdbase::create();
    $dbase->sql = "SELECT RID FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_IMAGE . " AND ARTIKEL_R=$article_r)";
    $dbase->query();
	$images = array();
	while($data = $dbase->fetch_object()) { 
	 $images[] = $orgamon->getImageFileName($data->RID); 
	}
	$dbase->free_result();
	return $images;
  }
  
  static public function getArticleProperty($article_r, $property)
  { $dbase = tdbase::create();
    $sql = "SELECT $property FROM " . self::TABLE . " WHERE RID={$article_r}";
	$result = $dbase->get_field($sql,$property);
	//$dbase->free_result();
	unset($dbase);
	return $result;
  
  }
  
  static public function getArticleDifficulty($article_r)
  { return self::getArticleProperty($article_r,"SCHWER_GRUPPE");
  }
  
  static public function getArticleTitle($article_r)
  { return self::getArticleProperty($article_r,"TITEL");
  }
}

?>
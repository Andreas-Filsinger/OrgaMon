<?php

//**** KLASSE ZUR ABBILDUNG DES EINKAUFWAGENS ****************************************************************************************
class twebshop_cart extends tvisual
{ static private $instance = NULL;

  private $person_r = 0;
  private $positions = 0;
  private $sum = 0.00;
  private $delivery = NULL;
  
  public $article = array();
 
  const TABLE = TABLE_CART;
  const CLASS_NAME = "PHP5CLASS T_WEBSHOP_CART";
  protected $_CLASS_NAME = self::CLASS_NAME;
  
  private function __construct($person_r)
  { $this->delivery = new twebshop_delivery();
    $this->setPerson($person_r);
  }
  
  static public function create($person_r = 0)
  { if (!self::$instance) 
    { self::$instance = new twebshop_cart($person_r); 
	}
	return self::$instance;
  }
  
  public function setPerson($person_r = 0)
  { $this->person_r = $person_r;
	foreach(array_keys($this->article) as $index) $this->article[$index]->setPerson($this->person_r);
	$this->buildSum(true);
  }
  
  public function buildSum($refresh_delivery = false)
  { $this->sum = 0;
    foreach($this->article as $article) $this->sum += $article->price->getSumBrutto();
	$this->sum += ($refresh_delivery) ? $this->getDeliveryPrice() : $this->delivery->getSumBrutto();
	return $this->sum;
  }
  
  public function getSum()
  { return $this->sum; }
  
  private function getDeliveryPrice()
  { if ($this->person_r != 0) 
    { $orgamon = torgamon::create();
	  $delivery = $orgamon->getDeliveryPrice($this->person_r);
	  unset($orgamon);
	}
	else 
	{ $delivery = twebshop_price::TYPE_UNKNOWN; 
	}
	$this->delivery->setValues($delivery);
	unset($delivery);
	return $this->delivery->getSumBrutto();
  }
  
  public function getPositions()
  { return $this->positions; 
  }
  
  public function addArticle($article_r, $quantity = 1, $version_r = 0, $detail = "", $cart_r = 0)
  { $uid = twebshop_article::buildUID($article_r, $version_r, $detail);
    if ($this->inCart($uid)) // Genau dieser Artikel schon im Einkaufswagen ?  
    { $index = $this->getIndexByUID($uid); // Ja, Menge anpassen
	  $this->article[$index]->incQuantity($quantity);
	  $this->article[$index]->cart_r = max($this->article[$index]->cart_r, $cart_r);
	  $this->updateInDataBase($index);
	}
	else
	{ $article = new twebshop_article($article_r, $version_r, $this->person_r, $quantity, $detail, $cart_r); // Nein, neuen Artikel hinzufügen
 	  $this->article[] = $article;
	  $index = $this->getIndexByUID($uid);
	  $this->insertIntoDataBase($index);
	}
	$this->positions = count($this->article);
	$this->article[$index]->position = $this->getPositionByUID($uid);
	$this->buildSum();
	return $this->article[$index]; // $index muss in beiden Fällen der if-Bedingung gesetzt werden
  }
  
  public function updateArticle($uid, $quantity = 0, $version_r = 0, $detail = "")
  { $index = $this->getIndexByUID($uid);
    $article_r = $this->article[$index]->getRID();
	$tmp_uid = twebshop_article::buildUID($article_r, $version_r, $detail);
    if ($quantity != 0)
    { if ($this->inCart($tmp_uid) AND $uid != $tmp_uid) // UID ändert sich und es befindet sich schon ein Artikel mit der neuen UID im Einkaufswagen
	  { $this->addArticle($article_r, $quantity, $version_r, $detail); // Positionen zusammenführen
	    $this->deleteArticle($uid); // alte Position löschen
	  }
	  else // UID ändert sich nicht ODER neue UID noch nicht vorhanden
	  { $this->article[$index]->setQuantity($quantity);
	    $this->article[$index]->setVersion($version_r);
	    $this->article[$index]->setDetail($detail);
		$this->updateInDataBase($index);
	  }
	}
	else $this->deleteArticle($uid);
	$this->buildSum();
  }
  
  public function deleteArticle($uid)
  { $index = $this->getIndexByUID($uid);
    //var_dump($index);
    $this->deleteFromDataBase($index);
	$this->article = array_diff_key($this->article,array($index => ""));
    $this->positions = count($this->article);
	$this->rebuildPositions();
	$this->buildSum();
  }
  
  public function inCart($uid)
  { return ($this->getIndexByUID($uid) === false) ? false : true;
  }
  
  public function getIndexByUID($uid)
  { $result = false;
    foreach ($this->article as $index => $article) 
	{ $result = ($article->getUID() == $uid) ? $index : $result;
	}
	return $result;
  }
 
  public function getPositionByUID($uid)
  { $result = false;
    $i = 1;
    foreach ($this->article as $article) 
	{ $result = ($article->getUID() == $uid) ? $i : $result;
	  $i++;
	}
	return $result;
  }
  
  private function rebuildPositions()
  { foreach($this->article as $index => $article)
    { $this->article[$index]->position = $this->getPositionByUID($this->article[$index]->getUID());
	}
  }
  
  public function clear()
  { $this->positions = 0;
    $this->sum = 0.00;
    $this->getDeliveryPrice();
	unset($this->article);
    $this->article = array();
	$this->buildSum();
  }
     
  private function updateInDataBase($index)
  { $article = $this->article[$index];
    $result = false;
    if ($this->person_r != 0 AND $article->cart_r != 0) 
    { $ibase = tibase::create();
	  $sql = "UPDATE " . self::TABLE . " SET MENGE={$article->quantity},AUSGABEART_R={$article->getVersion(true)},BEMERKUNG='{$article->detail}' WHERE (PERSON_R={$this->person_r} AND RID={$article->cart_r})";
	  $result = $ibase->update($sql);
	  //$messagelist = tmessagelist::create();
      //$messagelist->add("Datenbank Update SQL: " . $sql);
	  //unset($messagelist);
	  unset($ibase);
   	}
	return $result;
  }
  
  private function insertIntoDataBase($index)
  { $article = $this->article[$index];
    $result = false;
    if ($this->person_r != 0 AND $article->cart_r == 0) 
    { $ibase = tibase::create();
	  $rid = $ibase->gen_id("GEN_".self::TABLE);
	  $sql = "INSERT INTO " . self::TABLE . " (RID,ARTIKEL_R,PERSON_R,MENGE,AUSGABEART_R,BEMERKUNG) VALUES ($rid,{$article->getiRID()},{$this->person_r},{$article->quantity},{$article->getVersion(true)},'{$article->detail}')";
	  $result = $ibase->insert($sql);
	  $this->article[$index]->cart_r = $rid;
	  unset($rid);
	  //var_dump($this->article[$index]->cart_r);
	  //$this->article[$index]->cart_r = $ibase->insert_id();
	  //$messagelist = tmessagelist::create();
      //$messagelist->add("Datenbank Insert SQL: " . $sql);
	  //$messagelist->add("Insert ID:" . $ibase->insert_id());
	  //unset($messagelist);
	  unset($ibase);
   	}
	return $result;
  }
  
  private function deleteFromDataBase($index)
  { $cart_r = $this->article[$index]->cart_r;
    $result = false;
    if ($this->person_r != 0 AND $cart_r != 0) 
    { $ibase = tibase::create();
	  $sql = "DELETE FROM " . self::TABLE . " WHERE (PERSON_R={$this->person_r} AND RID=$cart_r)";
	  $result = $ibase->delete($sql);
	  //$messagelist = tmessagelist::create();
      //$messagelist->add("Datenbank Delete SQL: " . $sql);
	  //unset($messagelist);
	  unset($ibase);
   	}
	return $result;
  }
  
  private function deleteAllFromDataBase()
  { if ($this->person_r != 0) 
    { $ibase = tibase::create();
      $sql = "DELETE FROM " . self::TABLE . " WHERE PERSON_R={$this->person_r}";
	  $ibase->delete($sql);
      unset($ibase);
	}
  }
  
  public function readFromDataBase()
  { if ($this->person_r != 0)
    { $ibase = tibase::create();
      $sql = "SELECT RID,ARTIKEL_R,MENGE,AUSGABEART_R,BEMERKUNG FROM " . self::TABLE . " WHERE PERSON_R=" . $this->person_r . " ORDER BY RID";
	  $result = $ibase->query($sql);
	  while($data = $ibase->fetch_object($result))
	  { $this->addArticle(twebshop_article::encryptRID($data->ARTIKEL_R),intval($data->MENGE),intval($data->AUSGABEART_R),trim($data->BEMERKUNG),intval($data->RID));
 	  }
	  $ibase->free_result($result);
	  unset($ibase);
	}
	return true;
  }

/*   
  private function writeToDataBase()
  { $this->deleteAllFromDataBase();
    $ibase = tibase::create();
    foreach($this->article as $article)
    { $sql = "INSERT INTO " . self::TABLE . " (ARTIKEL_R,PERSON_R,MENGE,AUSGABEART_R,BEMERKUNG) 
	          VALUES ({$article->getiRID()},{$this->person_r},{$article->quantity},{$article->getVersion(true)},'{$article->detail}')";
	  $ibase->insert($sql);
	}
	unset($ibase);
  }
*/
  
  public function synchronizeWithDataBase()
  { $this->readFromDataBase();
	foreach($this->article as $index => $article)
	{ if ($article->cart_r == 0) 
	  { $this->insertIntoDataBase($index); 
	  }
	}
	//$this->clear();
	//$this->readFromDataBase();
  }
    
  public function getFromHTMLTemplate($template = NULL, $clear = false)
  { $template = parent::getFromHTMLTemplate($template, false);
    //$template = ($template == NULL) ? $this->template : $this->setHTMLTemplate($template);
	
    $articles = "";
    foreach($this->article as $index => $article)
	{ //$article->price->setHTMLTemplate($this->ttemplate);
	  $articles .= $article->getFromHTMLTemplate($this->ttemplate) . "<!-- INDEX $index -->";
	}
	
	$template = str_replace("~ARTICLES~",$articles,$template);
	//$template = str_replace("~DELIVERY~",twebshop_price::toCurrency(($this->delivery == 0.00) ? $this->getDeliveryPrice() : $this->delivery),$template);
	//$template = str_replace("~DELIVERY~",twebshop_price::toCurrency($this->delivery),$template);
	$template = str_replace("~DELIVERY~",$this->delivery->getFromHTMLTemplate($this->ttemplate),$template);
	$template = str_replace("~POSITIONS~",$this->positions,$template);
	$template = str_replace("~SUM~",twebshop_price::toCurrency($this->getSum()),$template);
	
	if ($clear)
	{ $this->clearHTMLTemplate();
	}	
	return $template;
  }
 
  public function __wakeup()
  { self::$instance = $this;
  }
  
  public function __toString()
  { return self::CLASS_NAME;
  }
}


?>
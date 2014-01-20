<?php
// TORGAMON CLASS, PHP5, TWEBSHOP
// by Thorsten Schroff, 2005, thorsten.schroff@cargobay.de

/*** DOKUMENTATION DER ORGAMON-REMOTE-METHODEN **************************************************************
* abu.BasePlug(): array of string;    
*   -> returns Datenbankname, HeBuAdmin Version, IBO Version, Indy Version, PDF Pfad, MP3 Pfad
* ---> torgamon->getSystemStrings()
*
* abu.ArtikelSuche(SuchStr: string, SORTIMENT_R: integer): array of integer;
*   -> returns Artikel_R der Suchtreffer
* ---> torgamon->searchArticle(string, integer)
*
* abu.ArtikelInfo(AUSGABEART_R, ARTIKEL_R, LAND_R, VERLAG_R) : double, string;
*   -> Multi-Info-Funktion für weitere Informationen zu Artikel-Daten
*   -> returns Preis, "ISO-Landeskennzeichen" "-" "Verlag"
* ---> torgamon->getArticleInfo(integer,integer,integer,integer)
* 
* abu.ArtikelPreis(AUSGABEART_R, ARTIKEL_R: integer): double;
*   -> returns Preis
* ---> torgamon->getDefaultPrice(integer, integer)
* 
* abu.ArtikelRabattPreis(AUSGABEART_R, ARTIKEL_R, PERSON_R: integer): array(2) of double; 
*   -> returns Preis (brutto), Prozent (absolut)
* ---> torgamon->getSpecialPrice(integer, integer, integer)
* 
* abu.ArtikelVersendetag(AUSGABEART_R, ARTIKEL_R: integer): integer;
*   -> returns Anzahl der Tage
* ---> torgamon->getAvailability(integer,integer)
* 
* abu.Versandkosten(PERSON_R: integer): double;
*   -> returns Versandkosten für den aktuellen Inhalt des Einkaufswagens
* ---> torgamon->getDeliveryPrice(integer)
* 
* abu.KontoInfo(PERSON_R: integer): double;
*   -> returns Kontostand
* ---> torgamon->getAccountInfo(integer)
* 
* abu.Verlag(VERLAG_R:integer): string;
*   -> returns Name des Verlags
* ---> torgamon->getPublisher(integer);
* 
* abu.Bestellen(PERSON_R: integer): double;
*   -> returns BELEG_R, wandelt den Einkaufswagen in Bestellung um
* ---> torgamon->execOrder(integer)
* 
* abu.PersonNeu(): integer; 
*   -> returns PERSON_R des neuen Datensatzes		
* ---> torgamon->newPerson()
************************************************************************************************************/

define("ORGAMON_DEFAULT_SERVER","localhost");
define("ORGAMON_DEFAULT_PORT",3049);
define("ORGAMON_DEFAULT_PATH","");

define ("METHODPREFIX","abu");

class torgamon
{ static private $instance = NULL;

  private $xmlrpc;
  
  public $sys_string = array();
  
  static private $name = "PHP5CLASS T_ORGAMON";

  private function __construct($server, $port, $path)
  { $this->xmlrpc = txmlrpc::create($server,$port,$path);
    $this->getSystemStrings(); 
  }
  
  static public function create($server = ORGAMON_DEFAULT_SERVER, $port = ORGAMON_DEFAULT_PORT, $path = ORGAMON_DEFAULT_PATH)
  { if (!torgamon::$instance) 
    { torgamon::$instance = new torgamon($server,$port,$path); }
	return torgamon::$instance;
  }
    
  public function getSystemStrings()
  { $system_strings = $this->xmlrpc->sendRequest(METHODPREFIX . ".BasePlug");
    if (($system_strings != NULL) AND (!$this->xmlrpc->error)) 
	{ $system_strings[0] = str_replace("XMLRPC",$this->xmlrpc->server,$system_strings[0]); 
      $this->sys_string = $system_strings;
	}
	return $system_strings;
  }
  
  public function searchArticle($search, $assortment_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".ArtikelSuche",array("_ ".$search,$assortment_r));
  }
  
  public function getArticleInfo($version_r, $article_r, $country_r, $publisher_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".ArtikelInfo",array($version_r, $article_r, $country_r, $publisher_r));
  }
  
  public function getDefaultPrice($version_r, $article_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".ArtikelPreis",array($version_r, $article_r));
  }
 
  public function getSpecialPrice($version_r, $article_r, $person_r = 0)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".ArtikelRabattPreis",array($version_r, $article_r, $person_r));
  }
  
  public function getPrice($version_r, $article_r, $person_r = 0)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Preis",array($version_r, $article_r, $person_r));
  }
  
  public function getDiscount($person_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Rabatt",array($person_r));
  }
  
  public function getAvailability($version_r, $article_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".ArtikelVersendetag",array($version_r, $article_r));
  }
  
  public function getDeliveryPrice($person_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Versandkosten",array($person_r));
  }  
  
  public function getAccountInfo($person_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".KontoInfo",array($person_r));
  }
  
  public function getPublisher($country_r, $publisher_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Verlag",array($country_r,$publisher_r));
  }
  
  public function execOrder($person_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Bestellen",array($person_r));
  }
  
  public function newPerson()
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".PersonNeu",array());
  }
  
  public function getPlace($person_r)
  { return $this->xmlrpc->sendRequest(METHODPREFIX . ".Ort",array($person_r)); }

  public function __toString()
  { return torgamon::$name; }
}

?>
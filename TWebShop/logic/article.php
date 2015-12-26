<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_article extends tvisual {

    static public $properties = array("TITEL", "KOMPONIST_R", "ARRANGEUR_R", "RID", "LAND_R", "SORTIMENT_R", "NUMERO", "VERLAG_R", "VERLAGNO", "RANG", "DAUER", "SCHWER_GRUPPE", "SCHWER_DETAILS", "ERSTEINTRAG", "PROBESTIMME", "WEBSHOP", "INTERN_INFO", "LAUFNUMMER");
    protected $rid = 0;
    protected $uid = "";
    protected $wid = NULL;

    // Caching
    protected $image_r = NULL; // DOKUMENT.RID
    protected $image = NULL; // FileName des Artikelbildes
    protected $thumb = NULL; // FileName des Thumbnails des Artikelbildes
    protected $info = NULL;

    protected $links = NULL; // Alle gespeicherten Links zu einem Artikel
    protected $sounds = NULL; // Aus "links" alle mp3 Dateien
    protected $demos = NULL; // Aus "links" den ganzen Rest
    protected $members = NULL; // CD - Tracks
    protected $records = NULL; // CD - Tracks Anzahl
    protected $publisher = NULL; // Verlag

    public $notice = "";
    public $version_r = 0;
    public $person_r = 0;
    public $cart_r = 0;
    protected $position = NULL;
    public $timestamp = "";
    public $quantity = 1;
    public $detail = "";
    public $price = NULL;
    public $availability = NULL;
   
    private $autoplay = false;
    
    const CONTEXT_R_RECORD = TWEBSHOP_ARTICLE_CONTEXT_R_RECORD;
    const MP3_DOWNLOAD_POSTFIX = MP3_DOWNLOAD_POSTFIX;

    static private $MP3_PATH = "";

    const TABLE = TABLE_ARTICLE;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE";

    /* @var $errorlist terrorlist */

    public function __construct($rid, $version_r = 0, $person_r = 0, $quantity = 1, $detail = "", $cart_r = 0) {


        $this->rid = (preg_match("/^[0-9]{1,8}$/", strval($rid))) ? intval($rid) : twebshop_article::decryptRID($rid);
        //echo $this->rid;
        $this->version_r = $version_r;
        $this->person_r = $person_r;
        $this->quantity = $quantity;
        $this->detail = $detail;
        $this->cart_r = $cart_r;
        $this->getProperties();
        $this->price = new twebshop_price($this->rid, $this->version_r, $this->person_r, $this->quantity);
    }

    public function __wakeup() {
        parent::__wakeup();
    }

    /* --> 10.10.2014 michaelhacksoftware : Sprechenden Link erstellen */
    public function createLink() {

        if (!$this->rid) return __INDEX;

        if ($this->KOMPONIST_R || $this->ARRANGEUR_R) {
            $Musician = $this->KOMPONIST_R ? new twebshop_musician($this->KOMPONIST_R) : new twebshop_musician($this->ARRANGEUR_R);
            $Part1    = "/" . str2url($Musician->VORNAME . " " . $Musician->NACHNAME);
        } else {
            $Part1 = "";
        }

        if ($this->VERLAG_R) {
            $Publisher = new twebshop_publisher($this->VERLAG_R);
            $Part2     = "/" . str2url($Publisher->SUCHBEGRIFF);
        } else {
            $Part2 = "";
        }

        return path() . LINK_ARTICLES . $Part1 . $Part2 . "/" . str2url($this->TITEL) . "." . urlencode(twebshop_article::encryptRID($this->rid));

    }
    /* <-- */

    private function getProperties() {

        global $ibase;
        global $messagelist;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}"; // " LIMIT 1"; // nur 1 Datensatz
        //echo $sql;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        if ($data != NULL) {
            foreach (self::$properties as $name) {
                $this->{$name} = $data->{$name};
            }
        } else {
            trigger_error("ARTIKEL_R '" . $this->rid ."' does not exist in database. client-request: " . $_SERVER["REQUEST_URI"], E_USER_NOTICE);
            foreach (self::$properties as $name) {
                $this->{$name} = NULL;
            }
        }
    }

    public function getComposer($Link = false) {
        return ($this->KOMPONIST_R != NULL) ? twebshop_musician_list::makeList($this->KOMPONIST_R, $Link) : "-";
    }

    public function getArranger($Link = false) {
        return ($this->ARRANGEUR_R != NULL) ? twebshop_musician_list::makeList($this->ARRANGEUR_R, $Link) : "-";
    }

    public function getInfo() { //echo wrap($this->INTERN_INFO);
        global $ibase;
        if ($this->info == NULL) {
            $this->info = new tmultistringlist();
            if ($this->INTERN_INFO != "") {
                $this->info->assignString($ibase->get_blob($this->INTERN_INFO, 4096));
            }
        }
        return $this->info;
    }

    public function getNotice() {
        if ($this->notice == "") {

            $this->notice = torgamon::processText($this->getInfo()->getValueByName("BEM"));
        }
        return $this->notice;
    }

    public function getMediaName() {
        return $this->NUMERO;
    }

    // getLinks() bildet nebenbei noch $sounds und $demos 
    private function getLinks() {
        
       global $ibase;

       if ($this->links===NULL) {
           
           $this->links = array();
           $this->sounds = array();
           $this->demos = array();

           $result = $ibase->query(
                    " select"
                    ." BEMERKUNG "
                    ."from"
                    ." DOKUMENT "
                    ."where"
                    ." (MEDIUM_R=" . TWEBSHOP_ARTICLE_MEDIUM_R_SOUND . ") and"
                    ." (ARTIKEL_R={$this->rid})");
           while ($data = $ibase->fetch_object($result)) {

                $Items = preg_split("/((\r)*(\n)+)+/", $ibase->get_blob($data->BEMERKUNG, 4096));
                foreach ($Items as $Item) {
                
                    if ($Item == "") 
                      continue;

                    /* === Link auf Windbandmusic überprüfen ### Sonderlösung ### === */
                    if (defined("SHOP_WIND")) {
                        
                        if (strtolower(substr($Item, 0, strlen(SHOP_WIND))) == SHOP_WIND) {

                            $this->links[] = SHOP_WIND . "music/" . $this->LAUFNUMMER . ".mp3"; 
                            
                            parse_str(parse_url($Item, PHP_URL_QUERY),$q);
                         
                            if (array_key_exists("q",$q)) {
                                $q = intval($q["q"]);
                                for ($i = 2; $i <= $q; $i++) {
                                    $this->links[] = SHOP_WIND . "music/" . $this->LAUFNUMMER . chr(63+$i) .  ".mp3"; 
                                }
                            }   
                            continue;
                        }
                    }
                    $this->links[] = $Item;
                }
            }
            $ibase->free_result($result);
        

        foreach ($this->links as $item) {

            /* === Abspielbare Lieder anhand Endung ermitteln === */
            if (strtolower(substr($item, -4)) == ".mp3") {
                $this->sounds[] = $item;
            } else {
                $this->demos[] = new twebshop_article_link(self::encryptRID($this->rid), $this->TITEL,$item);
            }
        }
        
        // fb(sprintf("(sounds=%d,demos=%d)",count($this->sounds),count($this->demos)), "Media", FirePHP::INFO);

      }
      
      return $this->links; // Alle gespeicherten Links zu einem Artikel
    }
    
    
    /* --> 27.06.2014 michaelhacksoftware : Nur tatsächlich abspielbare Lieder und Links trennen */
    /* getSounds() die direkt ansprechbaren .mp3 Dateien */
    /* getDemos() der ganze Rest */
    
    public function getDemos() {
        
        if ($this->demos===NULL) {
            $this->getLinks();
        }    
        return $this->demos;
        
    }
    
    public function getSounds() {

        if ($this->sounds===NULL) {
            $this->getLinks();
        }    
        return $this->sounds;
    }
    
    /* --> 27.06.2014 michaelhacksoftware : JavaScript Code zum Abspielen der Titel generieren */
    public function getPlayCode() {

        /* === Alle abspielbaren Titel laden === */
        $Sounds = $this->getSounds();
        if (!count($Sounds)) return "";
        
        /* === JavaScript Code generieren === */
        $Code = "<script type=\"text/javascript\">"
              . "function PlayTitle_" . $this->NUMERO . "() {"
              . "var play = !parent.isPlaying;";

        // Alle Titel hinzufügen
        for ($i = 0; $i < count($Sounds); $i++) {
            $Code .= "parent.myPlaylist.add({"
                  .  "title:\"" . str_replace("\"", "\\\"", $this->TITEL) . ($i > 0 ? " (" . $i . ")" : "") . "\", artist:\"" . str_replace("\"", "\\\"", $this->getComposer()) . "\", mp3:\"" . $Sounds[$i] . "\""
                  .  "}, " . (!$i ? "play" : "false") . ");";
        }

        $Code .= "}";

        // Evtl. Autoplay einfügen
        if ($this->autoplay) {
            $Code .= "PlayTitle_" . $this->NUMERO . "();";
        }
        
        $Code .= "</script>";

        return $Code;

    }
    /* <-- */

    /* --> 07.07.2014 michaelhacksoftware : AutoPlay setzen */
    public function setAutoPlay() {
        $this->autoplay = true;
    }
    /* <-- */
    
 

    public function existsMP3Download($path = "") { //Downloadbare MP3-Datei
        return file_exists($this->getMP3DownloadFileName($path));
    }

    public function getMP3DownloadFileName($path = "") {
        $path = ($path == "") ? self::$MP3_PATH : $path;
        return path_format($path, true, true) . $this->getMediaName() . self::MP3_DOWNLOAD_POSTFIX . ".mp3";
        // eMail 31.01.2011
        // Dateimaske der vollständen Aufnahme: ~Numero~-9*.mp3
        // Aktuell:
        // a) Mehrsätzigkeit ist im Moment NICHT programmiert
        // b) die Titel einfach z.B. "92812-9.mp3" nennen! 
    }

    public function getMiniScore($path) {
        $file = path_format($path, true, true, "") . $this->getMediaName() . ".pdf";
        //echo $file;
        return (file_exists($file)) ? $file : false;
    }
    
    public function existRecords() { //Tonträger (CD)

        global $ibase;
        if ($this->records===NULL) {
            
            $this->records = 0;
            if (trim($this->getInfo()->getValueByName("CDRID")) != "") {
              $this->records++;  
            } else {
                  $sql = 
                       "SELECT COUNT(*) FROM " 
                          . TABLE_ARTICLE_MEMBER 
                          . " WHERE (ARTIKEL_R={$this->rid}) AND (MASTER_R != {$this->rid}) AND (CONTEXT_R=" . self::CONTEXT_R_RECORD . ")";
                   $this->records = $ibase->get_field($sql, "COUNT");
               
            }
        }
        return ($this->records > 0);
        
    }

    public function getMembers() {

        global $ibase;
                
        if ($this->members===NULL) {
            
          $this->members = array();
          $result = $ibase->query(
            "select "
            ." coalesce (A.RID, 0) as RID,"
            ." M.POSNO||'. '||coalesce (M.TITEL, A.TITEL) as TITEL "
            ."from" 
            ." ARTIKEL_MITGLIED as M " 
            ."left join " 
            ." ARTIKEL as A "
            ."on"
            ." (M.ARTIKEL_R=A.RID) "
            ."where"
            ." (M.MASTER_R={$this->rid}) "
            ."order by"
            ." M.POSNO");
          while ($data = $ibase->fetch_object($result)) {
            $id = $data->RID;
            $title = $data->TITEL;
            if ($id != 0) {
                $this->members[$id] = new twebshop_article_link(self::encryptRID($id), $title, "");
            } else {
                $this->members[] = $title;
            }
          }
          $ibase->free_result();
        }
     
        return $this->members;
    }

    public function getPublisher() {

        global $orgamon;
       
        if ($this->publisher===NULL) {
        
            if ($this->VERLAG_R == NULL) { $this->VERLAG_R = 0; }
            if ($this->LAND_R == NULL)   { $this->LAND_R   = 0; }
            $this->publisher = $orgamon->getPublisher($this->LAND_R,$this->VERLAG_R);
        }
        return $this->publisher;
    }

    public function getDuration() {
        return ($this->DAUER != "") ? ($this->DAUER . "&nbsp;min") : "";
    }

        //15.08.2011: eigentlich sollte bei der Abfrage auch noch die Menge übergeben werden
        //05.12.2011: kann aber per availability->getQuantity abgefragt werden
        //15.08.2011: Wenn noch NULL ODER (ein Objekt AND veraltet) neu instanzieren ODER updaten
    public function getAvailability() { 

        if ($this->availability == NULL) {
            $this->availability = new twebshop_availability($this->rid, $this->version_r);
        } else if (is_object($this->availability) AND ($this->availability->needsUpdate($this->rid, $this->version_r))) {
            $this->availability->doUpdate($this->rid, $this->version_r);
        }
        return $this->availability;
    }

    public function getTreeCode() {
        global $tree;
        return $tree->getCodeByArticle($this->rid);
    }

    public function getTreePath() {
        global $tree;
        $code = $this->getTreeCode();

        return ($code !== false) ? $tree()->getPath($code) : "";
    }

    public function getiRID() {
        return $this->rid;
    }

    public function getRID() {
        return twebshop_article::encryptRID($this->rid);
    }

    public function getUID() {
        $this->uid = self::buildUID($this->getRID(), $this->version_r, $this->detail);
        return $this->uid;
    }

    public function setWID($wid) {
        $this->wid = $wid;
    }

    public function getWID() {
        return $this->wid;
    }

    public function setVersion($version_r = 0) {
        $tmp_version_r = $this->version_r;
        $this->version_r = $version_r;
        if ($this->version_r != $tmp_version_r) {
            $this->setPrice();
            $this->getUID();
        }
    }

    public function getVersion($null = false) {
        return ($this->version_r == 0 AND $null) ? "NULL" : $this->version_r;
    }

    public function setPerson($person_r = 0) {
        $tmp_person_r = $this->person_r;
        $this->person_r = $person_r;
        if ($this->person_r != $tmp_person_r)
            $this->setPrice();
    }

    public function setQuantity($quantity = 1) {
        $tmp_quantity = $this->quantity;
        $this->quantity = $quantity;
        if ($this->quantity != $tmp_quantity)
            $this->setPrice();
    }

    public function incQuantity($quantity = 1) {
        $this->setQuantity($this->quantity + $quantity);
    }

    public function setDetail($detail = "") {
        $this->detail = $detail;
        $this->getUID();
    }

    private function setPrice() {
        $this->price->resetValues($this->version_r, (isset($this->person_r)) ? $this->person_r : 0, $this->quantity);
    }

    public function setPosition($position) {
        $this->position = intval($position);
    }

    public function getPosition() {
        return $this->position;
    }

    public function getFromHTMLTemplate($template = NULL) {

        global $article_variants;
        $template = parent::getFromHTMLTemplate($template);

        $version = "";
        if (strpos($template, "~VERSION~") !== false) {

            if ($article_variants->existsVersion($this->version_r) AND $article_variants->getByID($this->version_r)->isPublic()) {

                $article_variants->setSelected($this->version_r);
                $article_variants->setDetail($this->detail);
                $article_variants->setID($this->uid);
                $template = str_replace("~VERSION~", $article_variants->getFromHTMLTemplate($this->_ttemplate), $template);
                
            } else {
                
                $version = $article_variants->getByID($this->version_r)->getName();
                $template = str_replace("~VERSION~", $version, $template);
                
            }
        }

        $this->getMembers();
        $members = "";
        foreach ($this->members as $tmp_member) {
            if (is_object($tmp_member) AND is_a($tmp_member, "twebshop_article_link")) {
                $members.= $tmp_member->getFromHTMLTemplate($this->_ttemplate);
            } else {
                $members.= $tmp_member . "<br />";
            }
            unset($tmp_member);
        }

        $template = str_replace("~PARTS_LIST~",    $this->templatePartsList(),    $template);   // 14.01.2015 michaelhacksoftware : Downloadbare Stimmen anzeigen
        $template = str_replace("~YOUTUBE_FRAME~", $this->templateYouTubeFrame(), $template);   // 06.03.2015 michaelhacksoftware : YouTube Videos eingebettet anzeigen
        $template = str_replace("~YOUTUBE_LINK~",  $this->templateYouTubeLink(),  $template);   // 21.05.2015 michaelhacksoftware : YouTube Links anzeigen

        $template = str_replace("~ARRANGER~", $this->getArranger(false), $template);
        $template = str_replace("~ARRANGER_LINK~", $this->getArranger(true), $template);
        $template = str_replace("~AVAILABILITY~", ($this->availability != NULL) ? $this->availability->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = str_replace("~BEM~", ($this->info != NULL AND ($tmp = $this->getNotice()) != "") ? nl2br($tmp) : SENTENCE_NO_FURTHER_INFORMATION_AVAILABLE, $template);
        $template = str_replace("~CID~", $this->cart_r, $template);
        $template = str_replace("~COMPOSER~", $this->getComposer(false), $template);
        $template = str_replace("~COMPOSER_LINK~", $this->getComposer(true), $template);
        $template = str_replace("~DAUER~", $this->getDuration(), $template);
        $template = str_replace("~DETAIL~", $this->detail, $template);
        $template = str_replace("~UID~", ($this->uid == "") ? $this->getUID() : $this->uid, $template);
        $template = str_replace("~IMAGE~", ($this->getFileName_Image()==false) ? "" : $this->getFileName_Image(), $template);
        //$template = str_replace("~IMAGES~", ($this->getFileName_Image()==false) ? "" : $this->getFileName_Image(), $template);
        $template = str_replace("~LINK~", $this->createLink(), $template);
        $template = str_replace("~MEMBERS~", $members, $template);
        $template = (strpos($template, "~MP3_FILE_SIZE~", 0) !== false) ? str_replace("~MP3_FILE_SIZE~", ($this->existsMP3Download()) ? file_size_MB($this->getMP3DownloadFileName()) : "", $template) : $template;
        $template = str_replace("~NUMERO~", $this->NUMERO, $template);
        $template = str_replace("~POSITION~", $this->position, $template);
        $template = str_replace("~PRICE~", ($this->price != NULL) ? $this->price->getFromHTMLTemplate($this->_ttemplate) : "", $template);

        //$template = str_replace("~PUBLISHER~", "", $template);
        /*$template = (strpos($template, "~PUBLISHER~", 0) !== false) ? 
         * str_replace("~PUBLISHER~", ($this->publisher == "") ? 
         * $this->getPublisher() : $this->publisher, $template) : $template; 
         * # 22.08.2014 michaelhacksoftware | getPublisher wieder aktiviert, deswegen auskommentiert */
        
        $template = str_replace("~QUANTITY~", $this->quantity, $template);
        $template = str_replace("~RID~", urlencode(twebshop_article::encryptRID($this->rid)), $template);
        $template = str_replace("~RID_INT~", $this->rid, $template);
        $template = str_replace("~RID_RAW~", twebshop_article::encryptRID($this->rid), $template);
        $template = str_replace("~SCHWER_DETAILS~", (($this->SCHWER_DETAILS != NULL) ? ("(" . $this->SCHWER_DETAILS . ")") : ""), $template);
        $template = str_replace("~SCHWER_GRUPPE~", $this->SCHWER_GRUPPE, $template);
        $template = str_replace("~THUMB~", ($this->getFileName_Thumbnail()==false) ? "" : $this->getFileName_Thumbnail(), $template);
        $template = str_replace("~TITEL~", $this->TITEL, $template);
        $template = str_replace("~TITEL_NO_QUOTES~", stripquotes($this->TITEL), $template);
        $template = str_replace("~TREE_CODE~", $this->getTreeCode(), $template);
        $template = str_replace("~TREE_PATH~", $this->getTreePath(), $template);
        $template = str_replace("~VERSION_R~", $this->version_r, $template);
        $template = str_replace("~WID~", $this->wid, $template);

        unset($members);

        return $template;
    }

    /* --> 14.01.2015 michaelhacksoftware : Downloadbare Stimmen */
    public function getParts() {
    
        $Items = array();

        /* === Verfügbare Stimmen ermitteln === */
        foreach (glob(SHOP_PARTS_DIR . $this->NUMERO . "-*-*.pdf") as $File) {

            $File = substr($File, strlen(SHOP_PARTS_DIR));
            $File = substr($File, 0, -4);

            $Items[] = explode("-", $File);

        }

        return $Items;

    }
    /* <-- */

    /* --> 06.03.2015 michaelhacksoftware : YouTube ID ausgeben, sofern vorhanden */
    public function getYouTubeID() {

        /* === Alle vorhandenen Songs durchgehen === */
        foreach ($this->sounds as $Sound) {

            $Url = parse_url($Sound);

            /* === Link auf YouTube Video prüfen === */
            if ((strtolower($Url['host']) == "www.youtube.com") and strtolower($Url['path']) == "/watch") {

                parse_str($Url['query'], $Query);

                if (isset($Query['v'])) {
                    return $Query['v'];
                }

            }

        }

        return "";

    }
    /* <-- */


    /* --> 14.01.2015 michaelhacksoftware : Template für Downloadbare Stimmen erzeugen */
    private function templatePartsList() {

        /* === Stimmen holen === */
        $Parts = $this->getParts();
        
        if (!count($Parts)) {
            return "";
        }

        /* === Einleitungstext === */
        $PartsList = "<br><b>" . SENTENCE_AVAILABLE_SINGLEPARTS_TO_DOWNLOAD . "</b><br><br>";

        /* === Stimmen auflisten und Namen ermitteln === */
        foreach ($Parts as $Part) {

            if ($Part[2] != "0") continue; // Aktuell nur kostenlose Stimmen zulassen

            // Namen anhand der Ausgabeart ermitteln
            $Kind = substr($Part[1], 6);
            $Name = self::getPartKindName($Kind);

            if (!$Name) continue;

            // Stimme hinzufügen
            $Line = str_replace("~PART_NAME~", $Name, _TEMPLATE_ARTICLE_ARTICLE_OPTION_PARTS_ITEM);
            $Line = str_replace("~PART_KIND~", $Kind, $Line);

            $PartsList .= $Line . "<br>";

        }

        return $PartsList;

    }
    /* <-- */

    /* --> 06.03.2015 michaelhacksoftware : Template für YouTube Videos erzeugen */
    private function templateYouTubeFrame() {

        /* === YouTube ID ermitteln === */
        $YouTubeID = $this->getYouTubeID();

        if (!$YouTubeID) {
            return "";
        }

        return str_replace("~YOUTUBEID~", $YouTubeID, _TEMPLATE_ARTICLE_YOUTUBE_FRAME);

    }
    /* <-- */

    /* --> 21.05.2015 michaelhacksoftware : Template für YouTube Links erzeugen */
    private function templateYouTubeLink() {

        /* === YouTube ID ermitteln === */
        $YouTubeID = $this->getYouTubeID();

        if (!$YouTubeID) {
            return "";
        }

        return str_replace("~YOUTUBEID~", $YouTubeID, _TEMPLATE_ARTICLE_YOUTUBE_LINK);

    }
    /* <-- */

    
    static public function buildUID($article_r, $version_r, $detail) {
        return md5($article_r . $version_r . $detail);
    }

    static public function encryptRID($id) {
        $crypt_ID = tcryptID::create();
        return $crypt_ID->encrypt($id);
    }

    static public function decryptRID($id) {
        $crypt_ID = tcryptID::create();
        return $crypt_ID->decrypt($id);
    }

    public function getImage_R() {

        global $ibase;
        
        if ($this->image_r===NULL) {

            $ibase->query(
                    "select RID from DOKUMENT where (MEDIUM_R=" 
                    . TWEBSHOP_ARTICLE_MEDIUM_R_IMAGE . ") and (ARTIKEL_R=$this->rid)");
            $data=$ibase->fetch_object();
            if ($data) {
                $this->image_r = $data->RID;
                fb($this->image_r,"image_r");
            } else {
                $this->image_r = false;
            }
            $ibase->free_result();
        }
	return $this->image_r;
   }
	
    public function getFileName_Thumbnail() {

        global $orgamon;
        
        if ($this->thumb===NULL) {
            $id = $this->getImage_R();
            if ($id==false) {
                $this->thumb = false;
            } else {
                $this->thumb = $orgamon->getThumbFileName($id);
            }
        }
        return $this->thumb;
    }

    public function getFileName_Image() {

        global $orgamon;
        
        if ($this->image===NULL) {
            $id = $this->getImage_R();
            if ($id==false) {
                $this->image = false;
            } else {
                $this->image = $orgamon->getImageFileName($id);
            }
        }
        return $this->image;
    }

    static public function getArticleProperty($article_r, $property) {

        global $ibase;

        $sql = "SELECT $property FROM " . self::TABLE . " WHERE RID={$article_r}";
        $result = $ibase->get_field($sql, $property);

        return $result;
    }

    static public function getArticleDifficulty($article_r) {
        return self::getArticleProperty($article_r, "SCHWER_GRUPPE");
    }

    static public function getArticleTitle($article_r) {
        return self::getArticleProperty($article_r, "TITEL");
    }

    static public function setMP3Path($path) {
        self::$MP3_PATH = $path;
    }

    /* --> 14.01.2015 michaelhacksoftware : Name der Ausgabeart */
    static public function getPartKindName($Kind) {
    
        global $ibase;
        
        $sql    = "SELECT NAME FROM AUSGABEART WHERE RID = " . $Kind;
        $result = $ibase->get_field($sql, "NAME");
        
        return $result;

    }
    /* <-- */

}

?>

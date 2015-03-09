<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_article extends tvisual {

    static public $properties = array("TITEL", "KOMPONIST_R", "ARRANGEUR_R", "RID", "LAND_R", "SORTIMENT_R", "NUMERO", "VERLAG_R", "VERLAGNO", "RANG", "DAUER", "SCHWER_GRUPPE", "SCHWER_DETAILS", "ERSTEINTRAG", "PROBESTIMME", "WEBSHOP", "INTERN_INFO", "LAUFNUMMER");
    protected $rid = 0;
    protected $uid = "";
    protected $wid = NULL;
    public $version_r = 0;
    public $person_r = 0;
    public $cart_r = 0;
    protected $position = NULL;
    public $timestamp = "";
    public $quantity = 1;
    public $detail = "";
    public $price = NULL;
    public $availability = NULL;
    public $publisher = "";
    public $info = NULL;
    public $notice = "";
    public $thumbs = array();
    public $images = array();
    public $sounds = array();
    public $members = array();
    private $autoplay = false;
    
    const MEDIUM_R_SOUND = TWEBSHOP_ARTICLE_MEDIUM_R_SOUND;
    const MEDIUM_R_IMAGE = TWEBSHOP_ARTICLE_MEDIUM_R_IMAGE;
    const CONTEXT_R_RECORD = TWEBSHOP_ARTICLE_CONTEXT_R_RECORD;
    const MP3_DOWNLOAD_POSTFIX = MP3_DOWNLOAD_POSTFIX;

    static private $MP3_PATH = "";

    const TABLE = TABLE_ARTICLE;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE";

    /* @var $errorlist terrorlist */

    public function __construct($rid, $version_r = 0, $person_r = 0, $quantity = 1, $detail = "", $cart_r = 0) {


////TS 25-11-2011: ereg ist deprecated 
        //$this->rid = (ereg("^[0-9]{1,8}$",strval($rid))) ? intval($rid) : twebshop_article::decryptRID($rid);
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
            if ($this->info == NULL) {
                $this->getInfo();
            }
            //$this->notice = $this->info->getValueByName("BEM");
            $this->notice = torgamon::processText($this->info->getValueByName("BEM"));
        }
        return $this->notice;
    }

    public function getThumbs() {
        $this->thumbs = self::getArticleThumbs($this->rid);
        return $this->thumbs;
    }

    public function getThumb($index = 0) {
        return $this->thumbs[$index];
    }

    public function getImages() {
        $this->images = self::getArticleImages($this->rid);
        return $this->images;
    }

    public function getImage($index = 0) {
        return $this->images[$index];
    }

    public function getMediaName() {
        return $this->NUMERO;
    }

    /* --> 27.06.2014 michaelhacksoftware : Nur tatsächlich abspielbare Lieder und Links trennen */
    public function getSounds($OnlyPlayable) {

        global $ibase;

        /* === Lieder aus Datenbank laden === */
        if (empty($this->sounds)) {
        
            $result = $ibase->query("SELECT BEMERKUNG FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_SOUND . " AND ARTIKEL_R={$this->rid})");
            while ($data = $ibase->fetch_object($result)) {

                $Items = preg_split("/((\r)*(\n)+)+/", $ibase->get_blob($data->BEMERKUNG, 4096));

                foreach ($Items as $Item) {
                
                    if ($Item == "") continue;

                    /* === Links auf Windbandmusic überprüfen ### Sonderlösung ### === */
                    if (strtolower(substr($Item, 0, 28)) == "http://www.windbandmusic.com") {
                        $Music = $this->getWindbandmusic($this->LAUFNUMMER);
                        $this->sounds = array_merge($this->sounds, $Music);
                    } else {
                        $this->sounds[] = $Item;
                    }

                }

            }
            $ibase->free_result($result);

        }

        $Sounds = array();

        foreach ($this->sounds as $Sound) {

            /* === Abspielbare Lieder anhand Endung ermitteln === */
            if (strtolower(substr($Sound, -4)) == ".mp3") {
                $Playable = true;
            } else {
                $Playable = false;
            }

            /* === Abspielbare Lieder und Links trennen === */
            if ($OnlyPlayable) {
                if ($Playable)  $Sounds[] = $Sound;
            } else {
                if (!$Playable) $Sounds[] = new twebshop_article_link(self::encryptRID($this->rid), $this->TITEL, $Sound);
            }

        }

        return $Sounds;

    }
    /* <-- */

    /* --> 27.06.2014 michaelhacksoftware : JavaScript Code zum Abspielen der Titel generieren */
    public function getPlayCode() {

        /* === Alle abspielbaren Titel laden === */
        $Sounds = $this->getSounds(true);
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

    /* --> 27.06.2014 michaelhacksoftware : MP3s von Windbandmusic ermitteln ### Sonderlösung ### */
    private function getWindbandmusic($Laufnummer) {

        $Result = array();

        /* === Mp3 Dateien von Windbandmusic auslesen === */
        $Input  = "";
        $Socket = fsockopen("www.windbandmusic.com", 80, $errno, $errstr, 5);

        if ($Socket) {

            fputs($Socket, "GET /index.php5?action=get_media&id=" . $Laufnummer . " HTTP/1.0\r\nHost: www.windbandmusic.com\r\n\r\n");

            while (!feof($Socket)) {
                $Input .= fgets($Socket, 256);
            }

            fclose($Socket);

        }

        $Input = substr($Input, strpos($Input, "\r\n\r\n") + 4);
        $Lines = explode('\n', $Input);

        foreach ($Lines as $Line) {
            if ($Line == "") continue;
            $Result[] = "http://www.windbandmusic.com/music/" . $Line; // Link zur Datei zusammensetzen
        }

        return $Result;

    }
    /* <-- */

    /* --> 07.07.2014 michaelhacksoftware : AutoPlay setzen */
    public function setAutoPlay() {
        $this->autoplay = true;
    }
    /* <-- */
    
    public function existRecords() { //Tonträger (CD)
        global $ibase;
        $sql = "SELECT COUNT(*) FROM " . TABLE_ARTICLE_MEMBER . " WHERE (ARTIKEL_R={$this->rid}) AND (MASTER_R != {$this->rid}) AND (CONTEXT_R=" . self::CONTEXT_R_RECORD . ")";
        $count = $ibase->get_field($sql, "COUNT");

        if ($this->info == NULL) {
            $this->getInfo();
        }
        return (($this->info != NULL AND trim($this->info->getValueByName("CDRID")) != "") OR $count > 0);
    }

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

    public function getMembers() {

        global $ibase;
        $this->members = array();
        

        $result = $ibase->query("SELECT COALESCE( A.RID, 0) AS RID, M.POSNO||'. '||COALESCE( M.TITEL, A.TITEL ) AS TITEL FROM " . TABLE_ARTICLE_MEMBER . " AS M LEFT JOIN " .
                self::TABLE . " AS A ON M.ARTIKEL_R=A.RID WHERE M.MASTER_R={$this->rid} ORDER BY M.POSNO");
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
        
        return $this->members;
    }

    public function getPublisher() {

        global $orgamon;
        
        if (!$this->publisher) {
            if ($this->VERLAG_R == NULL) { $this->VERLAG_R = 0; }
            if ($this->LAND_R == NULL)   { $this->LAND_R   = 0; }
            $this->publisher = $orgamon->getPublisher($this->LAND_R,$this->VERLAG_R);
        }

        return $this->publisher;

    }

    public function getDuration() {
        return ($this->DAUER != "") ? ($this->DAUER . "&nbsp;min") : "";
    }

    public function getAvailability() { //15.08.2011: eigentlich sollte bei der Abfrage auch noch die Menge übergeben werden
        //05.12.2011: kann aber per availability->getQuantity abgefragt werden
        //15.08.2011: Wenn noch NULL ODER (ein Objekt AND veraltet) neu instanzieren ODER updaten
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

    public function getAll() {
        $this->getThumbs();
        $this->getImages();
        $this->getPublisher();
        $this->getAvailability();
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

        $members = "";
        foreach ($this->members as $tmp_member) {
            if (is_object($tmp_member) AND is_a($tmp_member, "twebshop_article_link")) {
                $members.= $tmp_member->getFromHTMLTemplate($this->_ttemplate);
            } else {
                $members.= $tmp_member . "<br />";
            }
            unset($tmp_member);
        }

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
        $template = str_replace("~IMAGE~", (count($this->images) > 0) ? $this->getImage(0) : "", $template);
        $template = str_replace("~IMAGES~", (count($this->images) > 0) ? implode(",", $this->images) : "", $template);
        $template = str_replace("~LINK~", $this->createLink(), $template);
        $template = str_replace("~MEMBERS~", $members, $template);
        $template = (strpos($template, "~MP3_FILE_SIZE~", 0) !== false) ? str_replace("~MP3_FILE_SIZE~", ($this->existsMP3Download()) ? file_size_MB($this->getMP3DownloadFileName()) : "", $template) : $template;
        $template = str_replace("~NUMERO~", $this->NUMERO, $template);
        $template = str_replace("~POSITION~", $this->position, $template);
        $template = str_replace("~PRICE~", ($this->price != NULL) ? $this->price->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = str_replace("~PUBLISHER~", "", $template); /*$template = (strpos($template, "~PUBLISHER~", 0) !== false) ? str_replace("~PUBLISHER~", ($this->publisher == "") ? $this->getPublisher() : $this->publisher, $template) : $template; # 22.08.2014 michaelhacksoftware | getPublisher wieder aktiviert, deswegen auskommentiert */
        $template = str_replace("~QUANTITY~", $this->quantity, $template);
        $template = str_replace("~RID~", urlencode(twebshop_article::encryptRID($this->rid)), $template);
        $template = str_replace("~RID_INT~", $this->rid, $template);
        $template = str_replace("~RID_RAW~", twebshop_article::encryptRID($this->rid), $template);
        $template = str_replace("~SCHWER_DETAILS~", (($this->SCHWER_DETAILS != NULL) ? ("(" . $this->SCHWER_DETAILS . ")") : ""), $template);
        $template = str_replace("~SCHWER_GRUPPE~", $this->SCHWER_GRUPPE, $template);
        $template = str_replace("~THUMB~", (count($this->thumbs) > 0) ? $this->getThumb(0) : "", $template);
        $template = str_replace("~TITEL~", $this->TITEL, $template);
        $template = str_replace("~TITEL_NO_QUOTES~", stripquotes($this->TITEL), $template);
        $template = str_replace("~TREE_CODE~", $this->getTreeCode(), $template);
        $template = str_replace("~TREE_PATH~", $this->getTreePath(), $template);
        $template = str_replace("~VERSION_R~", $this->version_r, $template);
        $template = str_replace("~WID~", $this->wid, $template);
        $template = str_replace("~PARTS_LIST~",    $this->templatePartsList(),    $template);   // 14.01.2015 michaelhacksoftware : Downloadbare Stimmen anzeigen
        $template = str_replace("~YOUTUBE_FRAME~", $this->templateYouTubeFrame(), $template);   // 06.03.2015 michaelhacksoftware : YouTube Videos eingebettet anzeigen

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
            $Kind = substr($Item[1], 6);
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

    static public function getArticleThumbs($article_r) {

        global $ibase;
        global $orgamon;

        $ibase->query("SELECT RID FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_IMAGE . " AND ARTIKEL_R=$article_r)");
        $thumbs = array();
        while ($data = $ibase->fetch_object()) {
            $thumbs[] = $orgamon->getThumbFileName($data->RID);
        }
        $ibase->free_result();
        return $thumbs;
    }

    static public function getArticleImages($article_r) {

        global $ibase;
        global $orgamon;

        $ibase->query("SELECT RID FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_IMAGE . " AND ARTIKEL_R=$article_r)");
        $images = array();
        while ($data = $ibase->fetch_object()) {
            $images[] = $orgamon->getImageFileName($data->RID);
        }
        $ibase->free_result();
        return $images;
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

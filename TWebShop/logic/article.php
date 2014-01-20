<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_article extends tvisual {

    static public $properties = array("TITEL", "KOMPONIST_R", "ARRANGEUR_R", "RID", "LAND_R", "SORTIMENT_R", "NUMERO", "VERLAG_R", "RANG", "DAUER", "SCHWER_GRUPPE", "SCHWER_DETAILS", "ERSTEINTRAG", "PROBESTIMME", "WEBSHOP", "INTERN_INFO");
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
    public $composer = "";
    public $arranger = "";
    public $publisher = "";
    public $info = NULL;
    public $notice = "";
    public $thumbs = array();
    public $images = array();
    public $sounds = array();
    public $members = array();

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

    public function getComposer() {
        $this->composer = ($this->KOMPONIST_R != NULL) ? $this->composer = twebshop_musician_list::makeList($this->KOMPONIST_R) : "-";
        return $this->composer;
    }

    public function getArranger() {
        $this->arranger = ($this->ARRANGEUR_R != NULL) ? $this->arranger = twebshop_musician_list::makeList($this->ARRANGEUR_R) : "-";
        return $this->arranger;
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

    public function getSounds() { //Hörproben (Demo) // $this->sounds = file_search($path,"^({$this->getMediaName()})[a-zA-Z]{0,1}\.[mM]{1}[pP]{1}(3)$");
        global $ibase;

        $result = $ibase->query("SELECT BEMERKUNG FROM " . TABLE_DOCUMENT . " WHERE (MEDIUM_R=" . self::MEDIUM_R_SOUND . " AND ARTIKEL_R={$this->rid})");
        while ($data = $ibase->fetch_object($result)) {
            $sounds = preg_split("/((\r)*(\n)+)+/", $ibase->get_blob($data->BEMERKUNG, 4096));
            foreach ($sounds as $sound)
                if ($sound != "")
                    $this->sounds[] = new twebshop_article_link(self::encryptRID($this->rid), $this->TITEL, $sound);
        }
        $ibase->free_result($result);

        return $this->sounds;
    }

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
        //global $orgamon;
        //TS 22.04.2012: folgende Zeilen auskommentiert: Da der Verlag nicht im Shop angezeigt werden soll, kann man den XMLRPC-Aufruf sparen.
        //
        //if ($this->VERLAG_R == NULL) { $this->VERLAG_R = 0; }
        //if ($this->LAND_R == NULL)   { $this->LAND_R   = 0; }
        //$this->publisher = $orgamon->getPublisher($this->LAND_R,$this->VERLAG_R);
        $this->publisher = "";
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
        $this->getComposer();
        $this->getArranger();
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

        $template = str_replace("~ARRANGER~", ($this->arranger == "") ? $this->getArranger() : $this->arranger, $template);
        $template = str_replace("~AVAILABILITY~", ($this->availability != NULL) ? $this->availability->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = str_replace("~BEM~", ($this->info != NULL AND ($tmp = $this->getNotice()) != "") ? nl2br($tmp) : SENTENCE_NO_FURTHER_INFORMATION_AVAILABLE, $template);
        $template = str_replace("~CID~", $this->cart_r, $template);
        $template = str_replace("~COMPOSER~", ($this->composer == "") ? $this->getComposer() : $this->composer, $template);
        $template = str_replace("~DAUER~", $this->getDuration(), $template);
        $template = str_replace("~DETAIL~", $this->detail, $template);
        $template = str_replace("~UID~", ($this->uid == "") ? $this->getUID() : $this->uid, $template);
        $template = str_replace("~IMAGE~", (count($this->images) > 0) ? $this->getImage(0) : "", $template);
        $template = str_replace("~IMAGES~", (count($this->images) > 0) ? implode(",", $this->images) : "", $template);
        $template = str_replace("~MEMBERS~", $members, $template);
        $template = (strpos($template, "~MP3_FILE_SIZE~", 0) !== false) ? str_replace("~MP3_FILE_SIZE~", ($this->existsMP3Download()) ? file_size_MB($this->getMP3DownloadFileName()) : "", $template) : $template;
        $template = str_replace("~NUMERO~", $this->NUMERO, $template);
        $template = str_replace("~POSITION~", $this->position, $template);
        $template = str_replace("~PRICE~", ($this->price != NULL) ? $this->price->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = (strpos($template, "~PUBLISHER~", 0) !== false) ? str_replace("~PUBLISHER~", ($this->publisher == "") ? $this->getPublisher() : $this->publisher, $template) : $template;
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

        unset($members);

        return $template;
    }

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

}
?>
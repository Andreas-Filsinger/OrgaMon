<?php

// TORGAMON CLASS, PHP5, TWEBSHOP
// by Thorsten Schroff, 2005, thorsten.schroff@cargobay.de

/* * * DOKUMENTATION DER ORGAMON-REMOTE-METHODEN **************************************************************

  http://orgamon.org/index.php5/ECommerce#XMLRPC_API
 * ********************************************************************************************************** */

class torgamon {
    // ========================================================================= 
    // 

    const BASEPLUG_DATABASE_NAME = 0;
    // [01] OrgaMon Versions-Nummer
    // [02] IBO Versions-Nummer
    // [03] Indy Versions-Nummer
    const BASEPLUG_MINISCORE_PATH = 4;
    const BASEPLUG_MP3_PATH = 5;
    const BASEPLUG_BILL_PATH = 6;
    const BASEPLUG_TWEBSHOP_IMAGE_URL = 7;
    // [08] GUI: TPicUpload Versions-Nummer (Bilder hochladen)
    //      CONSOLE: Anzahl der bisher verarbeiteten Anfragen dieser Serverinstanz
    // [09] TMS FlexCel Versions-Nummer (XLS Dokument-Ausgabe)
    // [10] jcl Versions-Nummer
    // [11] jvcl Versions-Nummer
    const BASEPLUG_ARTICLE_IMAGE_URL = 12;
    // [13] SynEdit Versions-Nummer
    // [14] VCLZip Versions-Nummer
    // [15] XMLRPC Versions-Nummer "@" Hostname der Serverinstanz ":" XMLRPC-Port der Serverinstanz
    // [16] XML Parser Versions-Nummer
    const BASEPLUG_DATABASE_USER = 17;
    const BASEPLUG_DATABASE_PASSWORD = 18;
    const BASEPLUG_DATABASE_SYSDBA_PASSWORD = 19;
    // [20] verwendete gds32.dll Versions-Nummer
    // [21] PNG - Image Versions-Nummer
    // [22] 
    // [23] 
    // [24] 
    // [25] 
    // [26] Kontext der XMLRPC Server Instanz 
    const BASEPLUG_CONTEXT = 26;

    // ========================================================================= 
// externe Abhängigkeiten
    private $connected = false;
    private $server = "";
    private $port = 0;
    private $path = "";
    private $timeout = 0;
    private $sys_strings = NULL;

    const CLASS_NAME = "PHP5CLASS T_ORGAMON";
    const GLOBAL_NAME = "orgamon";

    // imp pend: leider muss ich requestConnectivity sagen
    // ich würde lieber die Kosntante verwenden, hm, Konstante als
    // Funktiosnname - das geht ja sogar bei einem Compiler 
    public function requestConnectivity() {

        global $ibase;
        // ibase ruft uns, Verbindungs-Parameter zur Datenbank werden
        // jetzt gebraucht.
        $ibase->setConnection(
                $this->getSystemString(torgamon::BASEPLUG_DATABASE_NAME), $this->getSystemString(torgamon::BASEPLUG_DATABASE_USER), $this->decodePassword($this->getSystemString(torgamon::BASEPLUG_DATABASE_SYSDBA_PASSWORD)));
    }

    public function isConnected() {
        return $this->connected;
    }

    public function getContext() {

        /*
         * 
         * hm, Kontext ist eigentlich auch Teil des BasePlug,
         * im Round-Robin System ist der Aufruf problematisch, da eigentlich
         * dauernd der Kontext wechselt, Angedacht war hier, dass 
         * # wenn Kontext=gespeicherter Kontext -> getSystemSettings braucht
         * # in dem Fall NICHT gerufen werden (=Optimierung!)
         * # im Moment zieht das nicht so gut!
          $context = self::$context;
          if (self::$context == NULL) {
          self::$context = $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Kontext");
          }
          if (self::$context != $context) {
          $this->getSystemStrings();
          }
          return self::$context;

         */
    }

    public function getSystemStrings() {

        global $errorlist;
        global $xmlrpc;
        if ($this->sys_strings == NULL) {


            $system_strings = $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".BasePlug");  //1
            if (!is_array($system_strings)) {

                $msg = "TORGAMON: BasePlug returns no array. type:" . gettype($system_strings);
                $errorlist->add($msg);

                trigger_error($msg, E_USER_WARNING);
                return false;
            }
            if (($system_strings != NULL) AND (!$xmlrpc->error)) {

                $system_strings[0] = str_replace("XMLRPC", $xmlrpc->xml_host, $system_strings[0]);
                $this->sys_strings = $system_strings;
            }
        }
        //var_dump($result);
        return $this->sys_strings;
    }
    
    public function getFirebirdStrings() {
        global $ibase;
        global $xmlrpc;
        $result = array();
        $d = $ibase->query("select CURRENT_TIMESTAMP from RDB\$DATABASE");
        $r = $ibase->fetch_object($d);
        $result[] = "Firebird Server TimeStamp=" . $r->CURRENT_TIMESTAMP;
        $result[] = "Round Robin Sequence=" . lastSemiPersistentSequence();
        $result[] = "Round Robin Members=" . $xmlrpc->getHosts();
        $result[] = "Bad XMLRPC-Hosts=" . $xmlrpc->badHosts();
        $ibase->free_result();
        
        return $result;
    }

    public function getSystemString($id) {

        if ($this->sys_strings === NULL) {
            $this->getSystemStrings();
        }

        if (is_array($this->sys_strings)) {
            return $this->sys_strings[$id];
        } else {
            return false;
        }
    }

    static public function sendMail($to, $subject, $body, $initiator_r = "NULL") {

        global $ibase;
        $result = false;
        $person_r = (check_numeric($to)) ? intval($to) : "NULL";
        $recipient = (check_email($to)) ? strtolower($to) : "NULL";
        if ($person_r != "NULL" XOR $recipient != "NULL") {
            $message = html_entity_decode($subject . CRLF . $body, ENT_NOQUOTES);
            $message = stripquotes($message);

            $sql = "INSERT INTO EMAIL (PERSON_R, NACHRICHT, EMPFAENGER, INITIATOR_R) VALUES (" . (($person_r != "NULL") ? "'$person_r'" : $person_r) . ",'$message'," . (($recipient != "NULL") ? "'$recipient'" : $recipient) . ",$initiator_r)";
            //echo $sql;
            $result = $ibase->exec($sql);
        }
        return ($result) ? true : false;
    }

    static public function createEvent($type, $info = "NULL", $person_r = "NULL") {
        $event = new torgamon_event();
        $event->setType($type);
        $event->setInfo($info);
        $event->setPerson($person_r);
        return $event->insertIntoDataBase();
    }

    public function decodePassword($password) {
        if (strlen($password) == 48) { // Password ist verschlüsselt
            $hex = $password;
            $str = "";
            while (strlen($hex) > 1) {
                $str .= chr(hexdec(substr($hex, 0, 2)));
                $hex = substr($hex, 2);
            }
            $cryption = new tcryption("anfisoftOrgaMon");
            $result = trim($cryption->decrypt($str));
            unset($cryption);
        } else {  // Password ist im Klartext
            $result = $password;
        }
        return $result;
    }

    //EXPERIMENTELL !
    public function encodePassword($pwd) {
        $cryption = new tcryption("anfisoftOrgaMon");
        $str = $cryption->encrypt($pwd);
        unset($cryption);
        $hex = "";
        while (strlen($str) > 1) {
            $hex .= sprintf("%02X", ord(substr($str, 0, 1)));
            $str = substr($str, 1);
        }
        return $hex;
    }

    public function getPicturePath() {
        return ($this->getSystemString(torgamon::BASEPLUG_ARTICLE_IMAGE_URL));
    }

    public function getPictureName($id) {
        return sprintf("%08d", $id);
    }

    public function getThumbFileName($id) {
        return ($this->getPicturePath() . $this->getPictureName($id) . "th.jpg");
    }

    public function getImageFileName($id) {
        return ($this->getPicturePath() . $this->getPictureName($id) . ".jpg");
    }

    public function searchArticle($search, $assortment_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".ArtikelSuche", array($search, $assortment_r));
    }

    public function getArticleInfo($version_r, $article_r, $country_r, $publisher_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".ArtikelInfo", array($version_r, $article_r, $country_r, $publisher_r));
    }

    public function getDefaultPrice($version_r, $article_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".ArtikelPreis", array($version_r, $article_r));
    }

    public function getSpecialPrice($version_r, $article_r, $person_r = 0) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".ArtikelRabattPreis", array($version_r, $article_r, $person_r));
    }

    public function getPrice($version_r, $article_r, $person_r = 0) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Preis", array($version_r, $article_r, $person_r));
    }

    public function getDiscount($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Rabatt", array($person_r));
    }

    public function getAvailability($version_r, $article_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".ArtikelVersendetag", array($version_r, $article_r));
    }

    public function getDeliveryPrice($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Versandkosten", array($person_r));
    }

    public function getAccountInfo($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".KontoInfo", array($person_r));
    }

    public function getPublisher($country_r, $publisher_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Verlag", array($country_r, $publisher_r));
    }

    public function execOrder($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Bestellen", array($person_r));
    }

    public function execAccounting($bill_r, $person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Buchen", array($bill_r, $person_r));
    }

    public function newPerson() {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".PersonNeu", array());
    }

    public function getPlace($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Ort", array($person_r));
    }

    public function orderMiniscore($person_r, $article_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".Miniscore", array($person_r, $article_r));
    }

    public function sendUserData($person_r) {
        global $xmlrpc;
        return $xmlrpc->sendRequest(TWEBSHOP_NAMESPACE . ".LoginInfo", array($person_r));
    }

    static public function getHTMLColor($dec) {
        return sprintf("%06X", $dec);
    }

    static public function processText($text) {
        $lines = preg_split("/(\r*\n+)+/", $text);
        for ($i = 0; $i < count($lines); $i++) {
            $lines[$i] = (substr($lines[$i], 0, 1) != "@") ? htmlentities($lines[$i]) : substr($lines[$i], 1);
        }
        return implode("\r\n", $lines);
    }

    public function __wakeup() {
        trigger_error("someone try to create " . self::CLASS_NAME . " from session", E_USER_NOTICE);
    }

}

class torgamon_event {

    static private $properties = array("ART", "INFO", "PERSON_R", "AUFTRITT");
    private $rid = 0;

    const eT_BestellungNunVollstaendigLieferbar = 1;
    const eT_BestellungNunTeilweiseLieferbar = 2;
    const eT_BestellungMerkmalTeilweiseLieferbarVerloren = 3;
    const eT_WareEingetroffen = 4;
    const eT_LagerPlatzZugeteilt = 5;
    const eT_LagerPlatzFreigabe = 6;
    const eT_BelegScan = 7;
    const eT_Miniscore = 8; // wird vom WebShop erzeugt!
    const eT_WareRausgegangen = 9;
    const eT_WareBestellt = 10;
    const eT_ZahlungPerLastschrift = 11;
    const eT_ForderungsAusgleich = 12;
    const eT_KatalogVersendung = 13; // macht Alexander selbst
    const eT_PaketIDErhalten = 14; // Es war möglich eine Versand-ID zuzuteilen
    const eT_OrgaTix = 15; // Ticket im Support-System
    const eT_Umsatzabruf = 16; // Es wurde ein Umsatz abgerufen (Online-Banking)
    const eT_Kasse = 17; // Eine Kasse lieferte uns einen Kassenzettel
    const eT_Newsletter = 18; // Der Webshop hat einen Newsletter erzeugt
    const eT_SaldoAbruf = 19; // Es wurde ein Saldo abgerufen (Online-Banking)
    const eT_BenutzerTextUpload = 20; //Benutzer/Kunde hat Text (und Bilder) hochgeladen (für Die Blasmusik)
    const eT_WebShopBestellung = 21; // Es wurden Probleme bei der Webshopbestelltung bemerkt
    const CLASS_NAME = "PHP5CLASS T_ORGAMON_EVENT";

    public function __construct($rid = 0) {
        $this->rid = intval($rid);
        $this->getProperties();
        if ($rid == 0) {
            $this->ART = NULL;
            $this->PERSON_R = NULL;
            $this->INFO = NULL;
        }
    }

    public function getProperties() {

        global $ibase;
        if ($this->rid != NULL) {

            $sql = "SELECT " . implode(",", self::$properties) . " FROM EREIGNIS WHERE RID={$this->rid}";
            $result = $ibase->query($sql);
            $data = $ibase->fetch_object($result);
            $ibase->free_result();
            foreach (self::$properties as $name) {
                $this->{$name} = (is_int($data->{$name})) ? $data->{$name} : trim($data->{$name});
            }
        }
    }

    public function getID() {
        return intval($this->rid);
    }

    public function setType($type) {
        $this->ART = intval($type);
    }

    public function setInfo($info) {
        $this->INFO = strval($info);
    }

    public function getInfo() {
        global $ibase;
        $info = $this->INFO;
        if (tibase::is_blob_resource($this->INFO)) {
            $info = $ibase->get_blob($this->INFO, 4096);
        }
        return ($info != NULL) ? $info : "";
    }

    public function setPerson($person_r) {
        $this->PERSON_R = intval($person_r);
    }

    public function insertIntoDataBase() {
        global $ibase;
        $result = false;

        $this->rid = $ibase->gen_id("EREIGNIS_GID");
        $sql = "INSERT INTO EREIGNIS (RID,ART,AUFTRITT,PERSON_R,INFO) VALUES (" .
                tibase::format_for_insert($this->rid) . "," .
                tibase::format_for_insert($this->ART) . "," .
                "CURRENT_TIMESTAMP," .
                tibase::format_for_insert($this->PERSON_R) . "," .
                tibase::format_for_insert($this->INFO) . ")";
        //echo $sql;
        if ($ibase->exec($sql)) {
            $result = $this->rid;
        }

        return $result;
    }

}

?>
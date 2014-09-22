<?php

//**** KLASSE ZUR ABBILDUNG DER PERSON ****************************************************************************************
class twebshop_person extends tvisual {

    static public $properties = array("NUMMER", "ANREDE", "VORNAME", "NACHNAME", "PRIV_ANSCHRIFT_R", "GESCH_ANSCHRIFT_R", "EMAIL", "USER_ID", "GEBURTSTAG", "RABATT_CODE",
        "WEBSHOP_VERSANDART", "WEBSHOP_TEILLIEFERUNGEN", "WEBSHOP_TREFFERPROSEITE", "WEBSHOP_RABATT", "USER_DIENSTE", "PRIV_TEL", "PRIV_FAX");
    protected $rid = 0;
    public $address = NULL;
    public $user_dienste = NULL;
    protected $emails = array();

    const TABLE = TABLE_PERSON;
    const CLASS_NAME = "PHP5CLASS TWEBSHOP_PERSON";

    public function __construct($rid = 0, $firstname = "", $surname = "", $user_id = "", $email = "", $phone = "", $fax = "") {
        $this->rid = intval($rid);
        $this->getProperties();
        if ($rid == 0) {
            $this->VORNAME = $firstname;
            $this->NACHNAME = $surname;
            $this->USER_ID = $user_id;
            $this->EMAIL = ($email == "" AND $user_id != "") ? $user_id : $email;
            $this->setPhone($phone);
            $this->setFax($fax);
        }
    }

    public function getProperties() {

        global $ibase;
        if ($this->rid != 0) { // EIGENSCHAFTEN AUS DATENBANK LESEN
           
            $sql = "SELECT " . implode(",", twebshop_person::$properties) . " FROM " . self::TABLE . " WHERE RID=" . $this->rid;
            //echo $sql;
            $result = $ibase->query($sql);
            $data = $ibase->fetch_object($result);
           
            foreach (twebshop_person::$properties as $name) { //$this->{$name} = trim($data->{$name});
                $this->{$name} = (empty($data->{$name}) AND defined("TWEBSHOP_PERSON_DEFAULT_" . $name)) ? constant("TWEBSHOP_PERSON_DEFAULT_" . $name) : trim($data->{$name});
                //Alternative: OrgaMon füllt die Felder mit Standardwerten bei der Neuanlage
            }
            
            $this->user_dienste = new tstringlist($ibase->get_blob($this->USER_DIENSTE));
            $ibase->free_result();

            
        } else { // EIGENSCHAFTEN VON DEN KONSTANTEN ÜBERNEHMEN             
            foreach (twebshop_person::$properties as $name) {
                $this->{$name} = (defined("TWEBSHOP_PERSON_DEFAULT_" . $name)) ? constant("TWEBSHOP_PERSON_DEFAULT_" . $name) : "";
            }
        }
    }

    public function getName() {
        return $this->VORNAME . " " . $this->NACHNAME;
    }

    public function isUser() {
        return ($this->USER_ID != "") ? true : false;
    }

    public function isInDataBase() {
        return self::isPersonInDataBase($this);
    }

    public function setID($rid) {
        $this->rid = intval($rid);
        return $this->rid;
    }

    public function getID() {
        return $this->rid;
    }

    public function getIDasHash() {
        return md5($this->rid);
    }

    public function setPhone($phone) {
        $this->PRIV_TEL = $phone;
    }

    public function setFax($fax) {
        $this->PRIV_FAX = $fax;
    }

    public function getAddress() {
        if ($this->rid != 0) {
            $this->address = new twebshop_address(intval($this->PRIV_ANSCHRIFT_R));
            $this->address->setPerson($this->rid);
        }
        return $this->address;
    }

    public function getAddressFormatAsHTMLTemplate($option = true) {
        if ($this->address == NULL) {
            $this->getAddress();
        }
        $country = new twebshop_country($this->address->LAND_R, $this->address->LAND_R);
        return twebshop_address::convertCountryFormatToTemplate($country->ORT_FORMAT, $country->ISO_KURZZEICHEN, $option);
    }

    public function geteMails() {
        if (count($this->emails) == 0) {
            $this->emails = explode(";", str_replace(" ", "", trim_char(strtolower($this->EMAIL), ";")));
        }
        return $this->emails;
    }

    public function seteMails($emails) {
        $this->emails = $emails;
    }

    public function addeMail($email) {
        if ($email != "") {
            $email = strtolower($email);
            $this->geteMails();
            if (!in_array($email, $this->emails)) {
                $this->emails[] = $email;
                $this->EMAIL = implode(";", $this->emails);
            }
        }
        return $this->emails;
    }

    /* --> 22.08.2014 michaelhacksoftware : Namen der Person für die URL aufbereiten */
    public function UrlEncodeName($Name) {

        $Name = strtolower(trim($Name));

        $Name = str_replace(" ",  "_", $Name);
        $Name = str_replace("\"",  "", $Name);
        $Name = str_replace("'",   "", $Name);
        $Name = str_replace("?",   "", $Name);
        $Name = str_replace("&",  "+", $Name);
        $Name = str_replace("/",  "_", $Name);
        $Name = str_replace("\\", "_", $Name);

        $Name = urlencode($Name);

        return $Name;

    }
    /* <-- */

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~ADDRESS~", ($this->address != NULL) ? $this->address->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = str_replace("~EMAIL~", $this->EMAIL, $template);
        $template = str_replace("~EMAILS~", implode(", ", $this->geteMails()), $template);
        $template = str_replace("~NACHNAME~", $this->NACHNAME, $template);
        $template = str_replace("~NUMMER~", $this->NUMMER, $template);
        $template = str_replace("~PRIV_FAX~", $this->PRIV_FAX, $template);
        $template = str_replace("~PRIV_TEL~", $this->PRIV_TEL, $template);
        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~VORNAME~", $this->VORNAME, $template);
        $template = str_replace("~USER_ID~", $this->USER_ID, $template);

        return $template;
    }

    public function updateInDataBase() {

        global $ibase;
        $result = false;
        if ($this->rid != 0) {
           
            $sql = "UPDATE " . self::TABLE . " SET VORNAME='{$this->VORNAME}',NACHNAME='{$this->NACHNAME}',EMAIL='" . implode("; ", $this->geteMails()) . "',USER_ID='{$this->USER_ID}',PRIV_TEL='{$this->PRIV_TEL}',PRIV_FAX='{$this->PRIV_FAX}' WHERE RID={$this->rid}";
            // echo $sql;
            $result = $ibase->exec($sql);
            
        }
        return ($result) ? true : false;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

    static public function isPersonInDataBase($person) {
       

        global $ibase;
        if ($person->VORNAME == "" AND $person->NACHNAME == "") {
            $sql = "SELECT COUNT(RID) FROM PERSON WHERE (USER_ID='{$person->USER_ID}')";
        } else {
            $sql = "SELECT COUNT(RID) FROM PERSON WHERE ((VORNAME='{$person->VORNAME}' AND NACHNAME='{$person->NACHNAME}') OR (USER_ID='{$person->USER_ID}'))";
        }
        $count = $ibase->get_field($sql, "COUNT");
        
        return ($count == 0) ? false : true;
    }

    static public function doeseMailExist($email) {
       

        global $ibase;
        $sql = "SELECT RID FROM " . self::TABLE . " WHERE (LOWER(EMAIL) CONTAINING LOWER('$email'))";
        $result = $ibase->get_field($sql);
        $result = ($result == false) ? 0 : $result;
        
        return $result;
    }

}
?>
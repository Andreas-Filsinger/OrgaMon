<?php

//**** KLASSE ZUR ABBILDUNG DES USERS ****************************************************************************************

class twebshop_user extends twebshop_person {

    static private $instance = NULL;
    protected $logged_in = false;
    protected $services = NULL;
    protected $bills = array();
    protected $payment_infos = array();
    protected $mymusic = NULL;

    const CLASS_NAME = "PHP5CLASS TWEBSHOP_USER";

    public function __construct($rid = 0) {

        parent::__construct($rid);
    }

    static public function create($rid = 0) {

        if (!self::$instance) {
            self::$instance = new twebshop_user($rid);
        }
        return self::$instance;
    }

    static public function free() {
        self::$instance = NULL;
    }

    public function logIn($user_id, $user_pw) {

        global $ibase;
        global $orgamon;
        $this->logged_in = false;
        if ($user_id != "" AND $user_pw != "") {

            $ibase->query("select USER_PWD,USER_SALT,USER_HASH,RID from PERSON where USER_ID='$user_id'");
            while ($data = $ibase->fetch_object()) {

                // Werte aus der Datenbank lesen
                $rid = $data->{"RID"};
                $hash = $data->{"USER_HASH"}; //  Grundlage der Authentifikation
                $salt = $data->{"USER_SALT"}; // kann null sein, wird dann gesetzt
                $pwd = $data->{"USER_PWD"}; // sollte null sein, wird bei erster Korrektheit gelöscht
                // Ist USER_SALT noch ungesetzt?
                if ($salt == "") {
                    // Benutze als Salt den XMLRPC Kontext, er ist zufällig
                    $salt = $orgamon->getSystemString(torgamon::BASEPLUG_CONTEXT);
                    $ibase->exec("update PERSON set USER_SALT='$salt' where RID=$rid");
                }

                // Hash berechnen, SHA256
                $r = explode("$", crypt($user_pw, "$5$" . $salt . "$"));
                $user_hash = $r[3];

                // Ups, das Passwort ist noch im Klartext? 
                if ($pwd === $user_pw) {
                    // Migration auf den korrekten Hash
                    $hash = $user_hash;
                    $ibase->exec("update PERSON set USER_HASH='$hash',USER_PWD=null where RID=$rid");
                }

                // "aktueller Hash"="Hash in der Datenbank"?
                if ($hash === $user_hash) {
                    // Authentifiziert!!
                    $this->rid = $rid;
                    $this->getProperties();
                    $this->getAddress();
                    $this->logged_in = true;
                    break;
                }
            }
            $ibase->free_result();
        }
        return $this->logged_in;
    }

    public function logOut() {
        $this->logged_in = false;
        $this->rid = 0;
    }

    public function loggedIn() {
        return $this->logged_in;
    }

    public function getBills($force_rescan = false) {

        global $ibase;
        if ($this->getID() != 0) {
            if ((count($this->bills) == 0) OR $force_rescan) {

                $this->bills = array();

                $ibase->query(
                        "select BELEG_R,TEILLIEFERUNG from " .
                        "AUSGANGSRECHNUNG where " .
                        " (KUNDE_R={$this->getID()}) and " .
                        " (VORGANG='RECHNUNG (73)') and " .
                        " (DATUM>CURRENT_DATE-1095) and " .
                        " (BELEG_R > 0) and " .
                        " (TEILLIEFERUNG >= 0) " .
                        "order by" .
                        " RECHNUNG DESC"
                );
                while ($data = $ibase->fetch_object()) {

                    $this->bills[] = new twebshop_bill($data->{"BELEG_R"}, $data->{"TEILLIEFERUNG"});
                    fb($data->{"BELEG_R"} . "-" . $data->{"TEILLIEFERUNG"}, "B#-TL", FirePHP::INFO);
                    unset($data);
                }
                $ibase->free_result();
            }
        }
        fb(count($this->bills),"Anzahl",FirePHP::INFO);
        return $this->bills;
    }

    public function getPaymentInfos($force_rescan = false) {

        global $ibase;
        if ($this->getID() != 0) {
            if ((count($this->payment_infos) == 0) OR $force_rescan) {
                $this->payment_infos = array();


                $ids = $ibase->get_list_as_array("SELECT DISTINCT ZAHLUNGSPFLICHTIGER_R AS ID FROM BELEG WHERE (PERSON_R={$this->getID()}) AND (ZAHLUNGSPFLICHTIGER_R IS NOT NULL)", "RID");
                foreach ($ids as $id) {
                    $this->payment_infos[] = new twebshop_payment_info($id);
                    unset($id);
                }
                unset($ids);
            }
        }
        return $this->payment_infos;
    }

    public function getMyMusic($force_rescan = false) {
        if ($this->getID() != 0) {
            if (($this->mymusic == NULL) OR $force_rescan) {
                $this->mymusic = new twebshop_mymusic($this->getID());
            }
        }
        return $this->mymusic;
    }

    public function getsDiscount() {
        return ($this->RABATT_CODE == NULL) ? false : true;
    }

    public function showDiscount() {
        return ($this->getsDiscount() AND $this->getSettingShowDiscount());
    }

    public function getMonitionDocument($path) {
        return $path . sprintf("%010d", $this->rid) . "/Mahnung";
    }

    public function getBudgetDocument($path) {
        return $path . sprintf("%010d", $this->rid) . "/Arbeitszeit";
    }

    public function getSettingHitsPerPage() {
        return $this->WEBSHOP_TREFFERPROSEITE;
    }

    public function setSettingHitsPerPage($value) {

        global $ibase;
        if ($value != $this->WEBSHOP_TREFFERPROSEITE) {

            $sql = "UPDATE " . self::TABLE . " SET WEBSHOP_TREFFERPROSEITE=$value WHERE RID={$this->rid}";
            $result = $ibase->exec($sql);

            $this->WEBSHOP_TREFFERPROSEITE = $value;
        }
    }

    public function getSettingShowDiscount() {
        return ($this->WEBSHOP_RABATT == "Y") ? true : false;
    }

    public function setSettingShowDiscount($value) {

        global $ibase;
        if ($value != $this->WEBSHOP_RABATT) {

            $sql = "UPDATE " . self::TABLE . " SET WEBSHOP_RABATT='$value' WHERE RID={$this->rid}";
            $result = $ibase->exec($sql);

            $this->WEBSHOP_RABATT = $value;
        }
    }

    public function isService($service) {

        if ($this->loggedIn()) {
            $result = ($this->user_dienste->getValueByName($service) == "JA") ? true : false;
        } else {
            $result = false;
        }
        //var_dump($result);
        return $result;
    }

    public function sendPassword() {
        return self::sendUserPassword($this->rid);
    }

    public function setPassword($password) {

        global $ibase;
        return ($ibase->exec("UPDATE " . self::TABLE . " SET USER_PWD='$password' WHERE RID=" . $this->rid));
    }

    public function getUserID() {

        return $this->USER_ID;
    }

    public function setUserID($user_id) {
        $this->USER_ID = $user_id;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $bills = "";
        if (strpos($template, "~BILLS~") !== false) {
            foreach ($this->bills as $bill) {
                $bills.= $bill->getFromHTMLTemplate($this->_ttemplate);
                unset($bill);
            }
        }

        $template = str_replace("~BILLS~", $bills, $template);

        unset($bills);
        return $template;
    }

    static public function getRIDByUserID($user_id) {


        global $ibase;
        $sql = "SELECT RID FROM " . self::TABLE . " WHERE UPPER(USER_ID)='" . strtoupper($user_id) . "'";
        $rid = $ibase->get_field($sql);
        return $rid;
    }

    static public function existsUserID($user_id) {

        global $ibase;
        if (!empty($user_id)) {

            $sql = "SELECT COUNT(RID) FROM " . self::TABLE . " WHERE UPPER(USER_ID)='" . strtoupper($user_id) . "'";
            $count = $ibase->get_field($sql, "COUNT");

            return ($count == 0) ? false : $count;
        }
        else
            return false;
    }

    static public function createUserPassword() {
        $password = "";
        for ($i = 0; $i < (PASSWORD_DEFAULT_LENGTH - strlen(PASSWORD_DEFAULT_PREFIX) - strlen(PASSWORD_DEFAULT_POSTFIX)); $i++) {
            $password.= mt_rand(0, 9);
        }
        $password = PASSWORD_DEFAULT_PREFIX . $password . PASSWORD_DEFAULT_POSTFIX;
        return $password;
    }

    static public function sendUserPassword($rid) {

        global $orgamon;
        $result = $orgamon->sendUserData($rid);
        return $result;
    }

    static public function registerUser($number, $name, $zip, $user) {

        global $ibase;
        global $errorlist;
        $result = false;

        if (!check_numeric($number)) {
            $errorlist->add("Die Kundennummer sollte nur aus Ziffern bestehen, es wurde unerlaubte Sonderzeichen oder Buchstaben erkannt!");
            return false;
        } else {
            $rid = $ibase->get_field("SELECT RID FROM PERSON WHERE KONTO_AR=" . $number);
        }

        if ($rid > 0) {
            $person = new twebshop_user($rid);
            $person->getAddress();
            if ((($name == $person->NACHNAME) OR ($name == $person->address->NAME1) OR ($name == $person->address->NAME2)) AND ($zip == $person->address->PLZ)) {
                $result = true;
                $person->addEMail($user);
                $person->USER_ID = $user;
                $sql = "UPDATE " . self::TABLE . " SET EMAIL='" . implode("; ", $person->getEMails()) . "',USER_ID='{$person->USER_ID}' WHERE RID=$rid";
                $ibase->exec($sql);
                $person->sendPassword();
            }
            unset($person);
        }

        return ($rid AND $result) ? $rid : false;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

    public function __wakeup() {
        self::$instance = $this;
    }

}
?>
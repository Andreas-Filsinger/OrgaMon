<?php

class twebshop_bill extends tvisual {

    static public $properties = array("DAVON_BEZAHLT", "PERSON_R", "RECHNUNGS_BETRAG", "MOTIVATION", "ZAHLUNGSPFLICHTIGER_R", "ZAHLUNGTYP_R", "TERMIN", "RECHNUNGSNUMMER", "BELEG_R", "TEILLIEFERUNG", "LIEFERANSCHRIFT_R", "RECHNUNGSANSCHRIFT_R", "RECHNUNG");
    static public $properties1 = array("DAVON_BEZAHLT", "PERSON_R", "RECHNUNGS_BETRAG", "MOTIVATION", "ZAHLUNGSPFLICHTIGER_R", "ZAHLUNGTYP_R", "TERMIN");
    private $rid = 0;
    private $part = 0;

    protected $delivery_type = NULL;
    static private $path = "";
    private $document = "";

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_BILL";


    public function __construct($rid = 0, $part = 0) {
        $this->rid = $rid;
        $this->part = $part;
        $this->getProperties();
    }

    public function getProperties() {

        global $ibase;
        if ($this->rid != 0) {

            $sql = "SELECT " . 
                    
                    // Standard-PROPERTIES 
                    implode(",", self::$properties1) .

                    // +BELEG_R             
                    ", BELEG.RID as BELEG_R " .

                    // +RECHNUNG
                    ", BELEG.RECHNUNG " .

                    // +TEILLIEFERUNG
                    ", VERSAND.TEILLIEFERUNG " .

                    // +LIEFERANSCHRIFT_R
                    ", VERSAND.LIEFERANSCHRIFT_R " .
                    
                    // +RECHNUNGSANSCHRIFT_R
                    ", VERSAND.RECHNUNGSANSCHRIFT_R " .

                    // +RECHNUNGSNUMMER
                    ", VERSAND.RECHNUNG as RECHNUNGSNUMMER " .
                    
                    "from BELEG " .
                    "join VERSAND on " .
                    " (VERSAND.BELEG_R=BELEG.RID) and ".
                    " (VERSAND.TEILLIEFERUNG=" . $this->part . ") " . 
                    " where " .
                    " (BELEG.RID=" . $this->rid . ")";
            
            $result = $ibase->query($sql);
            $data = $ibase->fetch_object($result);
            $ibase->free_result();

            foreach (self::$properties as $name) {
                if (isset($data->{$name})) {
                $this->{$name} = trim($data->{$name});
                } else
                {
                    $this->{$name} = "";
                }
            }
        }
    }

    public function setBillContact($person_r) {
        $this->RECHNUNGSANSCHRIFT_R = ($this->PERSON_R == $person_r) ? "NULL" : $person_r;
        return $this->RECHNUNGSANSCHRIFT_R;
    }

    public function setDeliveryContact($person_r) {
        $this->LIEFERANSCHRIFT_R = ($this->PERSON_R == $person_r) ? "NULL" : $person_r;
        return $this->LIEFERANSCHRIFT_R;
    }

    public function setPayer($person_r) {
        $this->ZAHLUNGSPFLICHTIGER_R = ($this->PERSON_R == $person_r) ? "NULL" : $person_r;
        return $this->ZAHLUNGSPFLICHTIGER_R;
    }

    public function setModeOfPayment($mode) {
        $this->ZAHLUNGTYP_R = $mode;
    }

    public function setDate($timestamp) {
        $this->TERMIN = date("d.m.Y", $timestamp);
    }

    public function setDeliveryType($type = twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED) {
        if ($this->delivery_type == NULL) {
            $this->delivery_type = new twebshop_bill_delivery_type($this->rid, $type);
        }
        else
            $this->delivery_type->setType($type);
        $this->KUNDEN_INFO = $this->delivery_type->getString();
    }


    public function getDocument($path = "") {
        self::$path = ($path != "") ? $path : self::$path;
        $this->document = self::$path . sprintf("%010d", $this->PERSON_R) . "/" . sprintf("%010d", $this->BELEG_R) . "-" . sprintf("%02d", $this->TEILLIEFERUNG);
        return $this->document;
    }

    public function getTimecard($path = "") {
        self::$path = ($path != "") ? $path : self::$path;
        $this->document = self::$path . sprintf("%010d", $this->PERSON_R) . "/" . sprintf("%010d", $this->BELEG_R) . "-" . sprintf("%02d", $this->TEILLIEFERUNG) . ".Arbeitszeit";
        return $this->document;
    }

    public function getEvent($type) {
        
        global $ibase;
        $result = NULL;

        
        $id = $ibase->get_field("SELECT RID FROM EREIGNIS WHERE (BELEG_R={$this->rid}) AND (ART = $type)");

        if ($id !== false) {
            $result = new torgamon_event($id);
        }
        return $result;
    }
    
    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $cryption = tcryption::create();
        $template = str_replace("~NUMBER~", self::formatBillNumber($this->BELEG_R, $this->TEILLIEFERUNG), $template);
        $template = str_replace("~RID~", $this->BELEG_R, $template);
        $template = str_replace("~TEILLIEFERUNG~", $this->TEILLIEFERUNG, $template);
        $template = str_replace("~AMOUNT~", twebshop_price::toCurrency($this->RECHNUNGS_BETRAG), $template);
        $template = str_replace("~DATE~", tibase::date($this->RECHNUNG,"."), $template);
        $template = str_replace("~TIME~", tibase::time($this->RECHNUNG), $template);
        $template = str_replace("~DAVON_BEZAHLT~", $this->DAVON_BEZAHLT, $template);

        $template = str_replace("~DOCUMENT~", $this->getDocument(), $template);
        $template = str_replace("~ENCRYPTED_DOCUMENT~", $cryption->encrypt($this->getDocument()), $template);
        $template = str_replace("~ENCRYPTED_TIMECARD~", $cryption->encrypt($this->getTimecard()), $template);

        $template = str_replace("~PAID~", twebshop_price::toCurrency($this->DAVON_BEZAHLT), $template);
        $template = str_replace("~RECHNUNG~", $this->RECHNUNG, $template);
        $template = str_replace("~RECHNUNGS_BETRAG~", $this->RECHNUNGS_BETRAG, $template);
        $template = str_replace("~TERMIN~", $this->TERMIN, $template);
        $template = str_replace("~TOPAY~", twebshop_price::toCurrency(doubleval($this->RECHNUNGS_BETRAG) - doubleval($this->DAVON_BEZAHLT)), $template);
        $template = str_replace("~RECHNUNGSNUMMER~", $this->RECHNUNGSNUMMER, $template);
        $template = str_replace("~ZAHLUNGSPFLICHTIGER_R~", $this->ZAHLUNGSPFLICHTIGER_R, $template);
        $template = str_replace("~ZAHLUNGTYP_R~", $this->ZAHLUNGTYP_R, $template);

        unset($cryption);
        return $template;
    }

    public function updateInDataBase() {
        
        global $ibase;
        $result = false;
        if ($this->rid != 0) {

            $sql = "UPDATE BELEG SET LIEFERANSCHRIFT_R=" .
                    tibase::null2str($this->LIEFERANSCHRIFT_R) . ", 
	                                         RECHNUNGSANSCHRIFT_R=" .
                    tibase::null2str($this->RECHNUNGSANSCHRIFT_R) . ", 
		ZAHLUNGSPFLICHTIGER_R=" . tibase::null2str($this->ZAHLUNGSPFLICHTIGER_R) . ",
		ZAHLUNGTYP_R=" . tibase::null2str($this->ZAHLUNGTYP_R) . ", 
		TERMIN=" . tibase::format_for_insert($this->TERMIN, false, true) . ",
		KUNDEN_INFO=" . tibase::format_for_insert($this->KUNDEN_INFO, false, true) . "
WHERE RID={$this->rid}";
            //trigger_error($sql, E_USER_NOTICE);
            $result = $ibase->exec($sql);
            unset($sql);
            
        }
        return $result;
    }

    static public function formatBillNumber($rid, $part) {
        return sprintf("%05d", $rid) . "-" . sprintf("%02d", $part);
        ;
    }

    static public function setPath($path) {
        self::$path = $path;
    }

    static public function getFormerBillContacts($person_r) {
        
        global $ibase;
        $contacts = array();
        
        $ids = $ibase->get_list_as_array("SELECT DISTINCT RECHNUNGSANSCHRIFT_R RID FROM BELEG WHERE (PERSON_R=$person_r) AND (RECHNUNGSANSCHRIFT_R IS NOT NULL) AND (RECHNUNGSANSCHRIFT_R!=$person_r)");
        foreach ($ids as $id) {
            $contacts[] = new twebshop_person($id);
            end($contacts)->getAddress();
            unset($id);
        }
        unset($ids);
        
        return $contacts;
    }

    static public function getFormerDeliveryContacts($person_r) {
        
        global $ibase;
        $contacts = array();
        
        $ids = $ibase->get_list_as_array("SELECT DISTINCT LIEFERANSCHRIFT_R RID FROM BELEG WHERE (PERSON_R=$person_r) AND (LIEFERANSCHRIFT_R IS NOT NULL) AND (LIEFERANSCHRIFT_R!=$person_r)");
        foreach ($ids as $id) {
            $contacts[] = new twebshop_person($id);
            end($contacts)->getAddress();
            unset($id);
        }
        unset($ids);
        
        return $contacts;
    }

}

class twebshop_bill_delivery_type extends tvisual {

    protected $beleg_r = 0;
    protected $type = -1;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_BILL_DELIVERY_TYPE";
    const TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED = -1;
    const TWEBSHOP_BILL_DELIVERY_TYPE_WITH_SHIPPING = 0;
    const TWEBSHOP_BILL_DELIVERY_TYPE_SEND_SEPARATELY = 1;

    static protected $sys_strings = array(
        twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED => "",
        twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_WITH_SHIPPING => SYS_SENTENCE_BILL_DELIVERY_WITH_SHIPPING,
        twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_SEND_SEPARATELY => SYS_SENTENCE_BILL_DELIVERY_BILL_SEPARATELY
    );

    public function __construct($beleg_r, $type = twebshop_bill_delivery::TWEBSHOP_BILL_DELIVERY_NOT_DEFINED) {
        $this->beleg_r = $beleg_r;
        $this->setType($type);
    }

    public function setType($type) {
        $this->type = $type;
    }

    public function getType() {
        return $this->type;
    }

    public function getString() {
        return twebshop_bill_delivery_type::$sys_strings[$this->type];
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~BELEG_R~", $this->beleg_r, $template);
        $template = str_replace("~TYPE~", $this->type, $template);
        $template = str_replace("~STRING~", twebshop_bill_delivery_type::$sys_strings[$this->type], $template);

        return $template;
    }

}
?>
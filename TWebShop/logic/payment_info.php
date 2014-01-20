<?php

class twebshop_payment_info extends tvisual {

    static public $properties = array("Z_ELV_KONTO_INHABER", "Z_ELV_BANK_NAME", "Z_ELV_BLZ", "Z_ELV_KONTO");
    private $rid = 0;
    private $type = 0;

    const PAYMENT_INFO_TYPE_AMERICAN_EXPRESS = PAYMENT_AMERICAN_EXPRESS;
    const PAYMENT_INFO_TYPE_CLICKNBUY = PAYMENT_CLICKNBUY;
    const PAYMENT_INFO_TYPE_DIRECT_DEBITING = PAYMENT_DIRECT_DEBITING;
    const PAYMENT_INFO_TYPE_MASTERCARD = PAYMENT_MASTERCARD;
    const PAYMENT_INFO_TYPE_PAYPAL = PAYMENT_PAYPAL;
    const PAYMENT_INFO_TYPE_VISACARD = PAYMENT_VISACARD;
    const TABLE = TABLE_PAYMENT_INFO;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_PAYMENT_INFO";

    public function __construct($rid = 0, $type = 0, $depositor = "", $bank = "", $ban = "", $bic = "") {
        if ($rid != 0) {
            $this->rid = $rid;
            $this->getProperties();
            $this->setType($this->identifyType());
        } else {
            $this->setDepositor($depositor);
            $this->setBank($bank);
            $this->setBAN($ban);
            $this->setBIC($bic);
            $this->setType($type);
        }
    }

    public function getProperties() {

        global $ibase;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}"; // " LIMIT 1"; // nur 1 Datensatz
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = trim($data->{$name});
        }
    }

    public function setID($rid) {
        $this->rid = intval($rid);
        return $this->rid;
    }

    public function getID() {
        return $this->rid;
    }

    public function setDepositor($depositor) {
        $this->Z_ELV_KONTO_INHABER = $depositor;
    }

    public function getDepositor() {
        return $this->Z_ELV_KONTO_INHABER;
    }

    public function setBank($bank) {
        $this->Z_ELV_BANK_NAME = $bank;
    }

    public function getBank() {
        return $this->Z_ELV_BANK_NAME;
    }

    public function setBAN($ban) {
        $this->Z_ELV_KONTO = $ban;
    }

    public function getBAN() {
        return $this->Z_ELV_KONTO;
    }

    public function getMaskedBAN() {
        return self::buildMaskedBAN($this->getBAN());
    }

    public function setBIC($bic) {
        $this->Z_ELV_BLZ = $bic;
    }

    public function getBIC() {
        return $this->Z_ELV_BLZ;
    }

    public function setType($type) {
        $this->type = $type;
    }

    public function getType() {
        return $this->type;
    }

    private function identifyType() {
        $type = 0;
        if (!empty($this->Z_ELV_KONTO_INHABER) AND !empty($this->Z_ELV_KONTO) AND !empty($this->Z_ELV_BANK_NAME) AND !empty($this->Z_ELV_BLZ)) {
            $type = self::PAYMENT_INFO_TYPE_DIRECT_DEBITING;
        }
        return $type;
    }

    public function updateInDataBase() {

        global $ibase;
        $result = false;
        if ($this->rid != 0) {
            $sql = "UPDATE " . self::TABLE . " SET " .
                    "Z_ELV_KONTO_INHABER='{$this->Z_ELV_KONTO_INHABER}',Z_ELV_BANK_NAME='{$this->Z_ELV_BANK_NAME}',Z_ELV_KONTO='{$this->Z_ELV_KONTO}',Z_ELV_BLZ='{$this->Z_ELV_BLZ}'" .
                    "WHERE RID={$this->rid}";
            $result = $ibase->exec($sql);
            
        }
        return ($result) ? true : false;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~BAN~", $this->Z_ELV_KONTO, $template);
        $template = str_replace("~BAN_MASKED~", $this->getMaskedBAN(), $template);
        $template = str_replace("~BANK~", $this->Z_ELV_BANK_NAME, $template);
        $template = str_replace("~BIC~", $this->Z_ELV_BLZ, $template);
        $template = str_replace("~DEPOSITOR~", $this->Z_ELV_KONTO_INHABER, $template);
        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~TYPE~", $this->type, $template);

        return $template;
    }

    static public function buildMaskedBAN($ban) {
        $ban = strval($ban);
        $length_unmasked = 3; // relativ: floor(strlen($ban) / 2);
        $length_masked = strlen($ban) - $length_unmasked;
        return sprintf("%'*{$length_masked}s", "") . substr($ban, -$length_unmasked);
    }

}
?>
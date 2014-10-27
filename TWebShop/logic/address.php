<?php

class twebshop_address extends tvisual {

    static public $properties = array("LAND_R", "PLZ", "STATE", "ORT", "STRASSE", "NAME1", "NAME2", "ORTSTEIL");
    private $rid = 0;
    private $person_r = 0;

    const TABLE = TABLE_ADDRESS;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ADDRESS";


    public function __construct($rid = 0, $country_r = 0, $street = "", $zip = "", $city = "", $state = "", $name1 = "", $name2 = "") {

        if ($rid != 0) {
            $this->rid = $rid;
            $this->getProperties();
        } else {
            $this->setCountry($country_r);
            $this->setStreet($street);
            $this->setZIP($zip);
            $this->setCity($city);
            $this->setState($state);
            $this->setName1($name1);
            $this->setName2($name2);
        }
    }

    public function getProperties() {

        global $ibase;

        $sql = "SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}";
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

    public function setPerson($person_r = 0) {
        $this->person_r = $person_r;
    }

    public function setCountry($country_r) {
        $this->LAND_R = $country_r;
        return $this->LAND_R;
    }

    public function setStreet($street) {
        $this->STRASSE = $street;
        return $this->STRASSE;
    }

    public function setZIP($zip) {
        $this->PLZ = $zip;
        return $this->PLZ;
    }

    public function setCity($city) {
        $this->ORT = $city;
        return $this->ORT;
    }

    public function setState($state) {
        $this->STATE = $state;
        return $this->STATE;
    }

    public function getState($null = false) {
        return ($this->STATE == "" AND $null) ? "NULL" : $this->STATE;
    }

    public function setName1($name) {
        $this->NAME1 = $name;
        return $this->NAME1;
    }

    public function setName2($name) {
        $this->NAME2 = $name;
        return $this->NAME2;
    }

    public function updateInDataBase() {

        global $ibase;
        $result = false;
        if ($this->rid != 0) {
            $sql = "UPDATE " . self::TABLE . " SET " .
                    "LAND_R=$this->LAND_R,PLZ={$this->PLZ},STATE='{$this->getState(true)}',ORT='{$this->ORT}'," .
                    "STRASSE='{$this->STRASSE}',NAME1='{$this->NAME1}',NAME2='{$this->NAME2}' " .
                    "WHERE RID={$this->rid}";
            $result = $ibase->exec($sql);
        }
        return ($result) ? true : false;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~CITY~", $this->ORT, $template);
        $template = str_replace("~COUNTRY_R~", $this->LAND_R, $template);
        $template = str_replace("~NAME1~", $this->NAME1, $template);
        $template = str_replace("~NAME2~", $this->NAME2, $template);
        $template = str_replace("~STATE~", $this->STATE, $template);
        $template = str_replace("~STREET~", $this->STRASSE, $template);
        $template = str_replace("~ZIP~", $this->PLZ, $template);

        return $template;
    }

    static public function convertCountryFormatToTemplate($country_format, $iso_short, $option = true) {
        $prefix = ($option) ? "OPTION_" : "";
        if ($country_format != "") {
            $template = strip_tags($country_format);
            $template = str_replace("%l", $iso_short, $template);
            $template = str_replace("%s", "~$prefix" . "STATE~", $template);
            //TS 25-11-2011: ereg_replace ist deprecated 
            //$template = ereg_replace("%p[0-9]*","~$prefix"."ZIP~",$template);
            $template = preg_replace("/%p[0-9]*/", "~$prefix" . "ZIP~", $template);
            $template = str_replace("%o", "~$prefix" . "CITY~", $template);
            $template = str_replace("%c", "", $template);
            $template = str_replace("@", "", $template);
        } else {
            $template = "~$prefix" . "CITY~~$prefix" . "ZIP~~$prefix" . "STATE~";
        }
        return $template;
    }

}
?>
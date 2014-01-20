<?php

class twebshop_countries extends tvisual {

    private $rid = 0;
    public $list = array();
    public $count = 0;

    const TABLE = TABLE_COUNTRY;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_COUNTRIES";

    public function __construct($rid = 0) {
        $this->rid = $rid;
        if ($this->rid != 0) {
            $this->buildList();
        }
    }

    public function setUserCountry($short) {
        
        global $ibase;
        $this->rid = intval($ibase->get_field("SELECT RID FROM " . self::TABLE . " WHERE ISO_KURZZEICHEN='$short'"));

        $this->buildList();
    }

    public function buildList() {
        
        global $ibase;
        $result = false;
        if ($this->rid != 0) {
            $this->list = array();
            
            $sql = "SELECT RID FROM " . self::TABLE . " WHERE KURZ_ALT IS NOT NULL ORDER BY ISO_KURZZEICHEN";
            $ids = $ibase->get_list_as_array($sql);
            foreach ($ids as $id) {
                $this->list[$id] = new twebshop_country($id, $this->rid);
            }
            sort_array_by_object_property($this->list, "NAME");
            $this->count = count($this->list);
            
            $result = true;
        }
        return $result;
    }

    public function getList() {
        return $this->list;
    }

    public function getRID() {
        return $this->rid;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $list = "";
        foreach ($this->list as $country) {
            $list .= $country->getFromHTMLTemplate($this->_ttemplate);
        }

        $template = str_replace("~LIST~", $list, $template);

        unset($country);
        unset($list);

        return $template;
    }

}

class twebshop_country extends tvisual {

    static public $properties = array("INT_NAME_R", "INT_WAEHRUNG_R", "ISO_WAEHRUNG", "ISO_KURZZEICHEN", "KURZ_ALT", "ORT_FORMAT");
    private $rid = 0;
    private $land_r = 0;

    const TABLE = TABLE_COUNTRY;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_COUNTRY";

    public function __construct($rid = 0, $land_r = 0) {
        $this->rid = $rid;
        $this->land_r = $land_r;
        $this->getProperties();
        $this->getName();
    }

    private function getProperties() {
        
        global $ibase;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}"; // " LIMIT 1"; // nur 1 Datensatz
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
    }

    public function getName() {
        $this->NAME = self::getNameFromDataBase($this->rid, $this->land_r);
        // BEGIN Patch, weil Datenbank schlecht gepflegt
        if ($this->NAME == "") {
            $this->NAME = self::getNameFromDataBase($this->rid, 84);
        }
        // END
        return $this->NAME;
    }

    public function getRID() {
        return $this->rid;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~ISO_KURZZEICHEN~", $this->ISO_KURZZEICHEN, $template);
        $template = str_replace("~KURZ_ALT~", $this->KURZ_ALT, $template);
        $template = str_replace("~ORT_FORMAT", $this->ORT_FORMAT, $template);
        $template = str_replace("~NAME~", $this->NAME, $template);
        $template = str_replace("~RID~", $this->rid, $template);

        return $template;
    }

    static public function getNameFromDataBase($id, $country_r) {
        
        global $ibase;
        $result = false;
        if ($id != 0 AND $country_r != 0) {
            $sql = "SELECT I.INT_TEXT AS NAME FROM " . self::TABLE . " L JOIN " . TABLE_INTERNATIONAL_TEXT . " I ON (I.LAND_R=$country_r AND I.RID=L.INT_NAME_R) WHERE (L.RID=$id)";
            $result = ucwords(strtolower(trim($ibase->get_blob($ibase->get_field($sql, "NAME")))));
        }
        return $result;
    }

}
?>

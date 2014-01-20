<?php

//**** KLASSE ZUR ZUSAMMENFASSUNG DER AUSGABEARTEN ***********************************************************************************
class twebshop_article_variants extends tvisual {

    static private $instance = NULL;
    public $version = array();
    protected $selected = 0;
    protected $detail = "";
    protected $id = "";

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE_VARIANTS";

    private function __construct($template) {

        global $ibase;
        $this->setHTMLTemplate($template);
        
        $version_rs = $ibase->get_list_as_array("SELECT RID FROM AUSGABEART ORDER BY RID");
        $this->addVersion(0, "Standard", "STD", false, $template);
        foreach ($version_rs as $version_r) {
            $this->version[$version_r] = new twebshop_version($version_r, $template);
        }
    }

    static public function create($template = NULL) {
        if (!self::$instance) {
            self::$instance = new twebshop_article_variants($template);
        }
        return self::$instance;
    }

    public function addVersion($version_r, $name, $short, $hasDetail = false, $template = NULL) {
        $this->version[$version_r] = new twebshop_version($version_r, $template);
        $this->version[$version_r]->setName($name);
        $this->version[$version_r]->setShortName($short);
        $this->version[$version_r]->setDetail($hasDetail);
    }

    public function getByID($version_r) {
        return $this->version[$version_r];
    }

    public function hasDetail($version_r) {
        return $this->version[$version_r]->hasDetail();
    }

    public function setSelected($version_r) {
        $this->selected = $version_r;
    }

    public function setDetail($detail) {
        $this->detail = ($this->version[$this->selected]->hasDetail()) ? $detail : "";
    }

    public function setID($id) {
        $this->id = $id;
    }

    public function getVersionIDbyShortName($short) {
        $result = false;
        foreach ($this->version as $version) {
            if ($version->getShortName() == $short) {
                $result = $version->getID();
            }
        }
        return ($result !== false) ? intval($result) : $result;
    }

    public function existsVersion($id) {
        return array_key_exists($id, $this->version);
    }

    public function clearHTMLTemplate() {
        parent::clearHTMLTemplate();
        foreach ($this->version as $version)
            $version->clearHTMLTemplate();
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $versions = "";
        foreach ($this->version as $version) {
            if ($version->isPublic()) {
                $versions .= $version->getFromHTMLTemplate($this->_ttemplate);
                $versions = str_replace("~PRESELECT~", ($this->selected == $version->getID()) ? "selected" : "", $versions);
            }
        }

        $template = str_replace("~VERSIONS~", $versions, $template);
        $template = str_replace("~ID~", $this->id, $template);
        $template = str_replace("~SELECTED~", $this->selected, $template);
        $template = str_replace("~NAME~", $this->version[$this->selected]->NAME, $template);
        $template = str_replace("~DETAIL~", $this->detail, $template);

        unset($versions);
        return $template;
    }
    
    public function __wakeup() {
        parent::__wakeup();
        self::$instance = $this;
    }

}

//**** KLASSE ZUR ABBILDUNG DER AUSGABEART *******************************************************************************************
class twebshop_version extends tvisual {

    static public $properties = array("NAME", "FREIERTEXT", "KUERZEL", "WEBSHOP");
    protected $rid = 0;
    public $WEBSHOP = "Y";

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_VERSION";

    public function __construct($rid = 0, $template = NULL) {

        $this->rid = $rid;
        $this->setHTMLTemplate($template);
        if ($this->rid != 0) {
            $this->getProperties();
        }
    }

    public function getProperties() {


        global $ibase;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM AUSGABEART WHERE RID={$this->rid}";
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = trim($data->{$name});
        }
    }

    public function isPublic() {
        return (strtoupper($this->WEBSHOP) == "Y") ? true : false;
    }

    public function hasDetail() {
        return (strtoupper($this->FREIERTEXT) == "Y") ? true : false;
    }

    public function setName($name) {
        $this->NAME = $name;
    }

    public function setShortName($short) {
        $this->KUERZEL = $short;
    }

    public function setDetail($hasDetail) {
        $this->FREIERTEXT = ($hasDetail) ? "Y" : "N";
    }

    public function getID() {
        return $this->rid;
    }

    public function getName() {
        return $this->NAME;
    }

    public function getShortName() {
        return $this->KUERZEL;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~KUERZEL~", $this->KUERZEL, $template);
        $template = str_replace("~NAME~", $this->NAME, $template);
        $template = str_replace("~FREIERTEXT~", $this->FREIERTEXT, $template);

        return $template;
    }

    /*
      public function __sleep()
      { $result = array_merge(array("_template"),parent::__sleep());
      //var_dump($result);
      return $result;
      }
     */
}
?>
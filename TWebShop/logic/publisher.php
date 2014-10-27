<?php

//**** KLASSE ZUR ABBILDUNG DES VERLAGS **********************************************************************************************
class twebshop_publisher {

    static public $properties = array("SUCHBEGRIFF");
    public $rid = 0;
    public $text = "";

    const TABLE = TABLE_PERSON;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_PUBLISHER";


    public function __construct($rid = 0) {
        $this->rid = $rid;
        $this->getProperties();
    }

    /* --> 10.10.2014 michaelhacksoftware : Sprechenden Link erstellen */
    public function createLink() {

        if (!$this->rid) return __INDEX;

        return path() . LINK_PUBLISHER . "/" . str2url($this->SUCHBEGRIFF) . "." . $this->rid;

    }
    /* <-- */

    public function getProperties() {

        global $ibase;

        if (!$this->rid) return;

        $sql = "SELECT " . implode(",", twebshop_publisher::$properties) . " FROM " . self::TABLE . " WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_publisher::$properties as $name) {
            $this->{$name} = $data->{$name};
        }

    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
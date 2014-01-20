<?php

//**** KLASSE ZUR ABBILDUNG DES VERLAGS **********************************************************************************************
class twebshop_publisher {

    static public $properties = array("PERSON_R");
    public $rid = 0;
    public $person = NULL;
    public $text = "";

    const TABLE = TABLE_PUBLISHER;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_PUBLISHER";


    public function __construct($rid = 0) {
        $this->rid = $rid;
        $this->getProperties();
    }

    public function getProperties() {
        
        global $ibase;
        $sql = "SELECT " . implode(",", twebshop_publisher::$properties) . " FROM " . self::TABLE . " WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_publisher::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
    }

    public function getPerson() {
        $this->person = new twebshop_person($this->PERSON_R);
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
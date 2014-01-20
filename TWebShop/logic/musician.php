<?php

//**** KLASSE ZUR ABBILDUNG DES MUSIKERS **********************************************************************************************
class twebshop_musician {

    static public $properties = array("VORNAME", "NACHNAME", "EVL_R", "EVL_TRENNER", "MUSIKER_R");
    public $rid = 0;

   
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MUSICIAN";

    public function __construct($rid = 0) {

        $this->rid = $rid;
        $this->getProperties();
    }

    public function getProperties() {

        global $ibase;
        $sql = "SELECT " . implode(",", twebshop_musician::$properties) . " FROM MUSIKER WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_musician::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
    }

    public function __toString() {
        return twebshop_musician::CLASS_NAME;
    }

}
?>
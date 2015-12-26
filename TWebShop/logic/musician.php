<?php

#
# bereits angefragte Musiker bleiben hier gespeichert
#
$webshop_musician_cache = array();

//**** KLASSE ZUR ABBILDUNG DES MUSIKERS **********************************************************************************************
class twebshop_musician {

    static public $properties = array("VORNAME", "NACHNAME", "EVL_R", "EVL_TRENNER", "MUSIKER_R");
    public $rid = 0;

    const TABLE = TABLE_MUSICIAN;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MUSICIAN";

    public function __construct($rid = 0) {

        $this->rid = $rid;
        $this->getProperties();
    }

    /* --> 10.10.2014 michaelhacksoftware : Sprechenden Link erstellen */
    public function createLink() {

        if (!$this->rid) return __INDEX;

        return path() . LINK_MUSICIAN . "/" . str2url($this->VORNAME . " " . $this->NACHNAME) . "." . $this->rid;

    }
    /* <-- */

    public function getProperties() {

        global $ibase;
        global $webshop_musician_cache;

        if (!$this->rid) 
            return;
        
        // Bereits im Cache?
        foreach ($webshop_musician_cache as $wm) {
            
            if ($wm->rid==$this->rid) {
               foreach (twebshop_musician::$properties as $name) {
                  $this->{$name} = $wm->{$name};
               }
               return;      
            }
        } 

        // Die Datenbank fragen
        $sql = "SELECT " . implode(",", twebshop_musician::$properties) . " FROM MUSIKER WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_musician::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
        $webshop_musician_cache[] = $this;
    }

    public function __toString() {
        return twebshop_musician::CLASS_NAME;
    }
}
?>
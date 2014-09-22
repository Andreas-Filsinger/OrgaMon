<?php

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

    public function getProperties() {

        global $ibase;

        if (!$this->rid) return;

        $sql = "SELECT " . implode(",", twebshop_musician::$properties) . " FROM MUSIKER WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_musician::$properties as $name) {
            $this->{$name} = $data->{$name};
        }

    }

    /* --> 28.08.2014 michaelhacksoftware : Alle Musiker ausgeben */
    public function getAllMusicians() {

        global $ibase;

        $Items = array();

        // === Query "Alle Musiker" abfragen
        $ibase->query("SELECT RID, VORNAME, NACHNAME FROM " . self::TABLE . " ORDER BY NACHNAME, VORNAME");

        while ($result = $ibase->fetch_object()) {

            if (!$result->VORNAME && !$result->NACHNAME) continue;

            $Items[] = array(
                "Id"   => $result->RID,
                "Name" => $result->NACHNAME . " " . $result->VORNAME,
                "Url"  => twebshop_person::UrlEncodeName($result->NACHNAME . " " . $result->VORNAME)
            );

        }

        $ibase->free_result();

        return $Items;

    }
    /* <-- */

    public function __toString() {
        return twebshop_musician::CLASS_NAME;
    }

}
?>
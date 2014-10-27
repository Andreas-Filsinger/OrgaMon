<?php

//**** KLASSE ZUR ABBILDUNG DER MUSIKER **********************************************************************************************
class twebshop_musicians {

    const TABLE = TABLE_MUSICIAN;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MUSICIANS";

    /* --> 28.08.2014 michaelhacksoftware : Alle Musiker IDs ausgeben */
    public function getIds() {

        global $ibase;

        $Musicians = array();

        // === Query "Alle Musiker" abfragen
        $ibase->query("SELECT RID FROM " . self::TABLE . " WHERE VORNAME IS NOT NULL OR NACHNAME IS NOT NULL ORDER BY NACHNAME, VORNAME");

        while ($result = $ibase->fetch_object()) {
            $Musicians[] = $result->RID;
        }

        $ibase->free_result();

        return $Musicians;

    }
    /* <-- */

    public function __toString() {
        return twebshop_musicians::CLASS_NAME;
    }

}
?>
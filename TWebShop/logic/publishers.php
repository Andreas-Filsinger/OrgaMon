<?php

//**** KLASSE ZUR ABBILDUNG ALLER VERLAGE *******************************************************************************************
class twebshop_publishers {

    const TABLE = TABLE_PUBLISHER;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_PUBLISHERS";

    /* --> 22.08.2014 michaelhacksoftware : Alle Publisher IDs ausgeben */
    public function getIds() {

        global $ibase;

        $Publishers = array();

        // === Query "Alle Publisher" abfragen
        $ibase->query(
            "SELECT DISTINCT a.VERLAG_R, p.SUCHBEGRIFF FROM " . TABLE_ARTICLE . " AS a" .
            " LEFT JOIN " . TABLE_PERSON   . " AS p ON a.VERLAG_R = p.RID" .
            " LEFT JOIN " . TABLE_CATEGORY . " AS c ON a.SORTIMENT_R = c.RID" .
            " WHERE c.WEBSHOP = 'Y' AND p.SUCHBEGRIFF IS NOT NULL" .
            " ORDER BY p.SUCHBEGRIFF"
        );

        while ($result = $ibase->fetch_object()) {
            $Publishers[] = $result->VERLAG_R;
        }

        $ibase->free_result();

        return $Publishers;

    }
    /* <-- */

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
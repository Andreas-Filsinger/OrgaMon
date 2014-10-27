<?php

//**** KLASSE ZUR ABBILDUNG ALLER ARTIKEL *******************************************************************************************
class twebshop_articles {

    const TABLE = TABLE_ARTICLE;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLES";

    /* --> 20.10.2014 michaelhacksoftware : Alle Artikel IDs ausgeben */
    public function getIds() {

        global $ibase;

        $Articles = array();

        // === Query "Alle Artikel" abfragen
        $ibase->query(
            "SELECT a.RID FROM " . self::TABLE . " AS a" .
            " LEFT JOIN " . TABLE_CATEGORY . " AS c ON a.SORTIMENT_R = c.RID" .
            " WHERE c.WEBSHOP = 'Y' AND a.TITEL IS NOT NULL" .
            " ORDER BY a.TITEL"
        );

        while ($result = $ibase->fetch_object()) {
            $Articles[] = $result->RID;
        }

        $ibase->free_result();

        return $Articles;

    }
    /* <-- */

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
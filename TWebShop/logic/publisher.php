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

        if (!$this->rid) return;

        $sql = "SELECT " . implode(",", twebshop_publisher::$properties) . " FROM " . self::TABLE . " WHERE RID=" . $this->rid;
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (twebshop_publisher::$properties as $name) {
            $this->{$name} = $data->{$name};
        }

    }

    /* --> 22.08.2014 michaelhacksoftware : Alle Publisher ausgeben */
    public function getAllPublishers() {

        global $ibase;

        $Items = array();

        // === Query "Alle Publisher" abfragen
        $ibase->query(
            "SELECT DISTINCT a.VERLAG_R, p.SUCHBEGRIFF FROM " . TABLE_ARTICLE . " AS a" .
            " LEFT JOIN " . TABLE_PERSON . " AS p ON a.VERLAG_R = p.RID" .
            " LEFT JOIN " . TABLE_CATEGORY . " AS c ON a.SORTIMENT_R = c.RID" .
            " WHERE c.WEBSHOP = 'Y'" .
            " ORDER BY p.SUCHBEGRIFF"
        );

        while ($result = $ibase->fetch_object()) {

            if (!$result->SUCHBEGRIFF) continue;

            $Items[] = array(
                "Id"   => $result->VERLAG_R,
                "Name" => $result->SUCHBEGRIFF,
                "Url"  => twebshop_person::UrlEncodeName($result->SUCHBEGRIFF)
            );

        }

        $ibase->free_result();

        return $Items;

    }
    /* <-- */

    public function getPerson() {
        $this->person = new twebshop_person($this->PERSON_R);
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
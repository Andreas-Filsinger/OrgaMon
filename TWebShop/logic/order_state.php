<?php

class twebshop_order_state extends tvisual {

    static private $instance = NULL;
    private $person_r = 0;
    private $items = array();

    const TABLE = TABLE_ITEM;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ORDER_STATE";

    public function __construct($person_r = 0) {

        $this->person_r = $person_r;
        if ($this->person_r != 0) {
            $this->readFromDataBase();
        }
    }

    static public function create($person_r) {
        if (!self::$instance) {
            self::$instance = new twebshop_order_state($person_r);
        }
        return self::$instance;
    }

    public function count() {
        return count($this->items);
    }

    private function readFromDataBase() {

        global $ibase;
        $this->items = array();

        $ibase->query( "SELECT 
                   BELEG.RID BELEG_R,BELEG.TEILLIEFERUNG,BELEG.RECHNUNGS_BETRAG BETRAG,BELEG.DAVON_BEZAHLT BEZAHLT,POSTEN.MENGE_AGENT,POSTEN.MENGE_RECHNUNG,ARTIKEL.NUMERO,POSTEN.AUSGABEART_R,
		           (SELECT KUERZEL FROM AUSGABEART WHERE AUSGABEART.RID=POSTEN.AUSGABEART_R) AUSGABEART_TEXT, POSTEN.ARTIKEL TITEL, ARTIKEL.VERSENDER_R
		           FROM POSTEN JOIN ARTIKEL ON (POSTEN.ARTIKEL_R=ARTIKEL.RID) JOIN BELEG ON (POSTEN.BELEG_R=BELEG.RID) 
		           WHERE (BELEG.PERSON_R={$this->person_r}) AND (ARTIKEL.VERSENDER_R IS NULL) AND ((POSTEN.MENGE_AGENT>0) OR (POSTEN.MENGE_RECHNUNG>0))
		           ORDER BY BELEG.ANLAGE DESC,POSTEN.BELEG_R,POSTEN.ARTIKEL"  
        );
        while ($data = $ibase->fetch_object()) {
            $this->items[] = new twebshop_order_item($data);
            unset($data);
        }
        $ibase->free_result();
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $items = "";
        foreach ($this->items as $item) {
            $items.= $item->getFromHTMLTemplate($this->_ttemplate);
        }

        $template = str_replace("~COUNT~", count($this->items), $template);
        $template = str_replace("~ITEMS~", $items, $template);
        unset($items);

        return $template;
    }

}

class twebshop_order_item extends tvisual {

    static public $properties = array("BELEG_R", "TEILLIEFERUNG", "BETRAG", "BEZAHLT", "MENGE_AGENT", "MENGE_RECHNUNG", "NUMERO", "AUSGABEART_R", "AUSGABEART_TEXT", "TITEL", "VERSENDER_R");

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ORDER_ITEM";

    public function __construct($properties) {
        foreach (self::$properties as $name) {
            $this->{$name} = null2zero($properties->{$name});
            //echo "$name: {$this->{$name}}<br />";
        }
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        foreach (self::$properties as $name) {
            $template = str_replace("~{$name}~", $this->{$name}, $template);
        }

        $template = str_replace("~BILL_NUMBER~", twebshop_bill::formatBillNumber($this->BELEG_R, ($this->TEILLIEFERUNG > 1) ? $this->TEILLIEFERUNG : 0), $template);

        return $template;
    }

}
?>
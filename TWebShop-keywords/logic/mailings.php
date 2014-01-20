<?php

class twebshop_mailings extends tvisual {

    static private $instance = NULL;
    private $person_r = 0;
    private $items = array();

    const TABLE = TABLE_CONTRACT;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MAILINGS";

    public function __construct($person_r = 0) {
        $this->person_r = $person_r;
        if ($this->person_r != 0) {
            $this->readFromDataBase();
        }
    }

    static public function create($person_r) {
        if (!self::$instance) {
            self::$instance = new twebshop_mailings($person_r);
        }
        return self::$instance;
    }

    public function getActiveIDs() {
        $ids = array();
        foreach ($this->items as $item) {
            if ($item->isChecked()) {
                $ids[] = $item->getID();
            }
        }

        return $ids;
    }

    public function isActive($id) {
        return (in_array($id, $this->getActiveIDs()));
    }

    private function readFromDataBase() {
        
        global $ibase;
        $this->items = array();

        //alle Vertragsvarianten ermitteln und deren RID & Namen laden
        $sql = "SELECT MOTIVATION,RID FROM BELEG WHERE RID IN (SELECT DISTINCT BELEG_R FROM " . self::TABLE . ") ORDER BY MOTIVATION";
        //echo $sql;
        $tmp_items = $ibase->get_list_as_associated_array($sql, "MOTIVATION", "RID");
        //die IDs der aktiven Vertragsvarianten des Users laden
        $sql = "SELECT DISTINCT BELEG_R FROM " . self::TABLE . " WHERE PERSON_R={$this->person_r}";
        //echo $sql;
        $tmp_contracts = $ibase->get_list_as_array($sql, "BELEG_R");
        foreach ($tmp_items as $id => $name) {
            $this->items[] = new twebshop_mailing($id, $name, (in_array($id, $tmp_contracts)) ? true : false);
        }
        unset($tmp_items);
        unset($tmp_contracts);
    }

    public function updateInDataBase($ids) {
        
        global $ibase;
        if ($this->person_r != 0) {

            $sql = "SELECT DISTINCT BELEG_R FROM " . self::TABLE . " WHERE PERSON_R={$this->person_r}";
            $pre = $ibase->get_list_as_array($sql, "BELEG_R");
            $post = $ids;

            foreach ($post as $id) {
                if (!in_array($id, $pre)) {

                    $ibase->exec("INSERT INTO " . self::TABLE . " (PERSON_R,BELEG_R,LETZTE_TAN) VALUES ({$this->person_r},$id,1)");
                } else {
                    $pre = array_diff($pre, array($id));
                }
            }

            foreach ($pre as $id) {
                $ibase->exec("DELETE FROM " . self::TABLE . " WHERE (BELEG_R=$id) AND (PERSON_R={$this->person_r})");
            }

            $this->readFromDataBase();
        }
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

class twebshop_mailing extends tvisual {

    private $rid = 0;
    private $name = "";
    private $checked = false;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MAILING";

    public function __construct($rid, $name, $checked) {
        $this->rid = $rid;
        $this->name = $name;
        $this->checked = $checked;
    }

    public function getID() {
        return $this->rid;
    }

    public function getName() {
        return $this->name;
    }

    public function isChecked() {
        return $this->checked;
    }

    public function setChecked($checked) {
        $this->checked = $checked;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~NAME~", $this->name, $template);
        $template = str_replace("~CHECKED~", ($this->checked) ? "checked" : "", $template);

        return $template;
    }

}
?>

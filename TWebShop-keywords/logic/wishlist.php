<?php

//**** KLASSE ZUR ABBILDUNG DES EINKAUFWAGENS ****************************************************************************************
class twebshop_wishlist extends twebshop_cart {

    static private $properties = array("RID", "ARTIKEL_R", "MENGE", "AUSGABEART_R", "BEMERKUNG", "POSNO", "SCHRANK", "ANLAGE");
    private $id = NULL;
    //private $name = "";
    //private $datetime = "";

    private $timestamp_last_added = 0;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_WISHLIST";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct($person_r, $id = NULL) { //$this->delivery = new twebshop_delivery();
        $this->setPerson($person_r);
        $this->setID($id);
        $this->delivery = new twebshop_delivery();
        if ($this->person_r != 0 AND $this->id != NULL) {
            $this->readFromDataBase();
        }
    }

    public function setPerson($person_r = 0) {
        $this->person_r = intval($person_r);
    }

    public function getPerson() {
        return $this->person_r;
    }

    public function setID($id) {
        $this->id = intval($id);
    }

    public function getTimestampLastAdded() {
        $timestamp = $this->timestamp_last_added;
        foreach ($this->article as $index => $article) {
            if ($timestamp < tibase::timestamp($article->timestamp)) {
                $timestamp = tibase::timestamp($article->timestamp);
            }
        }
        $this->timestamp_last_added = date("m-d-Y H:i:s", $timestamp);
        return $this->timestamp_last_added;
    }

    public function addArticle($article_r, $quantity = 1, $version_r = 0, $detail = "", $cart_r = 0, $position = 0, $timestamp = "") {
        $article = parent::addArticle($article_r, $quantity, $version_r, $detail, $cart_r);
        $index = $this->getIndexByUID($article->getUID());
        unset($article);
        $this->article[$index]->setPosition($position);
        $this->article[$index]->timestamp = $timestamp;
        $this->article[$index]->setWID($this->id);
    }

    public function moveToCart($uid) {
        $index = $this->getIndexByUID($uid);
        $this->article[$index]->setWID(NULL);
        $this->article[$index]->setPosition(NULL);
        $this->updateInDataBase($index);
        unset($index);
    }

    protected function readFromDataBase() {
        

        global $ibase;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM WARENKORB WHERE (PERSON_R={$this->person_r}) AND (SCHRANK={$this->id}) ORDER BY POSNO,RID";
        //echo "*$sql*";
        $result = $ibase->query($sql);
        while ($data = $ibase->fetch_object($result)) {
            if ($data->ARTIKEL_R != NULL) {
                $this->addArticle(twebshop_article::encryptRID($data->ARTIKEL_R), intval($data->MENGE), intval($data->AUSGABEART_R), trim($data->BEMERKUNG), intval($data->RID), intval($data->POSNO), $data->ANLAGE);
            } elseif ($data->MENGE == NULL) {
                foreach (self::$properties as $name) {
                    $this->{$name} = $data->{$name};
                }
            }
        }
        $ibase->free_result($result);
    }

    public function getFromHTMLTemplate($template = NULL, $clear = false) {
        $template = parent::getFromHTMLTemplate($template, false);

        $template = str_replace("~NAME~", $this->BEMERKUNG, $template);
        $template = str_replace("~ANLAGE~", tibase::datetime($this->ANLAGE), $template);
        $template = str_replace("~ANLAGE_DATUM~", $this->ANLAGE, $template);
        $template = str_replace("~ANLAGE_ZEIT~", tibase::time($this->ANLAGE), $template);
        $template = str_replace("~LAST_ADDED~", $this->getTimestampLastAdded(), $template);

        if ($clear) {
            $this->clearHTMLTemplate();
        }
        return $template;
    }

    public function __wakeup() {
        self::$instance = $this;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>

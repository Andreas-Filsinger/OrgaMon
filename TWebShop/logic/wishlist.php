<?php

//**** KLASSE ZUR ABBILDUNG DES EINKAUFWAGENS ****************************************************************************************
class twebshop_wishlist extends twebshop_cart {

    static private $instance = NULL;
    static private $properties = array("RID", "ARTIKEL_R", "MENGE", "AUSGABEART_R", "BEMERKUNG", "POSNO", "SCHRANK", "ANLAGE");
    protected $id = NULL;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_WISHLIST";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct($person_r, $id = NULL) {
        $this->setPerson($person_r);
        $this->setID($id);

        $this->delivery = new twebshop_delivery();
        if ($this->person_r != 0 AND $this->id != NULL) {
            $this->readFromDataBase();
        }
    }

    /* 04.05.2015 michaelhacksoftware : Klasse als Singleton implementieren */
    static public function create($person_r, $id) {

        self::$instance = new twebshop_wishlist($person_r, $id);

        return self::$instance;

    }
    static public function destroy() {

        self::$instance = NULL;

    }
    static public function getInstance() {

        return self::$instance;

    }
    /* --- */

    public function setPerson($person_r = 0) {
        $this->person_r = intval($person_r);
    }
    public function setID($id) {
        $this->id = intval($id);
    }

    /* 04.05.2015 michaelhacksoftware : Angepasste Funktion für die Merkliste */
    public function addArticle($article_r, $quantity = 1, $version_r = 0, $detail = "", $cart_r = 0) {

        global $errorlist;

        $new = false;
        $uid = twebshop_article::buildUID($article_r, $version_r, $detail);

        if (!$this->inCart($uid)) {
            $this->article[] = new twebshop_article($article_r, $version_r, $this->person_r, 1, $detail, $cart_r);
            $new = true;
        }

        $index = $this->getIndexByUID($uid);

        $this->article[$index]->setWID($this->id);
        $this->article[$index]->timestamp = time();
        $this->positions = count($this->article);

        if ($new) {
            $this->insertIntoDataBase($index);
        } else {
            $this->updateInDataBase($index);
        }

        return $this->article[$index];

    }

    public function clear() {

        foreach ($this->article as $index => $item) {
            $this->deleteFromDataBase($index);
        }

        unset($this->article);

        $this->article   = array();
        $this->positions = 0;

    }
    /* --- */

    public function moveToCart($uid) {

        global $cart;

        $index = $this->getIndexByUID($uid);

        /* === Artikel in Warenkorb hinzufügen und aus Merkliste löschen === */
        $cart->addArticle($this->article[$index]->getRID(), 1, $this->article[$index]->getVersion());
        $this->deleteArticle($uid);

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

        global $article_variants;

        $template = parent::getFromHTMLTemplate($template, false);

        foreach ($this->article as $index => $article) {
            $template .= $article->getFromHTMLTemplate($this->_ttemplate) . "<!-- INDEX $index -->";
        }

        if ($clear) {
            $this->clearHTMLTemplate();
        }

        return $template;

    }

}
?>
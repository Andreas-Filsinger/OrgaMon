<?php

//**** KLASSE ZUR ABBILDUNG DES EINKAUFWAGENS ****************************************************************************************
class twebshop_cart extends tvisual {

    static private $instance = NULL;
    protected $person_r = 0;
    protected $positions = 0;
    protected $sum = 0.00;
    protected $delivery = NULL;
    protected $availability = NULL;
    public $article = array();

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_CART";


    protected function __construct() {

        $this->delivery = new twebshop_delivery();
    }

    static public function create($person_r = 0) {
        if (!self::$instance) {
            self::$instance = new twebshop_cart();
        }
        return self::$instance;
    }

    public function setPerson($person_r = 0) {
        $this->person_r = $person_r;
        foreach (array_keys($this->article) as $index)
            $this->article[$index]->setPerson($this->person_r);
        $this->buildSum();
    }

    public function buildSum() {
    
        $this->sum = 0;

        foreach ($this->article as $article)
            $this->sum += $article->price->getSumBrutto();

        $this->sum += $this->getDeliveryPriceSumme();

        return $this->sum;

    }

    public function getSum() {
        return $this->sum;
    }

    protected function getDeliveryPriceSumme() {
        
        global $orgamon;
        
        $delivery = $orgamon->getDeliveryPrice($this->person_r);
        
        /* --> 04.02.2015 michaelhacksoftware : Standardversandkosten anzeigen, wenn unbekannt */
        if ($delivery == twebshop_price::TYPE_UNKNOWN and $this->positions > 0) {
            $delivery = DEFAULT_DELIVERY_PRICE;
        }
        /* <-- */

        $this->delivery->setValues($delivery);
        unset($delivery);
        
        return $this->delivery->getSumBrutto();
        
    }

    public function getPositions() {
        return $this->positions;
    }

    protected function getVariantsContained() {
        $variants = array();
        foreach ($this->article as $article) {
            $variants[] = $article->getVersion();
        }
        return array_unique($variants, SORT_NUMERIC);
    }

    public function containsVersion($version_r) {
        return in_array($version_r, $this->getVariantsContained());
    }

    public function getAvailability($force_update = false) {
        if ($this->availability == NULL OR $force_update) {
            $this->availability = new twebshop_cart_availability();
            foreach ($this->article as $article) {
                $timestamp = $article->getAvailability()->getTimestamp();
                $this->availability->setSoonest(($timestamp < $this->availability->getSoonest() OR $this->availability->getSoonest() == 0) ? $timestamp : $this->availability->getSoonest());
                $this->availability->setLatest(($timestamp > $this->availability->getLatest()) ? $timestamp : $this->availability->getLatest());
                unset($timestamp);
            }
        }
        return $this->availability;
    }

    public function addArticle($article_r, $quantity = 1, $version_r = 0, $detail = "", $cart_r = 0) {
        $uid = twebshop_article::buildUID($article_r, $version_r, $detail);
        if ($this->inCart($uid)) { // Genau dieser Artikel schon im Einkaufswagen ?  
            $index = $this->getIndexByUID($uid); // Ja, Menge anpassen
            $this->article[$index]->incQuantity($quantity);
            $this->article[$index]->cart_r = max($this->article[$index]->cart_r, $cart_r);
            $this->updateInDataBase($index);
        } else {
            $article = new twebshop_article($article_r, $version_r, $this->person_r, $quantity, $detail, $cart_r); // Nein, neuen Artikel hinzufügen
            $this->article[] = $article;
            $index = $this->getIndexByUID($uid);
            $this->insertIntoDataBase($index);
        }
        $this->positions = count($this->article);
        $this->article[$index]->setPosition($this->getPositionByUID($uid));
        $this->buildSum();
        return $this->article[$index]; // $index muss in beiden Fällen der if-Bedingung gesetzt werden
    }

    public function updateArticle($uid, $quantity = 0, $version_r = 0, $detail = "") {
        $index = $this->getIndexByUID($uid);
        $article_r = $this->article[$index]->getRID();
        $tmp_uid = twebshop_article::buildUID($article_r, $version_r, $detail);
        if ($quantity != 0) {
            if ($this->inCart($tmp_uid) AND $uid != $tmp_uid) { // UID ändert sich und es befindet sich schon ein Artikel mit der neuen UID im Einkaufswagen
                $this->addArticle($article_r, $quantity, $version_r, $detail); // Positionen zusammenführen
                $this->deleteArticle($uid); // alte Position löschen
            } else { // UID ändert sich nicht ODER neue UID noch nicht vorhanden
                $this->article[$index]->setQuantity($quantity);
                $this->article[$index]->setVersion($version_r);
                $this->article[$index]->setDetail($detail);
                $this->updateInDataBase($index);
            }
        }
        else
            $this->deleteArticle($uid);
        $this->buildSum();
    }

    public function deleteArticle($uid) {
        $index = $this->getIndexByUID($uid);
        //var_dump($index);
        $this->deleteFromDataBase($index);
        $this->article = array_diff_key($this->article, array($index => ""));
        $this->positions = count($this->article);
        $this->rebuildPositions();
        $this->buildSum();
    }

    public function inCart($uid) {
        return ($this->getIndexByUID($uid) === false) ? false : true;
    }

    public function getIndexByUID($uid) {
        $result = false;
        foreach ($this->article as $index => $article) {
            $result = ($article->getUID() == $uid) ? $index : $result;
        }
        return $result;
    }

    public function getPositionByUID($uid) {
        $result = false;
        $i = 1;
        foreach ($this->article as $article) {
            $result = ($article->getUID() == $uid) ? $i : $result;
            $i++;
        }
        return $result;
    }

    protected function rebuildPositions() {
        foreach ($this->article as $index => $article) {
            $this->article[$index]->setPosition($this->getPositionByUID($this->article[$index]->getUID()));
        }
    }

    public function clear() {
        $this->positions = 0;
        $this->sum = 0.00;
        $this->getDeliveryPriceSumme();
        unset($this->article);
        $this->article = array();
        $this->buildSum();
    }

    protected function updateInDataBase($index) {
        
        global $ibase;
        $article = $this->article[$index];
        $result = false;
        if ($this->person_r != 0 AND $article->cart_r != 0) {

            $result = $ibase->exec("UPDATE WARENKORB SET " .
                    "MENGE={$article->quantity}," .
                    "AUSGABEART_R={$article->getVersion(true)}," .
                    "BEMERKUNG=" . tibase::format_for_insert($article->detail) . "," .
                    "SCHRANK=" . tibase::format_for_insert($article->getWID()) . "," .
                    "POSNO=" . tibase::format_for_insert($article->getPosition()) . " " .
                    "WHERE (PERSON_R={$this->person_r} AND RID={$article->cart_r})");
        }
        return $result;
    }

    protected function insertIntoDataBase($index) {
        
        global $ibase;
        $article = $this->article[$index];
        $result = false;
        if ($this->person_r != 0 AND $article->cart_r == 0) {

            $rid = $ibase->gen_id("GEN_WARENKORB");
            $sql = "INSERT INTO WARENKORB(RID,ARTIKEL_R,PERSON_R,MENGE,AUSGABEART_R,BEMERKUNG) VALUES ($rid,{$article->getiRID()},{$this->person_r},{$article->quantity},{$article->getVersion(true)},'{$article->detail}')";
            $result = $ibase->exec($sql);
            $this->article[$index]->cart_r = $rid;
            unset($rid);
        }
        return $result;
    }

    protected function deleteFromDataBase($index) {
        global $ibase;
        $cart_r = $this->article[$index]->cart_r;
        $result = false;
        if ($this->person_r != 0 AND $cart_r != 0) {

            $sql = "DELETE FROM WARENKORB WHERE (PERSON_R={$this->person_r} AND RID=$cart_r)";
            $result = $ibase->exec($sql);
        }
        return $result;
    }

    public function updateFromDataBase() {
        $this->clear();
        $this->readFromDataBase();
    }

    protected function readFromDataBase() {
        
        global $ibase;
        if ($this->person_r != 0) {

            $sql = "SELECT RID,ARTIKEL_R,MENGE,AUSGABEART_R,BEMERKUNG FROM WARENKORB WHERE (PERSON_R={$this->person_r}) AND (SCHRANK IS NULL) ORDER BY RID";
            $result = $ibase->query($sql);
            while ($data = $ibase->fetch_object($result)) {
                
                $this->addArticle(twebshop_article::encryptRID($data->ARTIKEL_R), intval($data->MENGE), intval($data->AUSGABEART_R), trim($data->BEMERKUNG), intval($data->RID));
            }
            $ibase->free_result($result);
        }
        return true;
    }

    public function synchronizeWithDataBase() {
        $this->readFromDataBase();
        foreach ($this->article as $index => $article) {
            if ($article->cart_r == 0) {
                $this->insertIntoDataBase($index);
            }
        }
        //$this->clear();
        //$this->readFromDataBase();
    }

    public function getFromHTMLTemplate($template = NULL, $clear = false) {
        $template = parent::getFromHTMLTemplate($template, false);
        //$template = ($template == NULL) ? $this->template : $this->setHTMLTemplate($template);

        $articles = "";
        foreach ($this->article as $index => $article) { //$article->price->setHTMLTemplate($this->ttemplate);
            $articles .= $article->getFromHTMLTemplate($this->_ttemplate) . "<!-- INDEX $index -->";
        }

        $template = str_replace("~ARTICLES~", $articles, $template);
        //$template = str_replace("~DELIVERY~",twebshop_price::toCurrency(($this->delivery == 0.00) ? $this->getDeliveryPrice() : $this->delivery),$template);
        //$template = str_replace("~DELIVERY~",twebshop_price::toCurrency($this->delivery),$template);
        $template = str_replace("~DELIVERY~", $this->delivery->getFromHTMLTemplate($this->_ttemplate), $template);
        $template = str_replace("~POSITIONS~", $this->positions, $template);
        $template = str_replace("~SUM~", twebshop_price::toCurrency($this->getSum()), $template);

        if ($clear) {
            $this->clearHTMLTemplate();
        }
        return $template;
    }

    /* --> 02.02.2015 michaelhacksoftware: Artikelübersicht für Bestellmail erstellen */
    public function getOrderSummary($Discount) {
    
        $Values = array();

        /* === Artikelliste === */
        $Values['Items'] = "";

        foreach ($this->article as $Article) {
        
            $Values['Items'] .= str_fixed_len($Article->quantity, 6) . " " .
                                str_fixed_len($Article->NUMERO,  11) . " " .
                                str_fixed_len($Article->TITEL,   64) . " " .
                                str_pad(number_format($Article->price->getSumBrutto(), 2, ",", "."), 10, ' ', STR_PAD_LEFT) .
                                
                                CRLF .
                                
                                str_fixed_len("", 19) .
                                str_fixed_len($Article->getComposer() . " / " . $Article->getArranger() . " / " . $Article->getPublisher(), 59) . " " .
                                str_pad($Discount ? "(" . number_format($Article->price->getSumNetto(), 2, ",", ".") . " - " . $Article->price->getPercent() . "%)" : "", 15, ' ', STR_PAD_LEFT) . 

                                CRLF;

        }

        $Values['Items'] = substr($Values['Items'], 0, -2);
        
        /* === Versandkosten === */
        $Values['Shipping'] = str_pad(number_format($this->getDeliveryPriceSumme(), 2, ",", "."), 16, ' ', STR_PAD_LEFT);
        
        /* === Gesamtpreis === */
        $Values['Total'] = str_pad(number_format($this->getSum(), 2, ",", "."), 17, ' ', STR_PAD_LEFT);

        return $Values;

    }
    /* <-- */

    /* public function __sleep()
      { //return array_merge(array("person_r","positions","sum","delivery","article"),parent::__sleep());
      } */

    public function __wakeup() {
        self::$instance = $this;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}

class twebshop_cart_availability extends tvisual {

    protected $soonest = 0; //timestamp
    protected $latest = 0;  //timestamp

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_CART_AVAILABILITY";

    public function setSoonest($soonest) {
        $this->soonest = $soonest;
    }

    public function setLatest($latest) {
        $this->latest = $latest;
    }

    public function getSoonest() {
        return $this->soonest;
    }

    public function getLatest() {
        return $this->latest;
    }

}
?>
<?php

class twebshop_mymusic extends tvisual {

    static private $instance = NULL;
    private $person_r = 0;
    public $items = array();

    const TABLE = TABLE_DELIVERY;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MYMUSIC";

    public function __construct($person_r = 0) {

        $this->person_r = $person_r;
        if ($this->person_r != 0) {
            $this->readFromDataBase();
        }
    }

    static public function create($person_r) {
        if (!self::$instance) {
            self::$instance = new twebshop_mymusic($person_r);
        }
        return self::$instance;
    }

    public function count() {
        return count($this->items);
    }

    public function getItemByArticleID($article_r) {
        foreach ($this->items as $item) {
            if ($item->getArticleID() == $article_r) {
                break;
            }
        }
        return $item;
    }

    private function readFromDataBase() {

        global $ibase;
        global $article_variants;
        $this->items = array();
        
        $ibase->query(
                "SELECT GELIEFERT.RID AS RID, 
                  GELIEFERT.ARTIKEL_R AS ARTIKEL_R, 
		  GELIEFERT.ARTIKEL AS ARTIKEL, 
		  GELIEFERT.BELEG_R AS BELEG_R, 
		  GELIEFERT.MENGE_AGENT AS MENGE_AGENT, 
		  GELIEFERT.MENGE_GELIEFERT AS MENGE_GELIEFERT,
		  BELEG.ANLAGE AS ANLAGE
                 FROM GELIEFERT 
                 JOIN BELEG ON 
                  (BELEG.RID=GELIEFERT.BELEG_R) AND (BELEG.PERSON_R={$this->person_r}) 
                 WHERE 
                  (GELIEFERT.ARTIKEL_R IS NOT NULL) AND 
		  (GELIEFERT.MENGE_AGENT IS NOT NULL) AND 
		  (GELIEFERT.AUSGABEART_R={$article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3)})
		 ORDER BY GELIEFERT.RID"
        );
        while ($data = $ibase->fetch_object()) {
            $this->items[] = new twebshop_mymusic_item($data->RID, $data);
            unset($data);
        }
        $ibase->free_result();

        return $this->items;
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

class twebshop_mymusic_item extends tvisual {

    static public $properties = array("ARTIKEL", "ARTIKEL_R", "MENGE_AGENT", "MENGE_GELIEFERT", "BELEG_R", "ANLAGE"); //oben auch im SQL-Statement ergänzen
    private $rid = 0;
    private $article = NULL;

    const TABLE = TABLE_DELIVERY;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_MYMUSIC_ITEM";

    public function __construct($rid = 0, $properties) {
        if ($rid != 0) {
            $this->rid = $rid;
            foreach (self::$properties as $name) {
                $this->{$name} = null2zero($properties->{$name});
                //echo "$name: {$this->{$name}}<br />";
            }
        }
    }

    public function setID($rid) {
        $this->rid = intval($rid);
        return $this->rid;
    }

    public function getID() {
        return $this->rid;
    }

    public function areDownloadsAvailable() {
        return ($this->MENGE_AGENT > $this->MENGE_GELIEFERT) ? true : false;
    }

    public function getRemainingDownloads() {
        return intval($this->MENGE_AGENT) - intval($this->MENGE_GELIEFERT);
    }

    public function decrementRemainingDownloads() {
        if ($this->areDownloadsAvailable()) {
            $this->MENGE_GELIEFERT = intval($this->MENGE_GELIEFERT) + 1;
        }
    }

    public function getDate($separator = ".") {
        return tibase::date($this->ANLAGE, $separator);
    }

    public function getArticleID() {
        return $this->ARTIKEL_R;
    }

    public function getArticle() {
        if ($this->article == NULL) {
            $this->article = new twebshop_article($this->ARTIKEL_R);
        }
        return $this->article;
    }

    public function updateInDataBase() {

        global $ibase;
        $result = false;
        if ($this->rid != 0) {

            $sql = "UPDATE " . self::TABLE . " SET MENGE_GELIEFERT={$this->MENGE_GELIEFERT} WHERE RID={$this->getID()}";
            $result = $ibase->exec($sql);
        }
        return ($result) ? true : false;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~ARTICLE~", ($this->getArticle() != NULL) ? $this->article->getFromHTMLTemplate($this->_ttemplate) : "", $template);
        $template = str_replace("~ARTIKEL~", $this->ARTIKEL, $template);
        $template = str_replace("~ARTIKEL_R~", urlencode(twebshop_article::encryptRID($this->ARTIKEL_R)), $template);
        $template = str_replace("~ARTIKEL_R_RAW~", twebshop_article::encryptRID($this->ARTIKEL_R), $template);
        $template = str_replace("~BELEG_NO~", twebshop_bill::formatBillNumber($this->BELEG_R, 0), $template);
        $template = str_replace("~BELEG_R~", $this->BELEG_R, $template);
        $template = str_replace("~DATE~", $this->getDate(), $template);
        $template = str_replace("~MENGE_AGENT~", $this->MENGE_AGENT, $template);
        $template = str_replace("~MENGE_GELIEFERT~", $this->MENGE_GELIEFERT, $template);
        $template = str_replace("~REMAINING_DOWNLOADS~", $this->getRemainingDownloads(), $template);
        $template = str_replace("~RID~", $this->getID(), $template);

        return $template;
    }

}
?>
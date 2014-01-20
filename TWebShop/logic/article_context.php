<?php

class twebshop_article_context extends tvisual {

    static public $properties = array("BEZEICHNUNG", "MULTIBEL", "HAUPTARTIKEL", "ZWINGEND");
    private $rid = 0;
    private $masters = array();

    const TABLE = TABLE_ARTICLE_CONTEXT;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE_CONTEXT";
    
    public function __construct($rid = 0) {
        $this->rid = $rid;
        if ($this->rid != 0) {
            $this->getProperties();
        }
    }

    private function getProperties() {
        
        global $ibase;
        $sql = "SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}";
        $ibase->query($sql);
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
        
    }

    public function getMasters($sql_order_string = "") {
        if (count($this->masters) == 0) {
            $this->masters = self::getMasterIDsByArticleContextID($this->rid, $sql_order_string);
        }
        return $this->masters;
    }

    public function loadMasters($desc = false) {
        if (count($this->masters) == 0) {
            $this->getMasters($desc);
        }
        $articles = array();
        foreach ($this->masters as $id) {
            $articles[$id] = new twebshop_article($id);
        }
        return $articles;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~BEZEICHNUNG~", $this->BEZEICHNUNG, $template);
        $template = str_replace("~HAUPTARTIKEL~", $this->HAUPTARTIKEL, $template);
        $template = str_replace("~MULTIBEL~", $this->MULTIBEL, $template);
        $template = str_replace("~ZWINGEND~", $this->ZWINGEND, $template);

        return $template;
    }

    static public function getMasterIDsByArticleContextID($context_r, $sql_order_string = "") {
        
        global $ibase;
        
        $sql =
                "SELECT 
	     M.MASTER_R AS RID 
	   FROM " . TABLE_ARTICLE_MEMBER . " AS M 
	   JOIN " . TABLE_ARTICLE . " AS A 
	   ON (M.MASTER_R=A.RID) AND ((A.WEBSHOP='J') OR (A.WEBSHOP is null)) 
	   WHERE CONTEXT_R=$context_r 
	   GROUP BY M.MASTER_R" . (($sql_order_string != "") ? " " . $sql_order_string : "");
        $ids = $ibase->get_list_as_array($sql);
       
        //var_dump($ids);
        //echo count($ids);
        return $ids;
    }

}
?>
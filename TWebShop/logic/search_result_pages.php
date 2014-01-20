<?php

class twebshop_search_result_pages extends tpages {

    protected $abc_index = array();
    protected $sid = 0;

    const CLASS_NAME = "PHP5CLASS_T_WEBSHOP_SEARCH_RESULT_PAGES";

    public function __construct($articles, $sid, $page_size = 10) {
        parent::__construct($articles, $page_size);
        $this->sid = $sid;
    }

    //public function buildABCIndex($template_abc_option)
    public function buildABCIndex() {

        global $ibase;
        $this->abc_index = array();
        $_letter = "";
        $letters = array();
        foreach ($this->items as $index => $id) { // $sql = "SELECT SUBSTRING(LTRIM(TITEL) FROM 1 FOR 1) LETTER FROM " . twebshop_article::TABLE . " WHERE RID=$id";
            
            $list = $ibase->get_list_as_associated_array("SELECT TITEL, NUMERO FROM " . twebshop_article::TABLE . " WHERE RID=$id", "TITEL", "NUMERO");
            list($numero, $title) = each($list);
            //echo $title . BR;
            $letter = mb_substr(trim($title), 0, 1);
            unset($title);
            if ($letter == $_letter)
                continue;
            if (in_array($letter, $letters)) {
                unset($this->abc_index);
                $this->abc_index = array();
                break;
            }
            // echo $letter . BR;
            $letters[] = $letter;
            $page = intval(ceil(($index + 1) / $this->page_size));
            //$this->abc_index[] = new tpages_index_option($page, $template_abc_option, $letter);
            $this->abc_index[] = new tpages_index_option($page, $letter, $numero);
            $_letter = $letter;
        }

        return $this->existsABCIndex();
    }

    public function existsABCIndex() {
        return (count($this->abc_index) > 0) ? true : false;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $abc = "";
        foreach ($this->abc_index as $abc_index_option) {
            $abc.= $abc_index_option->getFromHTMLTemplate($this->_ttemplate);
        }

        $template = str_replace("~ABC~", $abc, $template);
        $template = str_replace("~SID~", $this->sid, $template);

        $this->html = $template;
        return $template;
    }

    public function __toString() {
        return parent::__toString();
    }

}
?>
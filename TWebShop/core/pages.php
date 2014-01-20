<?php
define("DEFAULT_PAGE_SIZE", 10); // Wieviele Items auf einer Page angezeigt werden sollen
define("DEFAULT_PAGE_INDEX_RANGE", 10); // Wieviele Pages in der Auswahlliste angezeigt werden sollen
//***************
// KLASSE TPAGES
//***************
// TS 05.12.2011: buildPageIndex() wird nicht mehr mit den Templates als Parameter gerufen, die Templates werden jetzt mittels der Template-Klasse durchgetragen,
//                die Wahl verschiedener Templates ist mit Hilfe des Template-Selectors möglich.

class tpages extends tvisual {

    public $items = array();
    public $count = 0;
    protected $item_index_start = 0;
    protected $item_index_stop = 0;
    public $pages = 1;
    protected $page = 1;
    protected $page_size = DEFAULT_PAGE_SIZE;
    protected $page_index_range = DEFAULT_PAGE_INDEX_RANGE;
    protected $page_index = array();
    protected $html = "";

    const CLASS_NAME = "PHP5CLASS_T_PAGES";

    public function __construct($items, $page_size = DEFAULT_PAGE_SIZE, $page_index_range = DEFAULT_PAGE_INDEX_RANGE) {
        $this->items = array_values($items); // array_values liefert ein Array mit einem linearen numerischen Index (ohne Lücken) 
        $this->count = count($this->items);
        $this->page_size = $page_size;
        $this->page_index_range = $page_index_range;
        $this->buildPages();
    }

    public function setPage($page = 1) {
        $page = ($page == NULL) ? 1 : $page;

        $tmp_page = $this->getPage();
        $this->page = ($page <= $this->pages) ? $page : $this->pages;
        $this->item_index_start = max(($this->page - 1) * $this->page_size + 1, 1);  // erste Seite hat den Index 1 !!!
        $this->item_index_stop = min(($this->page * $this->page_size), $this->count);

        if ($this->getPage() != $tmp_page) {
            $this->buildPageIndex();
        }
        unset($tmp_page);
    }

    public function getPage() {
        return $this->page;
    }

    public function prevPage() {
        return ($this->page > 1) ? ($this->page - 1) : false;
    }

    public function nextPage() {
        return ($this->page < $this->pages) ? ($this->page + 1) : false;
    }

    public function setPageSize($page_size = DEFAULT_PAGE_SIZE) {
        $this->page_size = $page_size;
    }

    public function buildPages($page_size = 0) {
        $this->page_size = ($page_size == 0) ? $this->page_size : $page_size;
        $this->pages = ceil($this->count / $this->page_size);
        $this->setPage(1);
    }

    //public function buildPageIndex($template_index_option, $template_index_option_disabled = "", $page_index_range = 0)
    public function buildPageIndex($page_index_range = 0) { //$template_index_option_disabled = ($template_index_option_disabled == "") ? $template_index_option : $template_index_option_disabled;
        $this->page_index_range = ($page_index_range == 0) ? $this->page_index_range : $page_index_range;
        $this->page_index = array();

        $range = min($this->pages, $this->page_index_range);
        $range_half = ceil($range / 2);

        $page_start = 1 + (($this->page - $range_half >= 0) ? ($this->page - $range_half) : 0);
        $page_start = (($page_start + $range) > $this->pages AND ($this->pages - $range) >= 0) ? ($this->pages - $range + 1) : $page_start;

        for ($i = $page_start; $i < $page_start + $range; $i++) { //$this->page_index[] = new tpages_index_option($i,($i != $this->page) ? $template_index_option : $template_index_option_disabled);
            $this->page_index[] = new tpages_index_option($i);
        }
    }

    public function getItem($index) {
        return $this->items[$index - 1];
    }

    public function getItemStartIndex() {
        return $this->item_index_start;
    }

    public function getItemStopIndex() {
        return $this->item_index_stop;
    }

    public function clearHTMLTemplate() {
        parent::clearHTMLTemplate();
        $this->html = "";
        foreach ($this->page_index as $page_index_option) {
            $page_index_option->clearHTMLTemplate();
        }
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $index = "";
        foreach ($this->page_index as $page_index_option) {
            $index.= $page_index_option->getFromHTMLTemplate($this->_ttemplate);
        }

        $template = str_replace("~COUNT~", $this->count, $template);
        $template = str_replace("~INDEX~", $index, $template);
        $template = str_replace("~ITEM_START_INDEX~", $this->item_index_start, $template);
        $template = str_replace("~ITEM_STOP_INDEX~", $this->item_index_stop, $template);
        $template = str_replace("~PAGE~", $this->page, $template);
        $template = str_replace("~PAGES~", $this->pages, $template);
        $template = str_replace("~PREV_PAGE~", $this->prevPage(), $template);
        $template = str_replace("~NEXT_PAGE~", $this->nextPage(), $template);
        unset($index);

        $this->html = $template;
        return $template;
    }

    //public function __sleep()
    //{ //return array_merge(array("items","page","page_size","page_index_range","pages","page_index"),parent::__sleep());
    //} 

    public function __wakeup() { //parent::__wakeup();
        $this->setPage($this->page);
        $this->count = count($this->items);
    }

    public function __toString() {
        return ($this->html != "") ? $this->html : self::CLASS_NAME;
    }

}

//****************************
// KLASSE TPAGES_INDEX_OPTION
//****************************
// TS 03.12.2011: jetzt Nachfahre von T_VISUAL

class tpages_index_option extends tvisual {

    protected $page = 0;
    protected $text = "";
    protected $anchor = "";

    const CLASS_NAME = "PHP5CLASS_T_PAGES_INDEX_OPTION";

    public function __construct($page, $text = "", $anchor = "") {
        $this->page = $page;
        $this->text = $text;
        $this->anchor = $anchor;
    }

    public function getPage() {
        return $this->page;
    }

    public function getText() {
        return $this->text;
    }

    public function getAnchor() {
        return $this->anchor;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~ANCHOR~", $this->getAnchor(), $template);
        $template = str_replace("~PAGE~", $this->getPage(), $template);
        $template = str_replace("~TEXT~", $this->getText(), $template);

        return $template;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
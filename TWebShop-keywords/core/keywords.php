<?php


class tkeywords {
    private $words = array();
    private $separator = ""; 
    
    const SEPARATOR_DEFAULT = ", ";
    const SEPARATOR_SPLIT_PATTERN = "[,;]";
    
    const CLASS_NAME = "PHP5CLASS T_KEYWORDS";
    
    
    public function __construct($list, $separator = self::SEPARATOR_DEFAULT) {
        $this->setList($list, $separator);
    }
        
    static private function doSplit($keywords) {
        $result = array();
        if (is_array($keywords)) {
            foreach($keywords as $keyword) {
                if (is_array($keyword)) {
                   $result = array_merge($result, self::doSplit($keyword));
                } else {
                   $result[] = trim(str_replace("\"", "", strip_tags($keyword))); 
                } 
            }
        } else {
            $keywords = preg_split("/" . self::SEPARATOR_SPLIT_PATTERN . "+|(" . self::SEPARATOR_SPLIT_PATTERN . "*(\r*\n+)+)+/", $keywords, -1, PREG_SPLIT_NO_EMPTY);
            foreach($keywords as $keyword) {
                $result[] = trim($keyword);
            } 
        }
        return $result;
    }
    
    public function setSeparator($separator = self::SEPARATOR_DEFAULT) {
        $this->separator = $separator;
    }

    public function setList($list, $separator = self::SEPARATOR_DEFAULT) {
        $this->words = self::doSplit($list);
        $this->setSeparator($separator);
    }

    public function appendList($list, $unique = true) {
        $this->words = array_merge($this->words, self::doSplit($list));
        if ($unique) {
            $this->words = array_unique($this->words);
        }        
    }

    public function getList($as_array = false) {
        return ($as_array) ? $this->words : implode($this->separator, $this->words);
    }

}

?>
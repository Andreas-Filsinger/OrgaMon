<?php

// repräsentiert und steuert das aktuell auszubelichtende HTML Dokument

class tsite {

    static public $title_separator = " : ";
    static private $deactivated_blocks = array();

    private $name = "";
    private $title = "";
    private $keywords = array();
    private $template = "";
    private $active = true;
    private $sitemap = false;
    private $content = true;
    private $components = array();
    private $step = 1;
    private $stepname = "";
    public $steps = array();
    private $_steps = array();
    private $autoplay = false;
    
    const CLASS_NAME = "PHP5CLASS T_SITE";

    public function __construct($name = "") {
        $this->name = $name;
    }

    //public function __sleep()
    //{ return array("name","title","step");
    //}

    public function activate() {
        $this->active = true;
    }

    public function deactivate() {
        $this->active = false;
    }

    public function isActive() {
        return $this->active;
    }

    public function set() {
        return ($this->getName() != "") ? true : false;
    }

    public function hasContent() {
        return $this->content;
    }

    public function setContent($content = true) {
        $this->content = $content;
    }

    public function activateStepByName($name) {
        $this->setStepActiveByName($name, true);
    }

    public function deactivateStepByName($name) {
        $this->setStepActiveByName($name, false);
    }

    /* --> 07.07.2014 michaelhacksoftware : AutoPlay für Artikel vormerken */
    public function getAutoPlay() {
        return $this->autoplay;
    }

    public function setAutoPlay() {
        $this->autoplay = true;
    }
    /* <-- */

    private function setStepActiveByName($name, $active) {
        foreach ($this->_steps as $index => $_step) {
            if ($_step->getName() == $name) {
                if ($active)
                    $this->_steps[$index]->doActivate();
                else
                    $this->_steps[$index]->doDeactivate();
            }
        }
        $this->buildActiveSteps();
    }

    public function buildActiveSteps() {
        $this->steps = array();
        foreach ($this->_steps as $_step) {
            if ($_step->isActive()) {
                $this->steps[] = $_step;
            }
        }
    }

    public function hasSteps() {
        return (count($this->steps) > 0) ? true : false;
    }

    public function setStep($step = 1) {
        if ($this->hasSteps()) {
            $this->step = $step;
            $this->appendTitle($this->getCurrentStep()->getTitle());
        }
    }

    public function setStepByName($name) {
        $step = $this->getStepByName($name);
        if ($step != 0) {
            $this->setStep($step);
            $this->setStepName($name);
        } else {
            $this->setStepName($name);
        }
    }

    private function setStepName($name) {
        $this->stepname = $name;
    }

    public function getStepName() {
        return $this->stepname;
    }

    public function getStep() {
        return $this->step;
    }

    public function getStepByName($name) {
        $step = 0;
        foreach ($this->steps as $tmp_step) {
            $step++;
            if ($tmp_step->getName() == $name) {
                unset($tmp_step);
                break;
            }
        }
        return $step;
    }

    public function incStep() {
        $this->setStep(($this->getStep() < count($this->steps)) ? $this->getStep() + 1 : $this->getStep());
    }

    public function decStep() {
        $this->setStep(($this->getStep() > 1) ? $this->getStep() - 1 : $this->getStep());
    }

    public function getCurrentStep() {
        return ($this->hasSteps()) ? $this->steps[$this->getStep() - 1] : NULL;
    }

    public function getCurrentStepFileName() {
        return "./site/" . $this->getName() . "_" . $this->getCurrentStep()->getName() . ".php";
    }

    public function setName($name) {
        $this->name = $name;
    }

    public function getName() {
        return $this->name;
    }

    public function setTitle($title) {
        $this->title = $title;
    }

    public function appendTitle($title, $separator = "") {
        $separator = ($separator != "") ? $separator : self::$title_separator;
        $this->title .= $separator . $title;
    }

    public function getTitle() {
        return $this->title;
    }

    static private function splitKeywords($keywords, $separator = ",") {
        if (is_array($keywords)) {
            $result = $keywords;
        } else {
            $result = preg_split("/$separator+|($separator*(\r*\n+)+)+/", $keywords, -1, PREG_SPLIT_NO_EMPTY);
        }
        return $result;
    }

    public function setKeywords($keywords, $separator = ",") {
        $this->keywords = self::splitKeywords($keywords, $separator);
    }

    public function appendKeywords($keywords, $separator = ",") {
        $this->keywords = array_merge($this->keywords, self::splitKeywords($keywords, $separator));
    }

    public function getKeywords($as_array = false) {
        if ($as_array) {
            return $this->keywords;
        } else {
            return ($this->keywords) ? implode(",", $this->keywords) : "";
        }
    }

    public function addToSiteMap() {
        $this->sitemap = true;
    }

    public function removeFromSiteMap() {
        $this->sitemap = false;
    }

    public function onSiteMap() {
        return $this->sitemap;
    }

    public function autoAddConstants() {
        if ($this->template != "") {
            $pattern = "/(~CONST_[a-zA-Z0-9_]*~)/";
            $split = preg_split($pattern, $this->template, -1, PREG_SPLIT_DELIM_CAPTURE);
            $wildcards = array_diff($split, preg_split($pattern, $this->template));
            foreach ($wildcards as $wildcard) {
                $name = tsite::getComponentNameMatchingWildCard($wildcard);
                $component = tsite::getConstantMatchingWildCard($wildcard);
                $this->addComponent($name, $component);
            }
        }
    }

    public function autoFillConstants() {
        if ($this->template != "") {
            $pattern = "/(~CONST_[a-zA-Z0-9_]*~)/";
            $split = preg_split($pattern, $this->template, -1, PREG_SPLIT_DELIM_CAPTURE);
            $wildcards = array_diff($split, preg_split($pattern, $this->template));
            foreach ($wildcards as $wildcard) { //$name = tsite::getComponentNameMatchingWildCard($wildcard);
                //$component = tsite::getConstantMatchingWildCard($wildcard);
                //$this->addComponent($name, $component);
                $this->template = str_replace($wildcard, tsite::getConstantMatchingWildCard($wildcard), $this->template);
            }
        }
    }

    public function addComponent($name, $component) {
        $this->components[$name] = $component;
    }

    public function appendComponent($name, $component) {
        if (!isset($this->components[$name])) {
            $this->addComponent($name, $component);
        } else {
            $this->components[$name] .= $component;
        }
    }

    public function parseTemplate($template) {
        if (strlen($template) > 0) {
            $B_TAG_OPEN = "<!-- BEGIN";
            $B_TAG_CLOSE = "-->";
            $b_len = strlen($B_TAG_OPEN);
            $E_TAG_OPEN = "<!-- END ";
            $E_TAG_CLOSE = " -->";

            $b_pos = 0;
            $e_pos = 0;
            $i = 0;
            do {
                $b_pos = strpos($template, $B_TAG_OPEN, min($b_pos + 1, strlen($template)));
                //var_dump($b_pos);
                if ($b_pos === false)
                    break;
                $i++;
                $type = trim(substr($template, strpos($template, " ", $b_pos + $b_len), strpos($template, "\r\n", $b_pos + $b_len + 1) - strpos($template, " ", $b_pos + $b_len)));
                $properties = new tstringlist(trim(substr($template, strpos($template, "\r\n", $b_pos + $b_len + 1) + 2, strpos($template, $B_TAG_CLOSE, $b_pos + $b_len + 1) - strpos($template, "\r\n", $b_pos + $b_len + 1) - 2)));

                //var_dump($properties);

                $e_len = strlen($E_TAG_OPEN . $type . $E_TAG_CLOSE);
                $e_pos = strpos($template, $E_TAG_OPEN . $type . $E_TAG_CLOSE, $b_pos + $b_len);
                //var_dump($e_pos);

                $html = substr($template, $b_pos, $e_pos + $e_len - $b_pos);

                switch ($type) {
                    case("PARAMS"): {
                            for ($i = 0; $i < $properties->count; $i++) {
                                $this->{urldecode($properties->getName($i))} = urldecode($properties->getValue($i));
                            }
                            $template = str_replace($html, "", $template);
                            break;
                        }
                    case("STEP"): {
                            $template = str_replace($html, "", $template);
                            $this->_steps[] = new tstep($properties->getValueByName("NAME"),
                                            $properties->getValueByName("TITLE"),
                                            $properties->getValueByName("DESCRIPTION"),
                                            $properties->getValueByName("ACTIVE")
                            );
                            end($this->_steps)->setTemplate($this->parseTemplate($html));
                            $this->buildActiveSteps();
                            //var_dump(end($this->steps));
                            break;
                        }
                    case("BLOCK"): {
                            $name = strtoupper($properties->getValueByName("NAME"));
                            if (in_array($name, self::$deactivated_blocks)) {
                                $template = str_replace($html, "<!-- DEACTIVATED: $name -->", $template);
                            }
                            unset($name);
                            break;
                        }
                    case("IMAGE"): { //echo $properties->getValueByName("SRC"). BR;
                            $template = str_replace($html, image_tag($properties->getValueByName("SRC"), $properties->getValueByName("ALT"), $properties->getValueByName("STYLE"), $properties->getValueByName("CLASS"), $properties->getValueByName("ID")), $template
                            );
                            break;
                        }
                    case("TEXT"): {
                            $template = str_replace($html, load_txt($properties->getValueByName("SRC"), $properties->getValueByName("!HTML2TXT"), $properties->getValueByName("!NL2BR")), $template
                            );
                            break;
                        }
                    case("RAW_TEXT"): {
                            $template = str_replace($html, load_raw_txt($properties->getValueByName("SRC")), $template);
                            break;
                        }
                }
            } while ($b_pos !== false);
        }
        return $template;
    }

    public function setTemplate($template) {
        if ($this->isActive() AND $this->hasContent()) {
            $this->template = $template;
            //$this->autoAddConstants();
            $this->autoFillConstants();
            //file_put_contents("template.txt",$this->template);
            $this->template = $this->parseTemplate($this->template);
        }
        return $this->template;
    }

    public function loadTemplate($path) {

        $envelop = file_get_contents($path . "envelope.html");
        $filename = $path . $this->getName() . ".html";

        if (file_exists($filename)) {
           
            $lines = file_get_contents($filename);
        } else {
            
            trigger_error("loadTemplate '" . $filename . "' fail", E_USER_WARNING);
            $lines = "";
        }
        
        $lines = str_replace("~CONTENT~",$lines, $envelop);
        $this->setTemplate($lines);
            
        if ($this->getStepName() != "") {
            $this->setStepByName($this->getStepName());
        }
    }

    private function buildTemplate() {
        switch (true) {
            case($this->hasSteps()): {
                    $template = str_replace("~TEMPLATE_STEP~", $this->getCurrentStep()->getFromHTMLTemplate(), $this->template);
                    break;
                }
            default: {
                    $template = $this->template;
                }
        }
        return $template;
    }

    public function getFromHTMLTemplate($template = "") {
        $html = ($template != "") ? $template : $this->buildTemplate();

        foreach ($this->components as $name => $component) {
            $html = str_replace("~$name~", $component, $html);
        }

        return $html;
    }

    public function __toString() {
        return $this->getName();
    }

    static private function getConstantMatchingWildCard($wildcard) {
        $_CONSTANT = str_replace("CONST_", "", tsite::getComponentNameMatchingWildCard($wildcard));
        return (defined($_CONSTANT)) ? constant($_CONSTANT) : $wildcard;
    }

    static private function getComponentNameMatchingWildCard($wildcard) {
        return str_replace("~", "", $wildcard);
    }

    static public function deactivateBlock($name) {
        self::$deactivated_blocks[] = strtoupper($name);
    }

    static public function deactivateBlocks($list, $separator = ",") {
        if (!is_array($list)) {
            $list = explode($separator, $list);
        }
        foreach ($list as $name) {
            self::deactivateBlock($name);
        }
    }

}

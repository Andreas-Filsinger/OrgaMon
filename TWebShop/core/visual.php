<?php
/*
 * 20.03.2011
 * NEU:  In den vererbten Klassen als "private" deklarierte Eigenschaften werden NICHT serialisiert 
 *       (und daher auch nicht mit in die Session übernommen)
 * NEU:  In dieser Klasse (tvisual) als "private" deklarierte WERDEN serialisiert
 * NEU:  Alle als "public" oder "protected" deklarierte Eigenschaften WERDEN serialisiert (wenn sie nicht mit "_" beginnen)
 * NEU:  Alle mit "_" beginnenden Eigenschaften werden (per Implementierung in __sleep()) NICHT serialisiert
 * ABER: Hier als "private" deklarierte Eigenschaften können in vererbten Klassen nicht mehr per __sleep() zur 
 *       Serialisierung gezwungen werden bzw. haben dann in der Serialisierung den Wert NULL
 * ALSO: Eigenschaften in dieser Klasse (tvisual) am besten immer als "protected" oder "public" deklarieren und 
 *       per "_" für die Serialisierung deaktivieren, falls in dieser unerwünscht
 * 
 */

abstract class tvisual {

    protected $_options = array();
    protected $_template = NULL;
    protected $_ttemplate = NULL;

    const CLASS_NAME = "PHP5CLASS_T_VISUAL";

    protected $CLASS_NAME = self::CLASS_NAME;
    //TS 05.12.2011: Die letzte Zeile ist wichtig zur Template-Unterscheidung, siehe unten,
    // (self::CLASS_NAME funktioniert nicht, da self auch bei Nachfahren immer PHP5CLASS_T_VISUAL liefert)
    //			   Allerdings wird diese Zeile nur in der obersten Parent-Klasse 
    //			   benötigt, in allen vererbten Klassen reicht const CLASS_NAME = "..." aus 

    static private $_template_selector = "";

    public function addOption($name, $template = "") {
        $name = strtoupper($name);
        $this->_options["$name"] = new toption($template);
    }

    public function clearOptions() { //unset($this->_options);
        $this->_options = array();
    }

    public function setHTMLTemplate($template) {
        if (is_object($template) AND is_a($template, "ttemplate")) {
            $this->_ttemplate = $template;
            $this->_template = ($this->_ttemplate->getTemplate(static::CLASS_NAME) != NULL) ? $this->_ttemplate->getTemplate(static::CLASS_NAME) : $this->_template;
            // Heilige Scheisse
            // wichtiger Unterschied zwischen PHP 5.3 und 5.4:
            // PHP 5.3: $this ist wie static::
            // PHP 5.4: $this ist wie self::
            // also muss man bei 5.4 oft $this-> durch static:: ersetzen
            // echo "{$this->CLASS_NAME}->setHTMLTemplate()<br />";
            // echo self::CLASS_NAME . "->setHTMLTemplate()<br />";
            // echo static::CLASS_NAME . "->setHTMLTemplate()<br />";
        } else {
            $this->_template = $template;
        }
           
        return $this->getHTMLTemplate();
    }

    public function clearHTMLTemplate() {
        $this->_ttemplate = NULL;
        $this->_template = NULL;
        //echo "{$this->_CLASS_NAME}->clearHTMLTemplate()<br />"
    }

    public function getHTMLTemplate() {
        if (is_array($this->_template)) {
            $index = 0;
            if (function_exists(self::$_template_selector)) {
                $index = call_user_func(self::$_template_selector, $this);
                if ($index > count($this->_template)) {
                    $index = 0;
                }
            }
            $template = $this->_template[$index];
            unset($index);
        } else {
            $template = $this->_template;
        }
        return $template;
    }

    public function getFromHTMLTemplate($template = NULL) {

        $template = ($template == NULL) ? $this->getHTMLTemplate() : $this->setHTMLTemplate($template);

        foreach ($this->_options as $name => $option) {
            $template = str_replace("~OPTION_$name~", $option->getFromHTMLTemplate($this->_ttemplate), $template);
            //echo $this->_CLASS_NAME . ": $name<br />" . CRLF;
        }
        return $template;
    }

    public function __sleep() {
        $sleep = array();
        foreach ($this as $name => $value) {
            while (true) {
                if (substr($name, 0, 1) == "_") {
/*
                    if (defined("SESSION_LOG"))
                        if (SESSION_LOG)
                            trigger_error("object-property '" . $name . "' supressed Session-Property", E_USER_NOTICE);
*/
                    break;
                }
                $sleep[] = $name;
                break;
            }
        }
        return $sleep;
    }

    public function __wakeup() {
        
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

    static public function setTemplateSelector($functionname) {
        self::$_template_selector = $functionname;
    }

}
?>
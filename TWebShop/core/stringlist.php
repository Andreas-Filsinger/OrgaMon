<?php

class tstringlist {

    protected $strings = array();
    protected $names = array();
    protected $values = array();
    protected $file = "";
    protected $index = 0;
    public $count = 0;

    const CLASS_NAME = "PHP5CLASS T_STRINGLIST";

    public function __construct($string = "", $file = "") {
        if ($string != "")
            $this->assignString($string);
        elseif ($file != "")
            $this->assignFile($file);
    }

    public function assignString($string, $separator = "(\r*\n+)+") {
        $this->strings = preg_split("/$separator/", $string, -1);
        //var_dump(preg_split("/$separator/",$string,-1));
        $this->build();
    }

    public function assignFile($filename) {
        $this->file = $filename;
        if (file_exists($filename)) {
            $this->assignString(file_get_contents($filename));
        }
    }

    public function addString($string) {
        $this->strings[] = $string;
        $this->build();
    }

    public function addStrings($strings) {
        if (is_array($strings)) {
            $this->strings = array_merge($this->strings, $strings);
        }
        $this->build();
    }

    public function addFile($filename, $separator = "(\r*\n+)+") {
        if (file_exists($filename)) {
            $this->addStrings(preg_split("/$separator/", file_get_contents($filename), -1));
        }
    }

    protected function build() {
        $this->count = count($this->strings);
        for ($i = 0; $i < $this->count; $i++) {
            $name_value = preg_split("/=/", $this->getString($i));
            if (count($name_value) == 2) {
                $this->names[$i] = $name_value[0];
                $this->values[$i] = $name_value[1];
            } else {
                $this->names[$i] = "";
                //$this->values[$i] = implode("",$name_value);
                $this->values[$i] = implode("=", $name_value);
            }
        }
    }

    public function getNext() {
        $this->incIndex();
        return $this->getString();
    }

    public function getPrevious() {
        $this->decIndex();
        return $this->getString();
    }

    public function getString($index = -1) {
        $index = ($index == -1) ? $this->index : $index;
        return $this->strings[$index];
    }

    public function getStrings() {
        return $this->strings;
    }

    public function getIndexByName($name) {
        return array_search($name, $this->names);
    }

    public function getValueByName($name) {
        $value = (($index = $this->getIndexByName($name)) === false ) ? "" : $this->getValue($index);
        return $value;
    }

    public function setValueByName($name, $value) {
        $index = $this->getIndexByName($name);
        if ($index !== false) {
            $this->values[$index] = $value;
            $this->strings[$index] = $name . "=" . $value;
        }
        else
            $this->addString($name . "=" . $value);
    }

    public function getName($index) {
        return $this->names[$index];
    }

    public function getValue($index) {
        return $this->values[$index];
    }

    public function getText($separator = "\r\n") {
        return implode($separator, $this->strings);
    }

    private function incIndex() {
        if ($this->index < ($this->count - 1))
            $this->index++;
        return $this->index;
    }

    private function decIndex() {
        if ($this->index > 0)
            $this->index--;
        return $this->index;
    }

    public function sortByValues($reverse = false) {
        if (!$reverse) {
            asort($this->values);
        } else {
            arsort($this->values);
        }
        $strings = array();
        foreach (array_keys($this->values) as $index) {
            $strings[$index] = $this->getName($index) . "=" . $this->getValue($index);
        }
        $this->strings = $strings;
        $this->build();
    }

    public function getFilename() {
        return $this->file;
    }

    public function writeFile($filename = "", $separator = "\r\n") {
        $filename = ($filename == "") ? $this->file : $filename;
        file_put_contents($filename, $this->getText($separator));
    }

    public function __toString() {
        return $this->getText();
    }

}
?>
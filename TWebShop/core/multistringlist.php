<?php

class tmultistringlist extends tstringlist {

    const CLASS_NAME = "PHP5CLASS T_MULTISTRINGLIST";

    //BUG: funktioniert nicht bei nur einer Zeile !!!
    protected function build() {
        $i = 0;
        $j = 0;
        $this->values[0] = "";
        foreach ($this->strings as $string) {
            $name_value = preg_split("/=/", $string);
            if (count($name_value) >= 2 AND !strpos($name_value[0], " ")) {
                $this->names[$i] = $name_value[0];
                $this->values[$i] = implode("=", array_slice($name_value, 1));
                $j = $i;
                $i++;
            } else {
                $this->values[$j].= "\r\n" . implode("=", $name_value);
            }
        }
        $this->count = $i;
        $this->strings = array();
        for ($i = 0; $i < $this->count; $i++) {
            $this->strings[$i] = $this->names[$i] . "=" . $this->values[$i];
        }
        //var_dump($this->strings);
    }

}
?>
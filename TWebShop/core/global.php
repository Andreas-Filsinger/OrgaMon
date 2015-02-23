<?php

// sicherheitsklöasse zur KOntrolle der url Parameter

define("T_VARIABLE_TYPE_STRING", 1);
define("T_VARIABLE_TYPE_INTEGER", 2);
define("T_VARIABLE_TYPE_FLOAT", 3);
define("T_VARIABLE_TYPE_ARRAY", 4);

class tglobal {

    public $name = "";
    public $type = "";
    private $value = NULL;
    private $value_original = NULL;
    private $value_filtered = NULL;
    private $value_typecast = NULL;
    private $valid = true;
    private $registered = false;
    private $validating = array();
    private $filtering = array();
    static public $_REGISTERED = array();

    const CLASS_NAME = "PHP5CLASS T_GLOBAL";

    public function __construct($name, $type, $filtering = array(), $validating = array()) {
        $this->name = $name;
        $this->type = $type;
        $this->filtering = $filtering;
        $this->validating = $validating;
    }

    public function register(&$errors = array()) {
        $this->registered = false;

        $_VAR = $this->name;

        $_GETNPOST = array_merge($_GET, $_POST);

        if (isset($_GETNPOST[$_VAR])) {
            global $$_VAR;
            $_VALUE = $_GETNPOST[$_VAR];
            $this->value_original = $_VALUE;

            //FILTER
            foreach ($this->filtering as $filter) { //$_VALUE = call_user_method("filter_".$filter, $this, $_VALUE);  //TS//03.08.2007//call_user_method is deprecated
                $_VALUE = call_user_func(array($this, "filter_" . $filter), $_VALUE);
            }

            $this->value_filtered = $_VALUE;

            //VALIDATION
            foreach ($this->validating as $validator => $error_message) { // $result = call_user_method("validate_".$validator, $this, $_VALUE); //TS//03.08.2007//call_user_method is deprecated
                $result = call_user_func(array($this, "validate_" . $validator), $_VALUE);
                if (!$result AND $error_message != NULL) {
                    $errors[] = $error_message;
                }
                $this->valid = $this->valid && $result;
            }

            switch ($this->type) {
                case(T_VARIABLE_TYPE_STRING) : {
                        $_VALUE = strval($_VALUE);
                        break;
                    }
                case(T_VARIABLE_TYPE_INTEGER): {
                        $_VALUE = intval($_VALUE);
                        break;
                    }
                case(T_VARIABLE_TYPE_FLOAT) : {
                        $_VALUE = floatval($_VALUE);
                        break;
                    }
                case(T_VARIABLE_TYPE_ARRAY) : {
                        break;
                    }
                default : {
                        $_VALUE = strval($_VALUE);
                        break;
                    }
            }

            $this->value_typecast = $_VALUE;

            $this->value = (count($this->validating) == 0 OR $this->valid) ? $this->value_typecast : $this->value_filtered;

            $$_VAR = $this->value;

            self::$_REGISTERED[] = $_VAR;
            $this->registered = true;
        }
        return $this->registered;
    }

    public function isRegistered() {
        return $this->registered;
    }

    public function getValue($default = NULL) {
        return ($this->isRegistered()) ? $this->value : $default;
    }

    public function isValid() {
        return $this->valid;
    }

    public function getValueOriginal($default = NULL) {
        return ($this->isRegistered()) ? $this->value_original : $default;
    }

    public function __toString() {
        return $this->value;
    }

    static public function validate_not_empty($var) {
        return !empty($var);
    }

    static public function validate_not_zero($num) {
        return ($num != 0) ? true : false;
    }

    static public function validate_numeric_int($num) {
        return preg_match("/^[0-9]+$/", $num);
    }

    static public function validate_numeric_float($num) {
        return is_numeric($num);
    }

    static public function validate_alpha_numeric($string) {
        return preg_match("/^[0-9a-zA-Z]*$/", $string);
    }

    static public function validate_phone($phone) {
        return preg_match("#^[+]{0,1}([0-9]+[ ]*)+$#", $phone);
    }

    static public function validate_mobile($number) {
        return preg_match("#^((\+[ ]*[[:digit:]]{2}[ ]*1)|01)#", $number);
    }

    static public function validate_password($pass) {
        return ((preg_replace("/\t*[ ]*/", "", $pass) == $pass) AND $pass != "") ? true : false;
    }

    static public function validate_email($email) {
        return preg_match("/^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@([a-zA-Z0-9]+[_a-zA-Z0-9-]+\.)+([a-zA-Z]{2,4})$/", $email);
    }

    static public function validate_url($url) {
        return true;
    }

    static public function validate_date($date) {
        return preg_match("/^[0-9]{2}.[0-9]{2}.[0-9]{4}$/", $date);
    }

    static public function validate_time($time) {
        return (preg_match("/^[0-9]{2}:[0-9]{2}:[0-9]{2}$/", $time) OR preg_match("/^[0-9]{2}:[0-9]{2}$/", $time));
    }

    /* --> 23.02.2015 michaelhacksoftware : BIC Überprüfung */
    static public function validate_bic($bic) {

        // Leerzeichen entfernen
        $bic = str_replace(' ', '', $bic);

        // Genau Länge prüfen: immer 8 oder 11
        if (strlen($bic) ==  8) return true;
        if (strlen($bic) == 11) return true;

        return false;

    }
    /* <-- */

    /* --> 23.02.2015 michaelhacksoftware : IBAN Überprüfung */
    static public function validate_iban($iban) {

        // Leerzeichen entfernen
        $iban = str_replace(' ', '', $iban);

        // Länge der IBAN prüfen
        if (strlen($iban) < 12) return false;
        if (strlen($iban) > 34) return false;

        // Landeskennzahl und Prüfziffern hinten anfügen
        $iban1 = substr($iban, 4)
               . strval(ord($iban{0}) - 55)
               . strval(ord($iban{1}) - 55)
               . substr($iban, 2, 2);

        // Buchstaben in ausländischen IBANs ersetzen
        for ($i = 0; $i < strlen($iban1); $i++) {
            if (ord($iban1{$i}) > 64 && ord($iban1{$i}) < 91) {
                $iban1 = substr($iban1, 0, $i) . strval(ord($iban1{$i}) - 55) . substr($iban1, $i + 1);
            }
        }

        // Prüfsumme mit Modulo 97-10 berechnen
        $rest = 0;

        for ($pos = 0; $pos < strlen($iban1); $pos += 7) {
            $part = strval($rest) . substr($iban1, $pos, 7);
            $rest = intval($part) % 97;
        }

        return ($rest == 1) ? true : false;
    }
    /* <-- */

    static private function filter_form_input($input) {
        $input = strip_tags($input);
        $input = stripslashes($input);
        return $input;
    }

    static private function filter_form_input_low($input) {
        $input = strtolower($input);
        $input = self::filter_form_input($input);
        return $input;
    }

    static private function filter_form_text($text) {
        $text = stripslashes($text);
        $text = addslashes($text);
        $text = strip_tags($text);
        $text = nl2br($text);
        return $text;
    }

    static private function filter_trim($str) {
        return trim($str);
    }

    static private function filter_ucwords($str) {
        return ucwords($str);
    }

    static private function filter_no_quotes($str) {
        return str_replace("\"", "", $str);
    }

}
?>
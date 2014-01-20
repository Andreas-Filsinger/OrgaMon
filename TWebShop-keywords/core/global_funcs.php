<?php

//Rev 1.006 (31.01.2011) Thorsten Schroff
//PROJEKT-SPEZIFISCH
function get_revision($infohtml = "", $path = "") {
    $rev = "0.000";
    $revision_txt = ($path == "") ? "revision.txt" : path_format($path, true, true) . "revision.txt";
    if (file_exists($revision_txt)) {
        $rev = trim(file_get_contents($revision_txt));
    } else {
        if ($infohtml == "") {
            $infohtml = __PROJECTNAME . "_Info.html";
        }
        if (file_exists($infohtml)) {
            $data = strip_tags(file_get_contents($infohtml));
            $lines = preg_split("/\r?\n/", $data);
            foreach ($lines as $key => $line) {
                $p = strpos(strtoupper($line), "REV.", 0);
                if ($p !== false) {
                    $line = trim($line);
                    break;
                }
            }
            $rev = substr($line, $p + 4 + 1, strlen($line) - $p - 4);
        }
    }
    return $rev;
}

function index($absolute = false) {
    return (!$absolute) ? path_format(basename($_SERVER["PHP_SELF"]), true) : ("http://" . $_SERVER["HTTP_HOST"] . $_SERVER["PHP_SELF"]);
}

$_INDEX = index();

function path() {
    return "http://" . $_SERVER["HTTP_HOST"] . pathinfo($_SERVER["PHP_SELF"], PATHINFO_DIRNAME) . "/";
}

//ALLGEMEIN
function null2zero($var) {
    return ($var == NULL) ? 0 : $var;
}

function null2str($var) {
    return ($var == NULL) ? "NULL" : $var;
}

function sort_array_by_object_property(&$array, $property, $reverse = false) {
    $tmp = array();
    foreach ($array as $index => $object) {
        $tmp[$index] = $object->{$property};
    }
    if (!$reverse)
        asort($tmp);
    else
        arsort($tmp);
    $indexs = array_keys($tmp);
    unset($tmp);
    $result = array();
    foreach ($indexs as $index)
        $result[$index] = $array[$index];
    $array = $result;
}

function arr_dump($arr) {
    if (is_array($arr)) {
        echo "(";
        foreach ($arr as $key => $value) {
            echo "$key => ";
            switch (true) {
                case (is_array($value)): arr_dump($value);
                    break;
                // case (is_object($value)): obj_dump($value); break;
                default: echo $value;
            }
            echo ", ";
        }
        echo ")";
    }
}

function obj_dump($obj) {
    if (is_object($obj)) {
        echo $obj, br_tag();
        $properties = get_object_vars($obj);
        foreach ($properties as $name => $value) {
            echo "$name: ";
            switch (true) {
                case (is_array($value)): arr_dump($value);
                    break;
                // case (is_object($value)): obj_dump($value); break;
                default: echo $value;
            }
            echo br_tag();
        }
    }
}

//TEXT
function load_txt($txt_file, $not_html2txt = false, $not_nl2br = false) {
    if (file_exists($txt_file)) {
        $result = rtrim_char(file_get_contents($txt_file), "\r\n");
        
        if (!$not_html2txt) {
            $result = htmlspecialchars($result, ENT_COMPAT, "UTF-8");
        }
        
        if (!$not_nl2br) {
            $result = nl2br($result);
        }
        
        
    } else {
        $result = "<p>Textdatei $txt_file wurde nicht gefunden !</p>";
    }
    return $result;
}

function include_txt($txt_file) {
    echo load_txt($txt_file);
}

function load_raw_txt($txt_file) {
    return (file_exists($txt_file)) ? htmlspecialchars(rtrim_char(file_get_contents($txt_file), "\r\n"),ENT_COMPAT,'UTF-8') :
            "Textdatei $txt_file wurde nicht gefunden !";
}

function include_raw_txt($txt_file) {
    echo load_raw_txt($txt_file);
}

//HTML-FORMATIERUNGEN
function image_size($filename) {
    $result = "";
    if (file_exists($filename)) {
        $size = getimagesize($filename);
        $result = $size[3];
    }
    return $result;
}

function image_tag($filename, $alt = "", $style = "", $class = "", $id = "") {
    if (file_exists($filename)) {
        if ($style != "") {
            $style = " style=\"$style\"";
        }
        if ($class != "") {
            $class = " class=\"$class\"";
        }
        if ($id != "") {
            $id = " id=\"$id\"";
        }
        $tag = "<img{$class}{$id} src=\"$filename\" border=\"0\" " . image_size($filename) . " alt=\"{$alt}\"{$style} hspace=\"0\" vspace=\"0\" />";
    }
    else
        $tag = "<p>Bilddatei $filename nicht gefunden !</p>";
    return $tag;
}

function image_show($filename, $alt = "", $style = "") {
    echo image_tag($filename, $alt, $style);
}

function anchor_tag($href, $innerHTML, $class = "") {
    if ($class == "") {
        $class = "standard";
    }
    if (strpos($href, "@") !== false) {
        $href = "mailto:" . $href;
    }
    $tag = "<a class=\"$class\" href=\"$href\">$innerHTML</a>";
    return $tag;
}

function br_tag() {
    return "<br />";
}

function bold_tag($innerHTML) {
    return "<b>" . $innerHTML . "</b>";
}

function span_tag($innerHTML, $class = "") {
    if ($class != "") {
        $class = "class=\"$class\"";
    }
    return "<span $class>$innerHTML</span>";
}

function select_tag($name, $options, $selected = 0, $assoc = false) {
    $html = "<select name=\"$name\">\r\n";
    foreach ($options as $value => $option) {
        if ($assoc) {
            $html.="<option value=\"" . $option . "\">" . $option . "</option>\r\n";
        } else {
            $html.="<option value=\"" . $value . "\">" . $option . "</option>\r\n";
        }
    }
    $html.= "</select>\r\n";
    return $html;
}

function br2nl($text, $crlf = "\r\n") { //TS: 17.11.2011: preg_replace mit /i-Modifier
    // return eregi_replace("(<br){1}( )*(/)?( )*(>)", $crlf, $text);
    return mb_eregi_replace("(<br){1}( )*(/)?( )*(>)", $crlf, $text);
}

function nbsp($text) {
    return str_replace(" ", "&nbsp;", $text);
}

//STRING-FORMATIERUNGEN
function quote($str) {
    return (strip_tags($str) != "") ? ("\"" . $str . "\"") : ($str);
}

function stripquotes($str) {
    return preg_replace("/['\"]/", "", $str);
}

function trim_inner_spaces($string) {
    return preg_replace("/\s+/", " ", $string);
}

function ltrim_char($str, $char = " ") {
    if ($char == " ") {
        return ltrim($str);
    } else {
        while (substr($str, 0, 1) == $char) {
            $str = substr($str, 1);
        }
        return $str;
    }
}

function rtrim_char($str, $char = " ") {
    if ($char == " ") {
        return rtrim($str);
    } else {
        while (substr($str, -1) == $char) {
            $str = substr($str, 0, strlen($str) - 1);
        }
        return $str;
    }
}

function trim_char($str, $char = " ") {
    if ($char == " ") {
        return trim($str);
    } else {
        return rtrim(ltrim($str, $char), $char);
    }
}

function cut_by($string, $length, $char = " ", $post = "...") {
    if (strlen($string) > $length) {
        $str = substr($string, 0, $length);
        $p = strrpos($str, $char);
        $str = substr($str, 0, $p) . $post;
    } else
        $str = $string;
    return $str;
}

function wrap($text, $wrapper = "*") {
    return $wrapper . $text . $wrapper;
}

function str_replace_next($needle, $replace, $haystack) {
    $result = $haystack;
    $start = strpos($haystack, $needle, 0);
    if ($start !== false) {
        $result = substr_replace($haystack, $replace, $start, strlen($needle));
    }
    return $result;
}

function bool2str($bool) {
    return ($bool) ? "true" : "false";
}

function str_replace_uml($string) {
    $result = $string;
    $result = str_replace("ä", "ae", $result);
    $result = str_replace("Ä", "Ae", $result);
    $result = str_replace("ö", "oe", $result);
    $result = str_replace("Ö", "Oe", $result);
    $result = str_replace("ü", "ue", $result);
    $result = str_replace("Ü", "Ue", $result);
    return $result;
}

//ZEIT/DATUM
function ISO2Unix($iso) {
    return mktime(intval(substr($iso, 11, 2)), intval(substr($iso, 14, 2)), intval(substr($iso, 17, 2)), intval(substr($iso, 5, 2)), intval(substr($iso, 8, 2)), intval(substr($iso, 0, 4)));
}

//MATHEMATISCH
function sign($number) {
    switch (true) {
        case ($number > 0): {
                $sign = 1;
                break;
            }
        case ($number < 0): {
                $sign = -1;
                break;
            }
        case ($number == 0): {
                $sign = 0;
                break;
            }
    }
    return $sign;
}

//PFADE,VERZEICHNISSE
function path_format($path, $leading_dots = false, $final_slash = false, $dot = ".", $slash = "/") {
    $path = trim($path);
    $path = ($slash == "/") ? str_replace("\\", $slash, $path) : str_replace("/", $slash, $path);

    switch (true) {
//absoluter Linux-Pfad -> führende Punkte unterdrücken        
        case(substr($path, 0, 1) == $slash): {
                $leading_dots = false;
                break;
            }
        //absoluter Windows-Pfad: mit Laufwerksangabe (:) -> führende Punkte unterdrücken    
        case(strpos($path, ":") !== false): {
                $leading_dots = false;
                break;
            }
    }

    if (substr($path, 0, 1) == $dot) { //Pfad beginnt mit Punkt -> relativer Pfad
        if (!$leading_dots) { //falls führende Punkte: NEIN
            $path = ltrim_char($path, "."); //führende Punkte unterdrücken
        }
    } else {  //Pfad beginnt nicht mit Punkt
        if (substr($path, 0, 1) != $slash) { //Pfad beginnt nicht mit Slash
            if ($leading_dots) { //führende Punkte: JA
                $path = $dot . $slash . $path; //Punkte und Slash anfügen
            } else { //führende Punkte: NEIN //nichts tun, Pfad ist eher relativ
            }
        }
    }

    //Slash am Ende
    $path = rtrim_char($path, $slash); //generell entfernen
    $path = ($final_slash AND $path != "") ? $path . $slash : $path; //anfügen, wenn gewünscht

    return $path;
}

//DATEIEN
function file_extension($filename, $case = 1, $dot = 0) { //$dot = strrpos($filename,".");
    //if ($dot !== false) $extension = substr($filename,$dot);
    //else $extension = "";
    $pathinfo = pathinfo($filename);
    $extension = array_key_exists("extension", $pathinfo) ? $pathinfo["extension"] : "";

    $result = ($case == 1) ? strtoupper($extension) : strtolower($extension);
    $result = ($dot == 1) ? ("." . $result) : $result;
    return $result;
}

function file_search($path, $regular_expression = "", $dirs = false) {
    $files = array();
    $path = path_format($path, true, true);
    $dir = opendir($path);
    //$dir = opendir(path_format($path,true,true)); 30.05.2009
    //echo path_format($path,true,true);
    while ($file = readdir($dir)) {
        if ($file != "." AND $file != ".." AND (!is_dir($path . $file) OR $dirs) AND ($regular_expression == "" OR preg_match("/" . $regular_expression . "/", $file))) { //ereg($regular_expression,$file)))
            $files[] = $file;
        }
    }
    closedir($dir);
    return $files;
}

function file_name_strip_invalid_characters($filename, $replace = "") {
    return preg_replace("#[<>?\":|\\\/*]#", $replace, $filename);
}

function file_get_lines($filename) {
    return preg_split("/(\r*\n+)+/", file_get_contents($filename));
}

function file_count_lines($filename) {
    return count(file_get_lines($filename));
}

function file_size_kB($file) {
    return floor(filesize($file) / 1024);
}

function file_size_MB($file) {
    return sprintf("%5.2f", filesize($file) / 1048576);
}

//USER-EINGABE-FILTER
function form_input_filter(&$input) {
    $input = strip_tags($input);
    $input = stripslashes($input);
}

function form_input_filter_low(&$input) {
    $input = strtolower($input);
    form_input_filter($input);
}

function form_text_filter(&$text) {
    $text = stripslashes($text);
    $text = addslashes($text);
    $text = strip_tags($text);
    $text = nl2br($text);
}

function check_pass($pass) {
    return ((preg_replace("/\t*[ ]*/", "", $pass) == $pass) AND $pass != "") ? true : false;
}

function check_numeric($num) {
    return preg_match("/^[0-9]+$/", $num);
    //return ereg("^[0-9]+$",$num); 
}

function check_date($date) {
    return preg_match("/^[0-9]{2}.[0-9]{2}.[0-9]{4}$/", $date);
    //return ereg("^[0-9]{2}.[0-9]{2}.[0-9]{4}$",$date);
}

function check_time($time, $seconds = false) {
    return ($seconds) ? preg_match("/^[0-9]{2}:[0-9]{2}:[0-9]{2}$/", $time) : preg_match("/^[0-9]{2}:[0-9]{2}$/", $time);
    //return ($seconds) ? ereg("^[0-9]{2}:[0-9]{2}:[0-9]{2}$",$time) : ereg("^[0-9]{2}:[0-9]{2}$",$time);
}

function check_phone($phone) {
    return preg_match("#^[+]{0,1}([0-9]+[ ]*)+$#", $phone);
    //return ereg("^[+]{0,1}([0-9]+[ ]*)+$",$phone); 
}

function check_mobile($number) {
    return preg_match("#^((\+[ ]*[[:digit:]]{2}[ ]*1)|01)#", $number);
    //return ereg("^((\+[ ]*[[:digit:]]{2}[ ]*1)|01)",$number);
}

function check_email($email) {
    return preg_match("/^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@([a-zA-Z0-9]+[_a-zA-Z0-9-]+\.)+([a-zA-Z]{2,4})$/", $email);
    //return ereg("^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@([a-zA-Z0-9]+[_a-zA-Z0-9-]+\.)+([a-zA-Z]{2,4})$",$email); 
}

function check_url($url) {
    return true;
}

function check_filename($filename) { //in Dateinamen verbotene Zeichen: < > ? " : | \ / *
    return !preg_match("#[<>?\":|\\\/*]#", $filename);
}

function check_url_http($url) {
    $parts = parse_url($url);
    return (isset($parts["scheme"]) AND $parts["scheme"] == "http") ? true : false;
}

function check_hex($hex) {
    return preg_match("/^0x([abcdef0123456789])*$/", strtolower($hex));
}
?>

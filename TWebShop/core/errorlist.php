<?php
define("DEFAULT_ERRORTITLE", "<b>Es sind Fehler aufgetreten:</b>");

class terrorlist {

    static private $instance = NULL;
    private $error_msg = array();
    private $title = "";
    private $color = "#000000";
    private $icon = false;
    private $template = "";
    public $error = false;

    const CLASS_NAME = "PHP5CLASS T_ERRORLIST";
    const GLOBAL_NAME = "errorlist";

    public function __construct($title = DEFAULT_ERRORTITLE, $color = "#000000", $icon = false, $template = "") {
        $this->title = $title;
        if ($color != "") {
            $this->color = $color;
        }
        $this->icon = $icon;
        $this->template = $template;
    }

    static public function create($title = DEFAULT_ERRORTITLE, $color = "#000000", $icon = false, $template = "") {
        if (!terrorlist::$instance) {
            terrorlist::$instance = new terrorlist($title, $color, $icon, $template);
        }
        return terrorlist::$instance;
    }

    public function add($msg) {
        if (is_array($msg)) {
            foreach ($msg as $line) {
                $this->error = true;
                $this->error_msg[] = $line;
            }
        } else {
            if (!$this->error) {
                trigger_error($msg, E_USER_WARNING);
                $this->error = true;
            }
            $this->error_msg[] = $msg;
        }
    }

    public function clear() {
        $this->error = false;
        $this->error_msg = array();
    }

    public function setTitle($title) {
        $this->title = $title;
    }

    public function setColor($color) {
        $this->color = $color;
    }

    public function setIcon($icon) {
        $this->icon = $icon;
    }

    public function setHTMLTemplate($template) {
        $this->template = $template;
    }

    public function getHTMLTemplate() {
        return $this->template;
    }

    public function getFromHTMLTemplate($list = "") {
        if ($this->error AND $this->template != "") {
            $html = $this->template;
            $html = str_replace("~TITLE~", (($this->title != "") ? $this->title : ""), $html);
            if ($this->icon != false) {
                $html = str_replace("~ICON~", image_tag($this->icon, "error"), $html);
            }
            if ($list == "") {
                $list = $this->getAsHTML();
            }
            $html = str_replace("~LIST~", $list, $html);
            return $html;
        }
        else
            return "<!-- no error -->";
    }

    public function getAsHTML() {
        if ($this->error) {
            $html = "";
            if ($this->title != "") {
                $html.= $this->title . CRLF;
            }
            $html.= "<ul style=\"color:{$this->color};\">" . CRLF;
            foreach ($this->error_msg as $msg) {
                $html.= "<li>$msg</li>" . CRLF;
            }
            $html.= "</ul>";
            return $html;
        }
        else
            return "<!-- no error -->";
    }

    public function getAsCustomHTML($pre = "-", $post = "<br />") {
        if ($this->error) {
            $html = "";
            foreach ($this->error_msg as $msg) {
                $html.= "<span style=\"color:{$this->color};\">" . $pre . $msg . $post . "</span>" . CRLF;
            }
            return $html;
        }
        else
            return "<!-- no error -->";
    }

    public function getAsArray() {
        if ($this->error) {
            return $this->error_msg;
        }
        else
            return false;
    }

    public function getAsString($separator = ",") {
        if ($this->error) {
            return implode($separator, $this->error_msg);
        }
        else
            return false;
    }

    public function __wakeup() {
        self::$instance = $this;
    }

    public function __toString() {
        return $this->getAsString();
    }

}
?>
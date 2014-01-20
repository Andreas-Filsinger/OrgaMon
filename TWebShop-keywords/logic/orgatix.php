<?php

// In diesem Skript definierte Klassen:
// * torgatix bildet das komplette System ab
// * torgatix_ticket bildet ein Ticket ab
// * torgatix_processor bildet den Bearbeiter ab

class torgatix extends tvisual {

    private $tickets = array();
    private $processors = array();

    const TABLE = TABLE_TICKET;
    const TYPE = 15;
    const CLASS_NAME = "PHP5CLASS T_ORGATIX";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct() {
        $this->readTickets();
    }

    private function readTickets() {

        global $ibase;

        $ids = $ibase->get_list_as_array("SELECT RID FROM " . self::TABLE . " WHERE " .
                " (ART=" . self::TYPE . ") and " .
                " not(AKTION STARTS WITH 'Ablage')" .
                " ORDER BY PRIORITAET DESCENDING, MOMENT");
        foreach ($ids as $id) {
            $this->tickets[$id] = new torgatix_ticket($id);
        }
    }

    private function readProcessors() {


        global $ibase;

        $ids = $ibase->get_list_as_array("SELECT RID FROM " . TABLE_PROCESSOR . " ORDER BY USERNAME");
        foreach ($ids as $id) {
            $this->processors[$id] = new torgatix_processor($id);
        }
    }

    public function getTickets() {
        if (count($this->tickets) == 0) {
            $this->readTickets();
        }
        return $this->tickets;
    }

    public function getProcessors() {
        if (count($this->processors) == 0) {
            $this->readProcessors();
        }
        return $this->processors;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $processors = "";
        foreach ($this->processors as $processor) {
            $processors .= $processor->getFromHTMLTemplate($this->ttemplate);
        }

        $tickets = "";
        foreach ($this->tickets as $ticket) {
            $tickets .= $ticket->getFromHTMLTemplate($this->ttemplate);
        }

        $template = str_replace("~PROCESSORS~", $processors, $template);
        $template = str_replace("~TICKETS~", $tickets, $template);

        unset($tickets);
        unset($processors);
        return $template;
    }

}

class torgatix_ticket extends tvisual {

    static public $properties = array("PAPERCOLOR", "PRIORITAET", "MOMENT", "AKTION", "INFO", "BEARBEITER_R", "PERSON_R", "VERFASSER");
    static public $db_fields = array("TICKET.PAPERCOLOR", "TICKET.PRIORITAET", "TICKET.MOMENT", "TICKET.AKTION", "TICKET.INFO", "TICKET.BEARBEITER_R", "TICKET.PERSON_R", "PERSON.VORNAME||PERSON.NACHNAME as VERFASSER");
    private $rid = 0;
    private $priority_string = "";
    private $priority_level = -1;
    private $processor = NULL;
    private $action = NULL;
    private $info = NULL;

    const PRIORITY_LEVEL_HIGH = WORD_HIGH;
    const PRIORITY_LEVEL_MIDDLE = WORD_MIDDLE;
    const PRIORITY_LEVEL_LOW = WORD_LOW;
    const PAPERCOLOR_HIGH = "FF0000";
    const PAPERCOLOR_MIDDLE = "FFFF00";
    const PAPERCOLOR_LOW = "00FF00";
    const TABLE = TABLE_TICKET;
    const CLASS_NAME = "PHP5CLASS T_ORGATIX_TICKET";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct($id = 0) {
        $this->rid = $id;
        if ($this->rid != 0) {
            $this->getProperties();
            $this->buildPriority();
            $this->getProcessor();
        } else {
            $this->PAPERCOLOR = hexdec(self::PAPERCOLOR_LOW);
            $this->setPriority(0);
            $this->MOMENT = date("m-d-Y H:i:s");
            $this->AKTION = "";
            $this->INFO = "";
            $this->BEARBEITER_R = 0;
            $this->PERSON_R = 0;
            $this->VERFASSER = "";
        }
    }

    public function getProperties() {


        global $ibase;

        $ibase->query(" SELECT " . implode(",", self::$db_fields) .
                " FROM " . self::TABLE .
                " LEFT JOIN PERSON " .
                " ON (TICKET.PERSON_R=PERSON.RID) " .
                " WHERE (TICKET.RID={$this->rid})");
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
    }

    public function setID($id) {
        $this->rid = $id;
    }

    public function getID() {
        return $this->rid;
    }

    public function getInfo() {

        global $ibase;
        if ($this->info == NULL) {
            if ($this->INFO != "") {

                $this->info = new tstringlist();
                $this->info->assignString($ibase->get_blob($this->INFO, 4096));
            }
        }
        return $this->info;
    }

    public function getAction() {

        global $ibase;
        if ($this->action == NULL) {
            if ($this->AKTION != "") {
                $this->action = new tstringlist();
                $this->action->assignString($ibase->get_blob($this->AKTION, 4096));
            }
        }
        return $this->action;
    }

    public function getProcessor() {
        if ($this->BEARBEITER_R != 0) {
            $this->processor = new torgatix_processor($this->BEARBEITER_R);
        } else {
            $this->processor = new torgatix_processor();
        }
        return $this->processor;
    }

    public function getPriorityLevel() {
        return $this->priority_level;
    }

    public function setAuthor($person_r) {
        $this->PERSON_R = $person_r;
    }

    public function setProcessor($bearbeiter_r) {
        $this->BEARBEITER_R = $bearbeiter_r;
        return $this->getProcessor();
    }

    public function setInfo($info) {
        $this->info = new tstringlist();
        $this->info->assignString($info);
    }

    public function setAction($action) {
        $this->action = new tstringlist();
        $this->action->assignString($action);
    }

    public function setPriority($priority) {
        $this->PRIORITAET = intval($priority);
        switch (true) {
            case($priority >= 0 AND $priority < 10): {
                    $this->PAPERCOLOR = hexdec(self::PAPERCOLOR_LOW);
                    break;
                }
            case($priority >= 10 AND $priority < 20): {
                    $this->PAPERCOLOR = hexdec(self::PAPERCOLOR_MIDDLE);
                    break;
                }
            case($priority >= 20 AND $priority < 30): {
                    $this->PAPERCOLOR = hexdec(self::PAPERCOLOR_HIGH);
                    break;
                }
        }
        $this->buildPriority();
    }

    public function buildPriority() {
        switch (true) {
            case($this->PRIORITAET >= 0 AND $this->PRIORITAET < 10): {
                    $this->priority_string = self::PRIORITY_LEVEL_LOW;
                    $this->priority_level = 0;
                    break;
                }
            case($this->PRIORITAET >= 10 AND $this->PRIORITAET < 20): {
                    $this->priority_string = self::PRIORITY_LEVEL_MIDDLE;
                    $this->priority_level = 1;
                    break;
                }
            case($this->PRIORITAET >= 20 AND $this->PRIORITAET < 30): {
                    $this->priority_string = self::PRIORITY_LEVEL_HIGH;
                    $this->priority_level = 2;
                    break;
                }
        }
        return $this->priority_string;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~AKTION_FIRST_LINE~", ($this->action != NULL) ? $this->action->getString(0) : "", $template);
        $template = str_replace("~AKTION_TEXT~", ($this->action != NULL) ? $this->action->getText() : "", $template);
        $template = str_replace("~BEARBEITER_R~", $this->BEARBEITER_R, $template);
        $template = str_replace("~MOMENT~", str_replace("-", ".", $this->MOMENT), $template);
        $template = str_replace("~MOMENT_DATE~", tibase::date($this->MOMENT, "."), $template);
        $template = str_replace("~MOMENT_TIME~", tibase::time($this->MOMENT), $template);
        $template = str_replace("~PAPERCOLOR~", $this->PAPERCOLOR, $template);
        $template = str_replace("~PAPERCOLOR_HEX~", torgamon::getHTMLColor($this->PAPERCOLOR), $template);
        $template = str_replace("~PERSON_R~", $this->PERSON_R, $template);
        $template = str_replace("~PRIORITAET~", $this->PRIORITAET, $template);
        $template = str_replace("~PRIORITY_STRING~", $this->priority_string, $template);
        $template = str_replace("~PRIORITY_LEVEL~", $this->priority_level, $template);
        $template = str_replace("~PROCESSOR~", ($this->processor != NULL) ? $this->processor->getFromHTMLTemplate($this->ttemplate) : "", $template);
        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~INFO_FIRST_LINE~", ($this->info != NULL) ? $this->info->getString(0) : "", $template);
        $template = str_replace("~INFO_TEXT~", ($this->info != NULL) ? $this->info->getText() : "", $template);
        $template = str_replace("~VERFASSER~", $this->VERFASSER, $template);


        return $template;
    }

    public function insertIntoDataBase() {

        global $ibase;

        $info = stripquotes(html_entity_decode($this->info->getText(), ENT_NOQUOTES));
        $action = stripquotes(html_entity_decode($this->action->getText(), ENT_NOQUOTES));
        $result = $ibase->insert("INSERT INTO " . self::TABLE . " " .
                "(ART,PAPERCOLOR,PRIORITAET,MOMENT,INFO,AKTION,BEARBEITER_R,PERSON_R) VALUES " .
                "(" . torgatix::TYPE . ",{$this->PAPERCOLOR},{$this->PRIORITAET},'{$this->MOMENT}','{$info}','{$action}',{$this->BEARBEITER_R},{$this->PERSON_R})");
        return $result;
    }

    public function updateInDataBase() {

        global $ibase;
        $info = stripquotes(html_entity_decode($this->info->getText(), ENT_NOQUOTES));
        $action = stripquotes(html_entity_decode($this->action->getText(), ENT_NOQUOTES));

        $result = $ibase->exec("UPDATE " . self::TABLE . " SET " .
                "PAPERCOLOR={$this->PAPERCOLOR},PRIORITAET={$this->PRIORITAET},INFO='$info',AKTION='$action',BEARBEITER_R={$this->BEARBEITER_R} " .
                "WHERE RID={$this->getID()}");

        return $result;
    }

}

class torgatix_processor extends tvisual {

    static public $properties = array("FARBE_HINTERGRUND", "FARBE_VORDERGRUND", "KUERZEL", "NAME", "STATUS", "USERNAME");
    private $rid = 0;
    private $state = NULL;

    const COLOR_FRONT = "000000";
    const COLOR_BACK = "FFFFFF";
    const TABLE = TABLE_PROCESSOR;
    const CLASS_NAME = "PHP5CLASS T_ORGATIX_PROCESSOR";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct($id = 0) {
        $this->rid = $id;
        if ($this->rid != 0) {
            $this->getProperties();
        } else {
            $this->FARBE_HINTERGRUND = hexdec(self::COLOR_BACK);
            $this->FARBE_VORDERGRUND = hexdec(self::COLOR_FRONT);
            $this->KUERZEL = "";
            $this->NAME = "";
            $this->STATUS = "";
            $this->USERNAME = "";
        }
    }

    public function getProperties() {


        global $ibase;
        
        $ibase->query("SELECT " . implode(",", self::$properties) . " FROM " . self::TABLE . " WHERE RID={$this->rid}");
        $data = $ibase->fetch_object();
        $ibase->free_result();
        foreach (self::$properties as $name) {
            $this->{$name} = $data->{$name};
        }
    }

    public function getID() {
        return $this->rid;
    }

    public function getState() {

        global $ibase;
        if ($this->state == NULL) {
            if ($this->STATUS != "") {

                $this->state = new tstringlist();
                $this->state->assignString($ibase->get_blob($this->STATUS, 4096));
            }
        }
        return $this->action;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~FARBE_HINTERGRUND~", $this->FARBE_HINTERGRUND, $template);
        $template = str_replace("~FARBE_HINTERGRUND_HEX~", torgamon::getHTMLColor($this->FARBE_HINTERGRUND), $template);
        $template = str_replace("~FARBE_VORDERGRUND~", $this->FARBE_VORDERGRUND, $template);
        $template = str_replace("~FARBE_VORDERGRUND_HEX~", torgamon::getHTMLColor($this->FARBE_VORDERGRUND), $template);
        $template = str_replace("~KUERZEL~", $this->KUERZEL, $template);
        $template = str_replace("~NAME~", trim($this->NAME), $template);
        $template = str_replace("~RID~", $this->rid, $template);
        $template = str_replace("~STATUS~", $this->STATUS, $template);
        $template = str_replace("~STATUS_TEXT~", ($this->state != NULL) ? $this->state->getText() : "", $template);
        $template = str_replace("~USERNAME~", trim($this->USERNAME), $template);

        return $template;
    }

}
?>

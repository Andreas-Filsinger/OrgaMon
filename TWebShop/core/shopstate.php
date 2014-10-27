<?php

//
// Im Shopstate Objekt wird der Status der Anwendung durchgetragen
// Mann kann also z.B. zunächst eine Login-Funktion erzwingen, bis
// dann der Benutzer in der eigentlich Angefragten Seite landet. Dabei wird
// der Ursprüngliche Request nach "vars" serialisiert. Später wird wohl
// erkannt, dass da eigentlich was anderes geplant war, und die Werte werden
// wieder entserialisiert

class tshopState {

    public $id = 0;
    public $action_id = 0;
    public $current_site = "";
    public $last_site = "";
    public $vars = array();

    const CLASS_NAME = "PHP5CLASS T_SHOP";

    public function __construct($id) {
        $this->id = $id;
    }

    public function getID() {
        return $this->id;
    }

    public function setSite($site) {
        if ($site != $this->current_site) {
            $this->last_site = $this->current_site;
            $this->current_site = $site;
        }
        return $this->current_site;
    }

    public function getCurrentSite() {
        return $this->current_site;
    }

    public function getLastSite() {
        return $this->last_site;
    }

    public function setActionID($action_id = 0) {
        $this->action_id = $action_id;
    }

    public function getActionID() {
        return $this->action_id;
    }

    public function getNextActionID() {
        return $this->action_id + 1;
    }

    public function clearVars($context = "") {
        if ($context == "")
            $this->vars = array();
        else
            $this->vars[$context] = array();
    }

    public function saveVar($context, $_VAR, $_VALUE) {
        $this->vars[$context][$_VAR] = serialize($_VALUE);
    }

    public function saveVars($context, $_VARS) {
        $this->clearVars($context);
        foreach ($_VARS as $_VAR) {
            global $$_VAR;
            if (isset($$_VAR))
                $this->saveVar($context, $_VAR, $$_VAR);
        }
    }

    public function loadVars($context) {
        if (array_key_exists($context, $this->vars)) {
            foreach ($this->vars[$context] as $_VAR => $_VALUE) {
                global $$_VAR;
                $$_VAR = unserialize($_VALUE);
                
        if (defined("STATEFULL_LOG"))
            if (STATEFULL_LOG)
                fb($_VAR . ":=" . $$_VAR,"Action",FirePHP::INFO);
            
                if ($_VAR == "aid")
                    $$_VAR = $this->action_id + 1;
            }
            $this->clearVars($context);
        }
    }

    public function loadVarsIfDontExist($context) {
        if (array_key_exists($context, $this->vars)) {
            foreach ($this->vars[$context] as $_VAR => $_VALUE) {
                global $$_VAR;
                if (!isset($$_VAR))
                    $$_VAR = unserialize($_VALUE);
            }
            $this->clearVars($context);
        }
    }

    public function getVars($context = "") {
        $result = false;
        if (array_key_exists($context, $this->vars)) {
            $result = $this->vars[$context];
        }
        if ($context == "") {
            $result = $this->vars;
        }
        return $result;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
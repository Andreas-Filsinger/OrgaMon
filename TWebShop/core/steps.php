<?php

/* AF: unbenutzt?
 * 
class tsteps {

    private $steps = array();
    private $index = 1;
    public $count = 0;
    private $site = "";
    private $context = "";
    static public $_CLASS_NAME = "PHP5CLASS T_STEPS";

    public function __construct($site, $context = "") {
        $this->site = $site;
        $this->context = $context;
    }

    public function getStepIndex() {
        return $this->index;
    }

    public function addStep($name, $title, $description = "") {
        $this->steps[] = new tstep($name, $title, $description);
        $this->count = count($this->steps);
    }

    public function getStep($index) {
        $result = false;
        if ($this->count != 0 AND $index <= $this->count AND $index > 0) {
            $result = $this->steps[$index - 1];
        }
        return $result;
    }

    public function getCurrentStep() {
        return $this->getStep($this->index);
    }

    public function getCurrentStepFileName() {
        $name = $this->getCurrentStep()->getName();
        return "./site/{$this->site}_$name.php";
    }

    public function clear() {
        $this->steps = array();
        $this->count = 0;
        $this->index = -1;
    }

    public function setStep($index) {
        if ($this->count != 0 AND $index <= $this->count AND $index > 0) {
            $this->index = $index;
        }
        return $this->index;
    }

    public function prevStep() {
        if ($this->count != 0 AND $this->index > 1) {
            $this->index--;
        }
        return $this->index;
    }

    public function nextStep() {
        if ($this->count != 0 AND $this->index < $this->count) {
            $this->index++;
        }
        return $this->index;
    }

}
*/

class tstep {

    private $name = "";
    private $title = "";
    private $description = "";
    private $active = true;
    private $template = "";
    private $components = array();

    const CLASS_NAME = "PHP5CLASS T_STEP";

    public function __construct($name, $title, $description = "", $active = "Y") {
        $this->name = $name;
        $this->title = $title;
        $this->description = $description;
        $this->active = ($active == "N") ? false : true;
    }

    public function getName() {
        return $this->name;
    }

    public function getTitle() {
        return $this->title;
    }

    public function getDescription() {
        return $this->description;
    }

    public function doActivate() {
        $this->active = true;
    }

    public function doDeactivate() {
        $this->active = false;
    }

    public function isActive() {
        return $this->active;
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

    public function setTemplate($template) {
        $this->template = $template;
    }

    public function getFromHTMLTemplate($template = "") {
        $html = ($template != "") ? $template : $this->template;

        foreach ($this->components as $name => $component) {
            $html = str_replace("~$name~", $component, $html);
        }

        $html = str_replace("~DESCRIPTION~", $this->description, $html);
        $html = str_replace("~NAME~", $this->name, $html);
        $html = str_replace("~TITLE~", $this->title, $html);

        return $html;
    }

    public function __toString() {
        return $this->getName();
    }

}
?>
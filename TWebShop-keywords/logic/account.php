<?php

class twebshop_account extends tvisual {

    private $person_r = 0;
    private $value = 0.00;
    private $positive = "";
    private $negative = "";
    private $balanced = "";
    private $string = "";

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ACCOUNT";

    public function __construct($person_r = 0) {
        $this->person_r = $person_r;
        $this->getAccountInfo();
    }

    private function getAccountInfo() {
        
        global $orgamon;
        if ($this->person_r != 0) {
            $this->value = 0.00;

            $this->value = $orgamon->getAccountInfo($this->person_r);
        }
        switch (true) {
            case($this->value > 0.00): {
                    $this->positive = twebshop_price::toCurrency($this->value);
                    break;
                }
            case($this->value < 0.00): {
                    $this->negative = twebshop_price::toCurrency($this->value);
                    break;
                }
            case($this->value == 0.00): {
                    $this->balanced = twebshop_price::toCurrency($this->value);
                    break;
                }
            default: {
                    $string = "unknown";
                }
        }
        return $this->value;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~BALANCED~", $this->balanced, $template);
        $template = str_replace("~POSITIVE~", $this->positive, $template);
        $template = str_replace("~NEGATIVE~", $this->negative, $template);
        $template = str_replace("~STRING~", $this->string, $template);
        $template = str_replace("~VALUE~", $this->value, $template);

        return $template;
    }

}
?>

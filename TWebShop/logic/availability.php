<?php

//**** KLASSE ZUR ABBILDUNG DER ARTIKEL **********************************************************************************************
class twebshop_availability extends tvisual {

    protected $article_r = 0;
    protected $version_r = 0;
    protected $status = 0;
    protected $string = "";
    protected $days = 0;
    protected $quantity = 0;
    protected $date = "";
    protected $timestamp = 0;
    protected $age = 0;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_AVAILABILITY";
    const MAX_AGE = 300; //in Sekunden
    
    public function __construct($article_r, $version_r) {
        $this->doUpdate($article_r, $version_r);
    }

    public function needsUpdate($article_r, $version_r) {
        $result = true;
        switch (true) {
            case($this->article_r != $article_r): break;
            case($this->version_r != $version_r): break;
            case((time() - $this->age) > self::MAX_AGE): break;
            default: $result = false;
        }
        return $result;
    }

    public function doUpdate($article_r, $version_r) {
        
        global $orgamon;
        $this->article_r = $article_r;
        $this->version_r = $version_r;

        $this->age = time();
        $this->status = $orgamon->getAvailability($this->version_r, $this->article_r);
        //echo $this->status;

        $this->evaluateStatus();
    }

    public function evaluateStatus() { // DEBUG $this->status = 20060313;
        switch (true) {
            case ($this->status < 10): {
                    switch ($this->status) {
                        case (0): {
                                $this->string = SENTENCE_NO_INFORMATION;
                                break;
                            } // GELB
                        case (1): {
                                $this->string = SENTENCE_PERMANENTLY_OUT_OF_PRINT;
                                break;
                            } 
// ROT
                        case (2): {
                                $this->string = SENTENCE_TEMPORARILY_OUT_OF_PRINT;
                                break;
                            } // ROT
                        case (3): {
                                $this->string = SENTENCE_TEMPORARILY_OUT_OF_PRINT;
                                break;
                            } // ROT
                        case (4): {
                                $this->string = SENTENCE_AVAILABLE_IMMEDIATELY_BY_EMAIL;
                                break;
                            } // GRUEN
                        case (5): {
                                $this->string = SENTENCE_AVAILABLE_IMMEDIATELY_VIA_DOWNLOAD;
                                break;
                            } // GRUEN
                    }
                    break;
                }
            case ($this->status < 101): // GRUEN 
        {
                    $this->days = $this->status - 10;
                    $this->string = $this->getDaysString();
                    $this->timestamp = mktime(0, 0, 0) + $this->days * 24 * 3600;
                    break;
                }
            case ($this->status < 10000000):{ 
// GRUEN - kleiner als die kleinste 8-stellige Zahl = kein Datum = Menge {
                    $this->quantity = $this->status - 100;
                    //26.04.2007 $this->string = str_replace("~QUANTITY~",$this->quantity,VARIABLE_SENTENCE_X_INSTANCES_AVAILABLE);
                    $this->string = SENTENCE_ON_HAND;
                    $this->timestamp = mktime(0, 0, 0);
                    break;
                }
            case ($this->status > 20000000): // GRUEN - müsste ein Datum sein 
        {
                    $this->date = substr("{$this->status}", 6, 2) . "." . substr("{$this->status}", 4, 2) . "." . substr("{$this->status}", 0, 4);
                    $this->string = $this->date;
                    $this->timestamp = mktime(0, 0, 0, substr("{$this->status}", 4, 2), substr("{$this->status}", 6, 2), substr("{$this->status}", 0, 4));
                    break;
                }
        }
    }

    public function getStatus() {
        return $this->status;
    }

    public function getTimestamp() {
        return $this->timestamp;
    }

    public function getQuantity() {
        return $this->quantity;
    }

    private function getDaysString() {
        switch (true) {
            case($this->days == 0): {
                    $string = SENTENCE_AVAILABLE_TODAY;
                    break;
                }
            case($this->days == 1): {
                    $string = SENTENCE_AVAILABLE_TOMORROW;
                    break;
                }
            default: {
                    $string = str_replace("~DAYS~", $this->days, VARIABLE_SENTENCE_AVAILABLE_IN_X_DAYS);
                }
        }
        return $string;
    }

    public function getFromHTMLTemplate($template = NULL) {
        $template = parent::getFromHTMLTemplate($template);

        $template = str_replace("~DATE~", $this->date, $template);
        $template = str_replace("~DAYS~", $this->days, $template);
        $template = str_replace("~STATUS~", $this->status, $template);
        $template = str_replace("~STRING~", $this->string, $template);

        return $template;
    }

    public function __toString() {
        return twebshop_availability::$name;
    }
    
    public function __wakeup() {
        parent::__wakeup();
    }

}
?>
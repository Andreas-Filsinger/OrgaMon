<?php

//**** KLASSE ZUR ABBILDUNG DES PREISES **********************************************************************************************
class twebshop_price extends tvisual {

    protected $article_r = 0;
    protected $person_r = 0;
    protected $flat_netto = 0.00;
    protected $sum_netto = 0.00;
    protected $sum_brutto = 0.00;
    protected $string = "";
    protected $percent = 0;
    protected $is_netto = 0;
    protected $netto_is_brutto = 0;
    protected $value = 0;

    const TYPE_PRICE = 1;
    const TYPE_FREE = 0;
    const TYPE_OUTOFPRINT = -1;
    const TYPE_ONREQUEST = -2;
    const TYPE_UNKNOWN = -3;

    public $type = self::TYPE_UNKNOWN;
    static public $types = array(
        self::TYPE_PRICE => "",
        self::TYPE_FREE => SENTENCE_FREE_OF_CHARGE,
        self::TYPE_OUTOFPRINT => SENTENCE_OUT_OF_PRINT,
        self::TYPE_ONREQUEST => SENTENCE_ON_REQUEST,
        self::TYPE_UNKNOWN => WORD_UNKNOWN
    );
    private $currency = "";

    const CURRENCY = "&euro;";
    const CLASS_NAME = "PHP5CLASS_T_WEBSHOP_PRICE";

    public function __construct($article_r = 0, $version_r = 0, $person_r = 0, $quantity = 1) {

        $this->article_r = $article_r;
        $this->currency = (defined("DEFAULT_CURRENCY")) ? DEFAULT_CURRENCY : self::CURRENCY;
        if ($this->article_r != 0) {
            $this->resetValues($version_r, $person_r, $quantity);
        }
    }

    public function resetValues($version_r, $person_r, $quantity = 1) {

        global $orgamon;
        if ($version_r == NULL) {
            $version_r = 0;
        }
        $this->person_r = $person_r;

        $price = $orgamon->getPrice($version_r, $this->article_r, $person_r);

        $this->buildValues($price, $quantity);
    }

    protected function buildValues($price, $quantity = 1) {
        if (is_array($price)) {
            list($value, $this->percent, $this->is_netto, $this->netto_is_brutto) = $price;
        }
        else
            $value = -3.00;

        switch (true) {
            case($value == 0.00) : {
                    $this->type = self::TYPE_FREE;
                    break;
                }
            case($value == -1.00) : {
                    $this->type = self::TYPE_OUTOFPRINT;
                    break;
                }
            case($value == -2.00) : {
                    $this->type = self::TYPE_ONREQUEST;
                    break;
                }
            case($value == -3.00) : {
                    $this->type = self::TYPE_UNKNOWN;
                    break;
                }
            default: {
                    $this->type = self::TYPE_PRICE;
                    break;
                }
        }

        $this->value = $value;

        $this->flat_netto = ($this->type == self::TYPE_PRICE) ? $this->value : 0.00;
        $this->sum_netto = $quantity * $this->flat_netto;
        $this->sum_brutto = (100 - $this->percent) / 100 * $this->sum_netto;

        $this->string = twebshop_price::$types[$this->type];
    }

    public function getFlatNetto() {
        return $this->flat_netto;
    }

    public function getPercent() {
        return $this->percent;
    }
    
    public function getSumNetto() {
        return $this->sum_netto;
    }

    public function getSumBrutto() {
        return $this->sum_brutto;
    }

    public function setCurrency($currency = "") {
        if ($currency == "") {
            $currency = (defined("DEFAULT_CURRENCY")) ? DEFAULT_CURRENCY : self::CURRENCY;
        }
        $this->currency = $currency;
    }

    public function getCurrency() {
        return $this->currency;
    }

    public function getFromHTMLTemplate($template = NULL) {

        $template = parent::getFromHTMLTemplate($template);
        $template = str_replace("~FLAT_NETTO~", ($this->type == self::TYPE_PRICE) ? twebshop_price::toCurrency($this->flat_netto, $this->currency) : "", $template);
        $template = str_replace("~PERCENT~", ($this->type == self::TYPE_PRICE) ? sprintf("%.2f %%", $this->percent) : "", $template);
        $template = str_replace("~PERCENT_RAW~", ($this->type == self::TYPE_PRICE) ? $this->percent : "", $template);
        $template = str_replace("~PERSON_R~", $this->person_r, $template);
        $template = str_replace("~STRING~", $this->string, $template);
        $template = str_replace("~SUM_NETTO~", ($this->type == self::TYPE_PRICE) ? twebshop_price::toCurrency($this->sum_netto) : "", $template);
        $template = str_replace("~SUM_BRUTTO~", ($this->type == self::TYPE_PRICE) ? twebshop_price::toCurrency($this->sum_brutto) : "", $template);
        $template = str_replace("~VALUE~", $this->value, $template);

        return $template;
    }

    public function __sleep() {
        return array_merge(array("article_r", "person_r", "flat_netto", "sum_netto", "sum_brutto", "string", "percent", "is_netto", "netto_is_brutto"), parent::__sleep());
    }

    static public function toCurrency($value, $currency = "") {
        if ($currency == "") {
            $currency = (defined("DEFAULT_CURRENCY")) ? DEFAULT_CURRENCY : self::CURRENCY;
        }
        return sprintf("%5.2f", $value) . "&nbsp;" . $currency;
    }

}

class twebshop_delivery extends twebshop_price {

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_DELIVERY";

    public function setValues($value, $percent = 0.00, $is_netto = 0, $netto_is_brutto = 0) {
        $this->buildValues(array($value, $percent, $is_netto, $netto_is_brutto));
    }

}
?>
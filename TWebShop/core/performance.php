<?php
 
class tperformance {

    static private $instance = NULL;
    static private $time_started = 0.0;
    private $tokens = array();

    const TOKEN_NAME = "self";
    const CLASS_NAME = "PHP5CLASS T_PERFORMANCE";

    public function __construct($time_started) {
        $time_started = ($time_started == 0.0 AND self::$time_started != 0.0) ? self::$time_started : $time_started;
        $this->addToken(self::TOKEN_NAME, $time_started);
    }

    static public function create($time_started = 0.0) {
        if (self::$instance == NULL) {
            self::$instance = new tperformance($time_started);
        }
        return self::$instance;
    }

    private function formatTokenName($name) {
        return strtoupper($name);
    }

    public function getTimeNeededBy($name) {
        $name = $this->formatTokenName($name);
        return (array_key_exists($name, $this->tokens)) ? $this->tokens[$name]->getTimeNeeded() : false;
    }

    public function getTimeStartedOf($name) {
        $name = $this->formatTokenName($name);
        return (array_key_exists($name, $this->tokens)) ? $this->tokens[$name]->getTimeStarted() : false;
    }

    public function getTimeNeeded() {
        return $this->getTimeNeededBy(self::TOKEN_NAME);
    }

    public function getTimeStarted() {
        return $this->getTimeStartedOf(self::TOKEN_NAME);
    }

    public function addToken($name, $time_started = 0.0, $time_needed = 0.0) {
        $name = $this->formatTokenName($name);
        $this->tokens[$name] = new tperformance_token($name, $time_started, $time_needed);
    }

    public function getAllTokens() {
        $tokens = "";
        foreach (array_keys($this->tokens) as $name) {
            $tokens .= $this->tokens[$name]->getAsString() . "\r\n";
        }
        return $tokens;
    }

    static public function getTime() {
        return microtime(true);
    }

    static public function setTimeStarted() {
        self::$time_started = self::getTime();
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}

class tperformance_token {

    static private $scale = 1000;
    private $name = "";
    private $time_started = 0.0;
    private $time_stopped = 0.0;
    private $time_needed = 0.0;

    const CLASS_NAME = "PHP5CLASS T_PERFORMANCE_TOKEN";

    public function __construct($name, $time_started = 0.0, $time_needed = 0.0) {
        $this->name = $name;
        $this->time_started = ($time_started == 0.0) ? self::getTime() : $time_started;
        $this->time_needed = $time_needed;
    }

    public function getTimeNeeded() {
        if ($this->time_needed == 0.0) {
            $this->time_stopped = self::getTime();
            $this->time_needed = ($this->time_stopped - $this->time_started);
        }
        return $this->time_needed * self::$scale;
    }

    public function getTimeStarted() {
        return $this->time_started * self::$scale;
    }

    public function getTimeStopped() {
        return $this->time_stopped * self::$scale;
    }

    public function resetTimeNeeded() {
        $this->time_needed = 0.0;
    }

    public function getAsString() {
        $this->getTimeStopped();
        return "{$this->name}: {$this->time_needed}";
    }

    static private function getTime() {
        return microtime(true);
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
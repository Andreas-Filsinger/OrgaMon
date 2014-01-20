<?php
// TXMLRPC CLASS, PHP5
// by Thorsten Schroff, 2011

define("XMLRPC_DEFAULT_PORT", 3049);
define("XMLRPC_DEFAULT_PATH", "");
define("XMLRPC_DEFAULT_USER", ""); // bisher keine Authentifizierung nötig / möglich
define("XMLRPC_DEFAULT_PASSWORD", ""); // bisher keine Authenifizierung nötig / möglich
define("XMLRPC_DEFAULT_NAMESPACE", "abu");

// TS 23-04-2012: wie oft wird nach dem ersten Fehlschlagen wiederholt? Wert 2 bedeutet: insgesamt 3 Versuche
define("XMLRPC_DEFAULT_TIMEOUT", 20);

// wird ein XMLRPC Server als "bad" markiert
// wird er für die hier angegebene Zeit als "schlecht" markiert
// in dieser Zeit werden seine Dienste nicht mehr in Anspruch 
// genommen. Erst nach verstreichen dieser Zeit wird ein
// erneuter Verbindungsversuch unternommen.
define("XMLRPC_RECOVERY_TIME", 120);

//
define("XMLRPC_DEFAULT_RETRIES", 2);
define("XMLRPC_DEFAULT_LOG", "xmlrpc.log");

require_once("semipersistent_sequence.php");

class thost {

    private $name = "";
    private $port = NULL;
    private $path = "";
    private $user = "";
    private $password = "";
    private $timeout = 0;
    private $retries = 0;

    const CLASS_NAME = "PHP5CLASS T_HOST";

    public function __construct($name, $port, $path, $user, $password, $timeout, $retries) {
        $this->name = $name;
        $this->port = intval($port);
        $this->path = $path;
        $this->user = $user;
        $this->password = $password;
        $this->setTimeout($timeout);
        $this->setRetries($retries);
    }

    public function setTimeout($timeout) {
        $this->timeout = intval($timeout);
    }

    public function setRetries($retries) {
        $this->retries = intval($retries);
    }

    public function getName() {
        return $this->name;
    }

    public function getPort() {
        return $this->port;
    }

    public function getConnect() {
        return $this->name . ":" . $this->port;
    }

    public function getPath() {
        return $this->path;
    }

    public function getUser() {
        return $this->user;
    }

    public function getPassword() {
        return $this->password;
    }

    public function getTimeout() {
        return $this->timeout;
    }

    public function getRetries() {
        return $this->retries;
    }

}

class txmlrpc {

    const CRLF = "\r\n";
    const BLOCK_SIZE = 32768;
    const CLASS_NAME = "PHP5CLASS T_XMLRPC";
    const GLOBAL_NAME = "xmlrpc";

    static public function encodeString($s) {
        // OrgaMon XMLRPC is "Ansi"
        return htmlentities(iconv("UTF-8", "ISO-8859-1//TRANSLIT", $s));
    }

    static public function encodeRequest($method, $params) {
        $xml = new DOMDocument();
        $x_methodCall = $xml->createElement("methodCall");
        //echo $method;
        $x_methodName = $xml->createElement("methodName");
        $x_methodName->appendChild($xml->createTextNode($method));
        $x_params = $xml->createElement("params");
        if ($params == NULL) {
            $x_param = $xml->createElement("param");
            $x_value = $xml->createElement("value");
            $x_type = $xml->createElement("string");
            $x_value->appendChild($x_type);
            $x_param->appendChild($x_value);
            $x_params->appendChild($x_param);
        }
        if (is_array($params)) {
            foreach ($params as $param) {
                $x_param = $xml->createElement("param");
                $x_value = $xml->createElement("value");
                switch (true) {
                    case(is_int($param)) : {
                            $x_type = $xml->createElement("int");
                            break;
                        }
                    case(is_double($param)): {
                            $x_type = $xml->createElement("double");
                            break;
                        }
                    case(is_string($param)): {
                            $x_type = $xml->createElement("string");
                            break;
                        }
                    case(is_array($param)) : {
                            $x_type = $xml->createElement("array");
                            break;
                        }
                    case(is_object($param)): {
                            $x_type = $xml->createElement("object");
                            break;
                        }
                    case(is_bool($param)) : {
                            $x_type = $xml->createElement("boolean");
                            break;
                        }
                    default: {
                            $xtype = $xml->createElement("unknown type");
                            break;
                        }
                } // switch
                $x_type->appendChild($xml->createTextNode(txmlrpc::encodeString($param)));
                $x_value->appendChild($x_type);
                $x_param->appendChild($x_value);
                $x_params->appendChild($x_param);
            }
        }
        $x_methodCall->appendChild($x_methodName);
        $x_methodCall->appendChild($x_params);
        $xml->appendChild($x_methodCall);
        return $xml->saveXML();
    }

    static private function getAsPHPVariable($xml_var) {
        switch ($xml_var->nodeName) {
            case("array"): {
                    $xml = new DOMDocument();
                    $xml->appendChild($xml->importNode($xml_var, true));
                    $xp = new DOMXPath($xml);
                    $php_var = array();
                    foreach ($xp->query("//array/data/value/child::*") as $xml_var)
                        $php_var[] = self::getAsPHPVariable($xml_var);
                    unset($xml);
                    unset($xp);
                    break;
                }
            case("string"): {
                    $php_var = strval($xml_var->nodeValue);
                    break;
                }
            case("int"): {
                    $php_var = intval($xml_var->nodeValue);
                    break;
                }
            case("double"): {
                    $php_var = doubleval($xml_var->nodeValue);
                    break;
                }
            case("boolean"): {
                    $php_var = (intval($xml_var->nodeValue) == 0) ? false : true;
                    break;
                }
            default: {
                    $php_var = "return type unknown";
                    break;
                }
        }
        return $php_var;
    }

    static public function encodeResponse($xml) {
        $xml = DOMDocument::loadXML(utf8_encode($xml));
        try {
            $xp = new DOMXPath($xml);
            $xml_vars = $xp->query("//params/param/value/child::*");
            switch ($xml_vars->length) {
                case(0): {
                        $result = NULL;
                        break;
                    }
                case(1): {
                        $result = self::getAsPHPVariable($xml_vars->item(0));
                        break;
                    }
                default: {
                        $result = array();
                        foreach ($xml_vars as $xml_var)
                            $result[] = self::getAsPHPVariable($xml_var);
                        break;
                    }
            }
        } catch (Exception $e) {
            $result = NULL;
        }
        return $result;
    }

    static public function decodeResponse($xml) {
        $xml = DOMDocument::loadXML(utf8_encode($xml));
        try {
            $xp = new DOMXPath($xml);
            $xml_vars = $xp->query("//params/param/value/child::*");
            switch ($xml_vars->length) {
                case(0): {
                        $result = NULL;
                        break;
                    }
                case(1): {
                        $result = self::getAsPHPVariable($xml_vars->item(0));
                        break;
                    }
                default: {
                        $result = array();
                        foreach ($xml_vars as $xml_var)
                            $result[] = self::getAsPHPVariable($xml_var);
                        break;
                    }
            }
        } catch (Exception $e) {
            $result = NULL;
        }
        return $result;
    }

    static public function crlf($n = 1) {
        $crlf = "";
        for ($i = 0; $i < $n; $i++)
            $crlf .= self::CRLF;
        return $crlf;
    }

}

class txmlrpc_client {

    // Public
    public $xml_request = "";
    public $xml_response = "";
    public $xml_host = "";
    public $error = false;
    public $gaveUp = false;
    public $errno = 0;
    public $errstr = "";
    public $logCALL = false;
    private $hosts = array(); // TS 09-05-2012: array of thost
    private $method = "";
    private $params = "";
    private $xml = "";
    private $php = NULL;

    const CLASS_NAME = "PHP5CLASS T_XMLRPC_CLIENT";

    // error_chain: (Fehlerkette) Speichert Infos über Probleme, 
    // die in der Lebenszeit des Objektes aufgetreten sind. Erreicht das
    // Objekt einen kritischen Fehlerstatus wird die ganze Fehlerkette 
    // ausgegeben
    public $error_chain = array();
    private $time_sub_method_level = 0;
    private $time_started = 0.0;
    private $time_stopped = 0.0;
    private $time_needed = 0.0;

    private function addProblem($msg) {
        $this->error_chain[] = $msg;
    }

    private function fatalError($msg) {

        global $errorlist;
        $this->gaveUp = true;
        $errorlist->add($this->error_chain);
        $errorlist->add($msg);
    }

    public function addHost(
    $host, $port = XMLRPC_DEFAULT_PORT, $path = XMLRPC_DEFAULT_PATH, $user = XMLRPC_DEFAULT_USER, $password = XMLRPC_DEFAULT_PASSWORD, $timeout = XMLRPC_DEFAULT_TIMEOUT, $retries = XMLRPC_DEFAULT_RETRIES) {
        if (is_string($host)) {
            $this->hosts[] = new thost($host, $port, $path, $user, $password, $timeout, $retries);
        }
        if (is_object($host)) {
            $this->hosts[] = $host;
        }
    }

    private function markHostAsBad($id) {

        semiPersistentBrand($this->hosts[$id]->getConnect(), XMLRPC_RECOVERY_TIME);
    }

    private function isBadHost($id) {

        return semiPersistentIsKnown($this->hosts[$id]->getConnect());
    }

    // Listet alle Hosts auf, die im Moment
    // als "bad" also nicht funktionierend
    // gelistet sind.
    public function badHosts() {
        $r = array();
        $c = count($this->hosts);
        $i = 0;
        while ($i < $c) {
            if ($this->isBadHost($i))
                $r[] = $this->hosts[$i]->getConnect();
            $i++;
        }
        return implode(",", $r);
    }

    public function getHosts() {

        $r = array();
        $c = count($this->hosts);
        $i = 0;
        while ($i < $c)
            $r[] = $this->hosts[$i++]->getConnect();
        return implode(",", $r);
    }

    /*
      private function buildID() { //die ersten 8 Zeichen eines MD5?
      //mit was wird der md5 gefüttert? Methodenname und Parameter, Datum, Uhrzeit, Remote-IP? Letzteres wäre ziemlich eindeutig.
      $this->id = strtoupper(substr(md5($this->getID() . "_" . $this->getMethod() . "_" . date("Y-m-d H:i:u") . "_" . $_SERVER["REMOTE_ADDR"]), 0, 8));
      return $this->id;
      }

      public function getID() {
      return $this->id;
      }
     */

    private function setMethod($method = "") {
        $this->method = $method;
    }

    public function getMethod() {
        return $this->method;
    }

    private function setParams($params) {
        $this->params = $params;
    }

    private function getParams() {
        return $this->params;
    }

    private function getHeader($h) {
        $auth = "";
        if ($h->getUser() != "") {
            $auth = "Authorization: Basic " . base64_encode($h->getUser() . ":" . $h->getPassword()) . txmlrpc::crlf();
        }
        $header = "POST {$h->getPath()} HTTP/1.0" . txmlrpc::crlf() . "User-Agent: " . self::CLASS_NAME . txmlrpc::crlf() . "Host: {$h->getName()}" . txmlrpc::crlf() .
                "{$auth}Content-Type: text/xml" . txmlrpc::crlf() . "Content-Length: " . strlen($this->xml) . txmlrpc::crlf(2);
        return $header;
    }

    private function cutHeader($payload) { //var_dump($payload);
        $pos = strpos($payload, txmlrpc::crlf(2) . "<?xml", 1);
        if ($pos !== false) {
            $this->xml_response = substr($payload, $pos + strlen(txmlrpc::crlf(2)));
        } else {
            $this->setLogicError(102, "Keine Antwort");
            $this->xml_response = "";
        }
        return $this->xml_response;
    }

    private function toXML() {
        /* xmlrpc ist leider immer noch "experimentell"
          if (in_array("xmlrpc", get_loaded_extensions())) {
          $this->xml_request = xmlrpc_encode_request($this->method, $this->params);
          } else {
          $this->xml_request = txmlrpc::encodeRequest($this->method, $this->params);
          }
         */
        $this->xml_request = txmlrpc::encodeRequest($this->method, $this->params);
        //echo "<pre>" . htmlentities($this->xml_request) . "</pre>";
        return $this->xml_request;
    }

    private function fromXML() { //echo "<pre>" . htmlentities($this->xml) . "</pre>";
        /* xmlrpc ist leider immer noch "experimentell"
          if (in_array("xmlrpc", get_loaded_extensions())) {
          $this->php = xmlrpc_decode_request($this->xml, $this->method);
          } else {
          $this->php = txmlrpc::decodeResponse($this->xml);
          } */
        $this->php = txmlrpc::decodeResponse($this->xml);
        return $this->php;
    }

    private function overHTTP($timeout) {

        global $errorlist;
        $result = false;
        $c = count($this->hosts);
        $this->resetLogicError();

        while (true) {

            if ($c == 0) {
                $errorlist->add("xmlrpc_client: no good hosts left - at all");
                break;
            }

            // Bestimmung des XMLRPC-Servers, der dieses Mal angesprochen werden soll
            if ($c == 1) {

                // Wenn es nur einen gibt macht es keinen Sinn
                // den isBad Status zu prüfen, in dem Fall bleibt keine
                // Alternative, wir müssen es halt nochmal versuchen
                $active = 0;
                  
            } else {
                $i = 0;
                while ($i++ <= $c) {
                    $active = getSemiPersistentSequence() % $c;
                    if (!$this->isBadHost($active))
                        break;
                    if ($i == $c) {
                        $this->fatalError("xmlrpc_client: no good hosts left");
                        return false;
                    }
                }
            }
            $h = $this->hosts[$active];

            $server = $h->getName();
            $port = $h->getPort();
            $timeout = ($timeout == 0) ? $h->getTimeout() : $timeout;
            $retries = $h->getRetries();

            $try = 0;
            while (($result == false) AND ($try++ <= $retries)) {

                // open tcp connection
                $fp = null;
                $fp = @fsockopen($server, $port, $errno, $errstr, max($timeout, 1));
                if (!$fp) {
                    $this->addProblem("fsockopen(" . $server . ":" . $port . ") returned error code " . $errno);
                    continue;
                }

                // build request
                $payload = $this->getHeader($h) . $this->xml;

                // send request
                if (!@fwrite($fp, $payload, strlen($payload))) {
                    $this->addProblem("fwrite(" . $server . ":" . $port . ") failed ");
                    @fclose($fp);
                    continue;
                }

                // read response
                $result = "";
                @stream_set_timeout($fp, max($timeout, 1));
                while ($data = @fread($fp, txmlrpc::BLOCK_SIZE))
                    $result .= $data;

                // response problems?
                $info = @stream_get_meta_data($fp);
                if ($info["timed_out"]) {
                    $this->addProblem("fread(" . $server . ":" . $port . ") gave up after $timeout seconds");
                    @fclose($fp);
                    continue;
                }
                @fclose($fp);
            }

            if (($result === false) or ($result === "")) {
                $this->markHostAsBad($active);
            } else {
                $this->xml_host = $server;
                break;
            }
        };

        return $result;
    }

    public function sendRequest($method, $params = "", $timeout = 0) {


        if ($this->logCALL) {
            if (is_array($params))
               fb($method . "(" . implode(",", $params) . ")","xmlrpc-call",FirePHP::INFO);
            else
               fb($method . "(" . $params . ")","xmlrpc-call",FirePHP::INFO);
        }

        $this->startTime();

        if ($this->gaveUp)
            return NULL;

        if ($method != "") {
            $this->setMethod($method);
            if ($params != "") {
                $this->setParams($params);
            }
            //$this->buildID();
            //$this->addToLog("START / ID: " . $this->getID() . " / METHOD: " . $method . " / PARAMCOUNT: " . count($this->getParams()));
            $this->xml = $this->toXML();
            $response = $this->overHTTP($timeout);
        } else {
            $this->setLogicError(800, "Es wurde keine Methode angegeben");
            $response = false;
        }

        if ($response == false) {
            $result = NULL;
            //echo "NULL";
        } else {
            $this->xml = $this->cutHeader($response);
            if ($this->xml == "") {
                $result = NULL;
            } else {
                $result = $this->fromXML();
                if (is_array($result) AND array_key_exists("faultCode", $result)) {
                    $this->setLogicError($result["faultCode"], $result["faultString"]);
                    $result = NULL;
                }
            }
        }

        $this->stopTime();
        //$this->addToLog("STOP  / ID: " . $this->getID() . " / METHOD: " . $method . " / XMLCOUNT: " . strlen($this->xml) . " / TRIES: " . $try . " / NEEDED: " . $this->getTime());
        return $result;
    }

    private function setLogicError($no, $str) {
        $this->error = true;
        $this->errno = $no;
        $this->errstr = $this->method . "() returns errorcode " . $no . "(" . $str . ")";
    }

    private function resetLogicError() {
        $this->error = false;
        $this->errno = 0;
        $this->errstr = "";
    }

    private function startTime() {
        if ($this->time_sub_method_level == 0) {
            $this->time_started = microtime(true);
        }
        $this->time_sub_method_level++;
    }

    private function stopTime() {
        $this->time_sub_method_level--;
        if ($this->time_sub_method_level == 0) {
            $this->time_stopped = microtime(true);
            $this->time_needed += $this->time_stopped - $this->time_started;
        }
    }

    public function getTime() {
        return $this->time_needed;
    }

    public function addToLog($entry) {
        if (!empty($this->log)) {
            $entry = date("d-m-Y H:i:s") . " --- " . $entry . txmlrpc::crlf();
            file_put_contents($this->log, $entry, FILE_APPEND);
        }
    }

    /*
     * AF: bin nicht der Ansicht dass xmlrpc in die Session sollte
      public function __wakeup() {
      self::$instance = $this;
      //$this->time_started = 0.0;
      //$this->time_stopped = 0.0;
      //$this->time_needed  = 0.0;
      }

      public function __toString() {
      return self::CLASS_NAME;
      }
     * 
     */

    public function __wakeup() {
        trigger_error("someone try to create " . self::CLASS_NAME . " from session", E_USER_NOTICE);
    }

}
?>

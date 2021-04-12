<?php
/*
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Thorsten Schroff
  |    Copyright (C) 2015  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
 */

//
// TXMLRPC CLASS, PHP5
//

// Parameter Defaults
define("XMLRPC_DEFAULT_PORT", 3049);
define("XMLRPC_DEFAULT_TIMEOUT_OPEN", 2);
define("XMLRPC_DEFAULT_TIMEOUT_READ", 20);
define("XMLRPC_DEFAULT_RETRIES", 2);

define("XMLRPC_DEFAULT_NAMESPACE", "abu");

// wird ein XMLRPC Server als "bad" markiert wird er für die 
// hier angegebene Zeit als "schlecht" markiert. In dieser Zeit
// werden seine Dienste global nicht mehr in Anspruch genommen.
// Erst nach Verstreichen dieser Zeit wird ein erneuter Verbindungsversuch
// unternommen.
define("XMLRPC_RECOVERY_TIME", 25);

//
// in der Regel ist CRLF bereits definiert
//
#define("CRLF","\r\n");

require_once("semipersistent_sequence.php");

class tserver_identity {

    public $host = "";
    public $port = NULL;
    public $timeout_open = 0;
    public $timeout_read = 0;
    public $retries = 0;

    public function __construct(
     $host,
     $port = XMLRPC_DEFAULT_PORT,
     $timeout_open = XMLRPC_DEFAULT_TIMEOUT_OPEN,
     $timeout_read = XMLRPC_DEFAULT_TIMEOUT_READ,
     $retries = XMLRPC_DEFAULT_RETRIES) {

        $this->host = $host;
        $this->port = intval($port);
        $this->timeout_open = intval($timeout_open);
        $this->timeout_read = intval($timeout_read);
        $this->retries = intval($retries);
    }
    
    static public function rConnectStr($host, $port) {
    
        return $host . ":" . $port;
    } 

    public function setDefaults() {
    
       $this->port = XMLRPC_DEFAULT_PORT;
       $this->timeout_open = XMLRPC_DEFAULT_TIMEOUT_OPEN;
       $this->timeout_read = XMLRPC_DEFAULT_TIMEOUT_READ;
       $this->retries = XMLRPC_DEFAULT_RETRIES;
    }

    public function ConnectStr() {
    
        return tserver_identity::rConnectStr($this->host,$this->port);
    }

    public function __wakeup() {
        trigger_error("someone try to create " . self::CLASS_NAME . " from session", E_USER_NOTICE);
    }
}

class txmlrpc {

    const BLOCK_SIZE = 32768;
    const CLASS_NAME = "PHP5CLASS T_XMLRPC";
    const GLOBAL_NAME = "xmlrpc";

    static public function encodeString($s) {
        // OrgaMon XMLRPC is "Ansi"
        return htmlentities(iconv("UTF-8", "ISO-8859-1//TRANSLIT", $s));
    }

    static public function encodeRequest($method, $params) {

	$xml = "<?xml version=\"1.0\"?>" . CRLF;

	if ($params==NULL) {

	  return $xml . "<methodCall><methodName>" . $method . "</methodName></methodCall>";
		 
    } else
	{

        if (is_array($params)) {

            $xml .= "<methodCall><methodName>" . $method . "</methodName><params>" . CRLF;
			
            foreach ($params as $param) {
				
                switch (true) {
                    case(is_int($param)) : {
                            $type = "int";
                            break;
                        }
                    case(is_double($param)): {
                            $type = "double";
                            break;
                        }
                    case(is_string($param)): {
                            $type = "string";
                            break;
                        }
                    case(is_bool($param)) : {
                            $type = "boolean";
                            break;
                        }
                    default: {
                            trigger_error("xmlrpc_client: can not encode " . var_dump($param));
                            break;
                        }
                } 
				
				$xml .= "<param><value><" . $type . ">" . txmlrpc::encodeString($param) . "</" . $type . "></value></param>" . CRLF;
            }
            return $xml . "</params></methodCall>";
        } else {
            trigger_error("xmlrpc_client: \$params is no array, nothing to call");
			return $xml;
		}
	}
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

    public function __wakeup() {
        trigger_error("someone try to create " . self::CLASS_NAME . " from session", E_USER_NOTICE);
    }
}

class txmlrpc_client {

    public $lastServer = ""; // store the last good server
	public $error = false;
    public $gaveUp = false;
    public $errno = 0;
    public $errstr = "";
    public $logCALL = false;

    private $hosts = array(); //  array of tserver_identity
    private $method = "";
    private $params = "";
    private $xml = "";

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
        trigger_error($msg);
        $this->error_chain[] = $msg;
    }

    private function fatalError($msg) {

        global $errorlist;
        $this->gaveUp = true;
        $errorlist->add($this->error_chain);
        $errorlist->add($msg);
    }

    public function add($host) {

        $this->hosts[] = $host;
    }

    private function markHostAsBad($id) {

        trigger_error("XMLRPC-Server " . $this->hosts[$id]->ConnectStr() . " branded", E_USER_WARNING);
        semiPersistentBrand($this->hosts[$id]->ConnectStr(), XMLRPC_RECOVERY_TIME);
    }

    private function isBadHost($id) {

      if (defined("XMLRPC")) {
       return false;
     } else {  
        return semiPersistentIsKnown($this->hosts[$id]->ConnectStr());
     }   
    }

    // Listet alle Hosts auf, die im Moment
    // als "bad" also nicht funktionierend
    // gelistet sind.
    public function badHosts() {
        $r = array();
        $c = count($this->hosts);
        $i = 0;
        while ($i < $c) {
            if ($this->isBadHost($i)) {
                $r[] = $this->hosts[$i]->ConnectStr();
            }    
            $i++;
        }
        return implode(",", $r);
    }

    public function getHosts() {

        $r = array();
        $c = count($this->hosts);
        $i = 0;
        while ($i < $c) {
            $r[] = $this->hosts[$i++]->ConnectStr();
        }    
        return implode(",", $r);
    }

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

        return  "POST /RPC2 HTTP/1.0" . CRLF . 
                "User-Agent: xmlrpc_client.php" . CRLF . 
                "Host: " . $h->ConnectStr() . CRLF .
                "Content-Type: text/xml" . CRLF . 
                "Content-Length: " . strlen($this->xml) . CRLF . CRLF;
    }

    private function cutHeader($payload) { 
        $pos = strpos($payload, "<?xml", 1);
        if ($pos !== false) {
            return substr($payload, $pos);
        } else {
            $this->setLogicError(102, "Keine Antwort");
            return "";
        }
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
                    if (!$this->isBadHost($active)) {
                        break;
                    }
                    if ($i == $c) {
                        $this->fatalError("xmlrpc_client: no good hosts left");
                        return false;
                    }
                }
            }

            $h = $this->hosts[$active];
            $try = 0;
            while (($result == false) AND ($try++ <= $h->retries)) {

                // log
                // trigger_error("remote-call '"  . $h->host . ":" . $h->port . "." . $this->method . "();' ... ");

                // open tcp connection
                $fp = @fsockopen($h->host, $h->port, $errno, $errstr, max($h->timeout_open, 1));
                if (!$fp) {
                    $this->addProblem("fsockopen(" . $h->host . ":" . $h->port . ") returned error code " . $errno);
                    continue;
                }

                // build request
                $payload = $this->getHeader($h) . $this->xml;

                // send request
                if (!@fwrite($fp, $payload, strlen($payload))) {
                    $this->addProblem("fwrite(" . $h->host . ":" . $h->port . ") failed ");
                    @fclose($fp);
                    continue;
                }

                // read response
                $result = "";
                @stream_set_timeout($fp, max($h->timeout_read, 1));
                while ($data = @fread($fp, txmlrpc::BLOCK_SIZE))
                    $result .= $data;

                // response problems?
                $info = @stream_get_meta_data($fp);
                if ($info["timed_out"]) {
                    $this->addProblem("fread(" . $h->host . ":" . $h->port . ") gave up after " . $h->timeout_read . " seconds");
                    @fclose($fp);
                    continue;
                }
                @fclose($fp);
            }

            if (($result === false) or ($result === "")) {

			  $this->markHostAsBad($active);
            } else {
				$this->lastServer = $h->ConnectStr();
                break;
            }
        }

        return $result;
    }

    public function sendRequest($method, $params = "", $timeout = 0) {


        if ($this->logCALL) {
            if (is_array($params)) {
                fb($method . "(" . implode(",", $params) . ")", "xmlrpc-call", FirePHP::INFO);
            } else {
                fb($method . "(" . $params . ")", "xmlrpc-call", FirePHP::INFO);
            }
        }

        $this->startTime();

        if ($this->gaveUp) {
            return NULL;
        }

        if ($method != "") {
            $this->setMethod($method);
            if ($params != "") {
                $this->setParams($params);
            }
        
            $this->xml = txmlrpc::encodeRequest($this->method, $this->params);
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
			   $result = txmlrpc::decodeResponse($this->xml);
               if (is_array($result) AND array_key_exists("faultCode", $result)) {
                    $this->setLogicError($result["faultCode"], $result["faultString"]);
                    $result = NULL;
                }
            }
        }

        $this->stopTime();
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

    public function __wakeup() {
        trigger_error("someone try to create " . self::CLASS_NAME . " from session", E_USER_NOTICE);
    }

}
?>
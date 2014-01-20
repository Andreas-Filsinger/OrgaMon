<?php
// TXMLRPC CLASS, PHP5
// by Thorsten Schroff, 2011

require_once("xmlrpc_client.php");

class txmlrpc_server {

    static private $instance = NULL;
    private $xml = NULL;
    private $xp = NULL;
    private $methods = array();

    const CLASS_NAME = "PHP5CLASS T_XMLRPC_SERVER";

    private function __construct() {
        
    }

    static public function create() {
        if (!self::$instance) {
            self::$instance = new txmlrpc_server();
        }
        return self::$instance;
    }

    public function readXMLFromInput() {
        $this->xml = DOMDocument::loadXML(utf8_encode(trim(file_get_contents("php://input"))));
        $this->xp = new DOMXPath($this->xml);
    }

    public function registerMethod($name, $callback) {
        $this->methods[$name] = $callback;
    }

    public function getMethod() {
        try {
            $result = $this->xp->query("//methodCall/methodName/self::*")->item(0)->nodeValue;
        } catch (Exception $e) {
            $result = NULL;
        }
        return $result;
    }

    //doesnt process arrays yet
    public function getParams() {
        try {
            $result = array();
            $values = $xp->query("//methodCall/params/param/value/child::*");
            foreach ($values as $value) {
                switch ($value->nodeName) {
                    case("int"): {
                            $result[] = intval($value->nodeValue);
                            break;
                        }
                    case("string"): {
                            $result[] = strval($value->nodeValue);
                            break;
                        }
                    case("boolean"): {
                            $result[] = (intval($value->nodeValue) == 1) ? true : false;
                            break;
                        }
                }
            }
        } catch (Exception $e) {
            $result = NULL;
        }
        return $result;
    }

    public function handleRequest() {
        $this->readXMLFromInput();
        call_user_func($this->methods[$this->getMethod], $this->getParams());
    }

    public function __wakeup() {
        self::$instance = $this;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
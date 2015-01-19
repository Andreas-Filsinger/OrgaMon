<?php
define("IBASE_DEFAULT_USER", "SYSDBA");
define("IBASE_DEFAULT_PASSWORD", "masterkey");
define("IBASE_CHARSET_DATABASE", "ISO-8859-1"); // eigentlich "Ansi" oder "Windows-1252"
define("IBASE_CHARSET_SITE", "UTF-8");

define("CALLBACK_requestConnectivity", "requestConnectivity");

// AF: das Datenbank Objekt kann zunächst unverbunden instanziert werden.
//     checkConnect() erzwingt die Datenbankverbindung
//     Ein lazy Call Back ermittelt dann spätmöglichst die Zugangsdaten

class tibase {

    // Object, das "function CALLBACK_requestConnectivity()" implementieren muss
    // wenn ibase konnektieren will, wird diese Funktion gerufen!
    public $requestImplementer = NULL;
    public $logSQL = false;
    // Abhängigkeiten 
    // Zugangsdaten
    private $ib_name = "";
    private $ib_user = "";
    private $ib_passwd = "";
    private $connected = false;
    private $connectionHandle = 0;
    private $pendingTransaction_R = 0;
    private $pendingTransaction_RW = 0;
    private $statementHandles = array();
    // Performance-Messung
    private $time_sub_method_level = 0;
    private $time_started = 0.0;
    private $time_stopped = 0.0;
    private $time_needed = 0.0;
    static private $errormsg = array("Die Verbindung zur Datenbank konnte nicht hergestellt werden [~ERROR~]");

    const CLASS_NAME = "PHP5CLASS_T_IBASE";
    const GLOBAL_NAME = "ibase";

    /*
      static public function create($name, $user = IBASE_DEFAULT_USER, $passwd = IBASE_DEFAULT_PASSWORD) {
      if (!tibase::$instance) {
      tibase::$instance = new tibase($name, $user, $passwd);
      if (tibase::$connected == false) {
      tibase::$instance = NULL;
      }
      }
      return tibase::$instance;
      }
     */

    public function setConnection($name, $user = IBASE_DEFAULT_USER, $passwd = IBASE_DEFAULT_PASSWORD) {
        $this->ib_name = $name;
        $this->ib_user = $user;
        $this->ib_passwd = $passwd;
    }

    public function __destruct() {
        $this->close();
    }

    private function nativeSQL($sql) {

        return iconv(IBASE_CHARSET_SITE, IBASE_CHARSET_DATABASE . "//IGNORE", $sql);
    }

    private function checkConnect() {

        global $errorlist;
        $this->start_time();

        if (!$this->connected) {
            // Parameter der Konnektivität ermitteln, -> Callback
            if ($this->ib_name == NULL) {

                if ($this->requestImplementer != NULL) {
                    // Rufe das Objekt, das sich als Geheimnisträger registriert hat

                    $this->requestImplementer->{CALLBACK_requestConnectivity}();

                    //call_user_func(array($this->requestImplementer, CALLBACK_requestConnectivity));
                }
            }
        }

        if ($this->ib_name == NULL) {
            $errorlist->add("ibase: Weiss nicht, auf wen ich konnektieren soll");
        }

$this->ib_passwd = "masterkey";

        $this->connectionHandle = @ibase_connect($this->ib_name, $this->ib_user, $this->ib_passwd);
        if ($this->connectionHandle == "") {
            $this->set_error(0);
            $this->connected = false;
        } else {
            $this->connected = true;
        }

        $this->stop_time();
    }

    static public function isConnected() {
        return $this->connected;
    }

    public function lastStatementHandle() {
        $c = count($this->statementHandles);
        if ($c == 0) {
            return 0;
        } else {
            return end($this->statementHandles);
        }
    }

    private function transaction($write = false) {
        if ($write) {
            if ($this->pendingTransaction_RW == 0) {
                $this->pendingTransaction_RW = ibase_trans(IBASE_WRITE + IBASE_COMMITTED + IBASE_WAIT, $this->connectionHandle);
            }
            return $this->pendingTransaction_RW;
        } else { //TS 24-04-2012: 
            //Momentan wird nur einmal zu Beginn des Skript-Durchlaufs eine READONLY-Transaktion geöffnet. 
            //Diese wird immer innerhalb tibase->query() benutzt und erst am Ende durch tibase->close() committed.
            //Die if-Bedingung in der folgenden Zeile wird also nur genau einmal erfüllt.
            if ($this->pendingTransaction_R == 0) {
                $this->pendingTransaction_R = ibase_trans(IBASE_READ + IBASE_COMMITTED + IBASE_WAIT, $this->connectionHandle);
            }
            //var_dump($this->pendingTransaction_R);
            return $this->pendingTransaction_R;
        }
    }

    private function commit($t) {
        if ($t == $this->pendingTransaction_R) {
            ibase_commit($t);
            $this->pendingTransaction_R = 0;
            return;
        }
        if ($t == $this->pendingTransaction_RW) {
            ibase_commit($t);
            $this->pendingTransaction_RW = 0;
            return;
        }
        trigger_error("tibase: commit() mit einem ungueltigen Transaktions-Handle", E_USER_WARNING);
    }

    public function query($sql) {

        global $messagelist;

        // Log?
        if ($this->logSQL) {
            fb($sql, "SQL", FirePHP::INFO);
        }

        $this->start_time();
        $this->checkConnect();
        $sm = ibase_query($this->transaction(), $this->nativeSQL($sql));
        //trigger_error("COUNT: " . count($this->statementHandles) . " / RESULT $sm / QUERY: $sql",E_USER_NOTICE);
        array_push($this->statementHandles, $sm);
        $this->handle_error($sql);
        $this->stop_time();
        return $sm;
    }

    public function count($result = false) {
        if (!$result) {
            $result = $this->lastStatementHandle();
        }
        $count = ibase_num_fields($result);
        return $count;
    }

    public function gen_id($generator, $increment = 1) {

        global $messagelist;

        if ($this->logSQL) {
            $messagelist->add("select genid('$generator',$increment) from RDB\$DATABASE");
        }

        $this->start_time();
        $this->checkConnect();
        $t = $this->transaction($increment > 0);
        $g = ibase_gen_id($generator, $increment, $t);
        $this->commit($t);
        $this->stop_time();

        return $g;
    }

    // returns true | false
    public function exec($sql) {

        global $errorlist;
        global $messagelist;

        if ($this->logSQL) {
            $messagelist->add($sql);
        }
        $this->start_time();
        $this->checkConnect();
        $t = $this->transaction(true);

        $q = ibase_query($t, $this->nativeSQL($sql)); // resource ID | true | false | AFFECTED ROWS
        $this->handle_error($sql);
        $this->commit($t);
        while (true) {
            if (is_resource($q)) {
                ibase_free_result($q);
                $q = true;
                break;
            }
            if (is_int($q)) {

                // Anzahl der betroffenen Datensätze
                if ($q == 0) {

                    $errorlist->add($this->__toString() . ": Ein SQL-Statement hatte keine Wirkung");
                    trigger_error("tibase: Affected Rows=0 @($sql)", E_USER_WARNING);
                    $q = false;
                } else {

                    // Das Statement eine Wirklung
                    $q = true;
                }
                break;
            }
            break;
        }
        $this->stop_time();

        return $q;
    }

    public function fetch_object($result = false) {

        $this->start_time();
        if (!$result) {
            $result = $this->lastStatementHandle();
        }
        if ($result == 0) {
            trigger_error("tibase: fetch_object() ausserhalb eines query()-Kontext", E_USER_WARNING);
            return null;
        }
        //var_dump($this->result);
        //var_dump($result);
        $object = ibase_fetch_object($result);

        // Zeichensatz nach UTF-8 heben, unter fb 3.0 
        // wird die Datenhaltung im orgaMon durchweg UTF8 sein
        // dies kann dann ab diesem Zeitpunkt wieder wegfallen!
        if (is_object($object))
            foreach ($object as $key => $value)
                if (is_string($value))
                    $object->$key = iconv(IBASE_CHARSET_DATABASE, IBASE_CHARSET_SITE, $value);

        //   var_dump($object);

        $this->handle_error("fetch_object");
        $this->stop_time();

        return $object;
    }

    public function serialize_result($result = false, $separator = ",") {
        $this->start_time();
        if (!$result) {
            $result = $this->lastStatementHandle();
        }
        if ($result == 0) {
            trigger_error("tibase: fetch_object() ausserhalb eines query()-Kontext", E_USER_WARNING);
            return null;
        }
        $serialized = "";
        while ($data = ibase_fetch_row($result)) {
            $serialized .= implode($separator, $data) . $separator;
        }
        $this->free_result();
        $this->stop_time();
        return substr($serialized, 0, -strlen($separator));
    }

    public function get_field($sql, $name = "RID") {

        $this->start_time();
        $this->query($sql);
        //$data = ($this->count() > 0) ? $this->fetch_object() : false;
        //$this->free_result();
        if ($this->count() > 0) {
            $data = $this->fetch_object();
            //$this->free_result();
        }
        else
            $data = false;
        $this->free_result();
        $this->stop_time();

        return (isset($data->{$name})) ? ($data->{$name}) : (false);
    }

    public function get_list_as_string($sql, $name = "RID", $separator = ",") {

        $this->start_time();
        $this->query($sql);
        $str = "";
        while ($data = $this->fetch_object()) {
            $str.= $data->{$name} . $separator;
        }
        $this->free_result();
        $this->stop_time();

        return substr($str, 0, -strlen($separator));
    }

    public function get_list_as_array($sql, $name = "RID") {

        $this->start_time();
        $this->query($sql);
        $arr = array();
        while ($data = $this->fetch_object()) {
            $arr[] = $data->{$name};
        }
        $this->free_result();
        $this->stop_time();

        return $arr;
    }

    public function get_list_as_associated_array($sql, $name = "RID", $index = "RID") {

        $this->start_time();
        $this->query($sql);
        $arr = array();
        while ($data = $this->fetch_object()) {
            $arr[$data->{$index}] = $data->{$name};
        }
        $this->free_result();
        $this->stop_time();

        return $arr;
    }

    public function set_blob($string) {

        $this->start_time();
        $blob = ibase_blob_create($this->connectionHandle);
        ibase_blob_add($blob, $string);
        $blob_id = ibase_blob_close($blob);
        //$this->free_result();
        $this->stop_time();

        return $blob_id;
    }

    public function get_blob($blob_id, $bytes = 4096) {

        $this->start_time();
        while (true) {
            if ($blob_id == false)
                break;
            $handle = ibase_blob_open($this->connectionHandle, $blob_id);
            if ($handle == false)
                break;
            $blob = ibase_blob_get($handle, $bytes);
            ibase_blob_close($handle);
            $this->stop_time();
            return $blob;
        }
        $this->stop_time();

        return false;
    }

    public function free_result($result = false) {

        if (!$result) {
            $result = $this->lastStatementHandle();
        }
        $i = array_search($result, $this->statementHandles, true);
        //TS 24-04-2012: i kann 0 sein, wenn es sich um das erste Array-Element handelt.
        if ($i !== false) {

            if ($this->logSQL) {
                fb("close", "SQL", FirePHP::INFO);
            }
            ibase_free_result($result);
            unset($this->statementHandles[$i]);
            //trigger_error(count($this->statementHandles) . ":free($i)");
        } else {
            trigger_error("tibase: free_result(): $result unbekanntes StatementHandle", E_USER_WARNING);
        }
    }

    public function error() {
        return array(strval(abs(ibase_errcode())), ibase_errmsg());
    }

    private function handle_error($message) {

        global $errorlist;
        if (($error = ibase_errmsg()) != "") {
            $errorlist->add($this->__toString() . ": " . $error);
            trigger_error("tibase: $message", E_USER_WARNING);
        }
    }

    private function close() {
        $this->start_time();
        if ($this->connected) {
            $c = count($this->statementHandles);
            if ($c > 0) {
                trigger_error("tibase: close(): $c ungeschlossene Statement(s)", E_USER_WARNING);
            }

            if ($this->pendingTransaction_R != 0) {
                $this->commit($this->pendingTransaction_R);
                //TS 10-05-2012: Dieser Block wird immer ausgeführt. Daher wurde die folgende Zeile auskommentiert.
                //               Siehe dazu auch Kommentar vom 24-04-2012 innerhalb der Methode transaction().
                //trigger_error("tibase: close(): autoCommit einer R-Transaction", E_USER_WARNING);
            }

            if ($this->pendingTransaction_RW != 0) {
                $this->commit($this->pendingTransaction_RW);
                trigger_error("tibase: close(): autoCommit einer RW-Transaction", E_USER_WARNING);
            }

            ibase_close($this->connectionHandle);
            $this->connected = false;
        }
        $this->stop_time();
    }

    private function set_error($i) {

        global $errorlist;
        $errorlist->add($this->__toString() . ": " . $this->ib_name . ": " . str_replace("~ERROR~", trim(implode($this->error(), ":")), tibase::$errormsg[$i]));
    }

    private function start_time() {
        if ($this->time_sub_method_level == 0) {
            $this->time_started = microtime(true);
        }
        $this->time_sub_method_level++;
    }

    private function stop_time() {
        $this->time_sub_method_level--;
        if ($this->time_sub_method_level == 0) {
            $this->time_stopped = microtime(true);
            $this->time_needed += $this->time_stopped - $this->time_started;
        }
    }

    public function get_time() {

        if ($this->time_sub_method_level != 0)
            trigger_error("tibase: get_time() called before finish line", E_USER_WARNING);
        return $this->time_needed;
    }

    // tt~separator~mm~separator~yyyy
    static public function date($date, $separator = "-") {
        // 
        return substr($date, 0, 2) . $separator . substr($date, 3, 2) . $separator . substr($date, 6, 4);
    }

    // yyyy-mm-dd
    static public function iso_date($date) {
        return substr($date, 6, 4) . "-" . substr($date, 3, 2) . "-" . substr($date, 0, 2);
    }

    static public function time($timestamp, $seconds = false) {
        return substr($timestamp, 11, ($seconds) ? 8 : 5);
    }

    static public function datetime($timestamp, $separator = "-") {
        return self::date($timestamp, $separator) . " " . self::time($timestamp);
    }

    static public function timestamp($datetime) {
        return strtotime($datetime);
    }

    static public function null2zero($var) {
        return ($var == NULL) ? 0 : $var;
    }

    static public function null2str($var) {
        return ($var == NULL) ? "NULL" : $var;
    }

    static public function format_for_insert($var, $autotype = true, $is_string = false) {
        $is_string = ($autotype) ? is_string($var) : $is_string;
        $var = self::null2str($var);
        return ($var != "NULL") ? (($is_string) ? "'$var'" : intval($var)) : $var;
    }

    static public function is_blob_resource($str) {
        return ($str != NULL AND preg_match("/^0x([abcdef0123456789])*$/", strtolower($str)));
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
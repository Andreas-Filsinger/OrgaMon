<?php

// AF: Zugriffs-Wrapper auf die superglobal $_SESSION
// Bemerkung zu der serialisierung von Objekten
// # "static" elemente werden nicht serialisiert, die Frage ist
//  ob diese Elemente einfach nach dem ersten erstellen aus einer
//  Session existent sind, oder VORHER zumindest eine Instanz des 
//  Objektes erstellt werden muss.
// # "private" elemente werden nicht serialisiert, hm ich glaube serialisiert schon
//  - sie sind aber durch json_:encode nicht ausgebbar, da das objekt dem
//  json -encoder den Zugriff auf "protected" und "private" Properties verwehrt.
// # "protected" elemente werden immer genullt ! (Stimmt das?)
//    deren inhalt wird also nicht weitergetragen
// # "auto gen" properties von Objekten, also im Prinzip public properties, die mit
//   $this->NEU = "hallo"  oder
//    $this->{$neu} = "hallo" erstellt werden
//   werden auch seraialisiert und stehen später auch wieder zur Verfügung
//   das ist aber ein Problem bei "USER_DIENSTE" das geht irgendwie nicht!
// # Prozess der unserialisierung: Es scheint so, dass unserialisierte Objekte
//  plötzlich einfach wieder da sind. Es wird werder create noch __construct
//  gerufen, das "Ding" wird einfach aus dem Speicher Schema des typeof(Object)
//  generiert, und die Properties, die das Glück haben in der Session zu sein
//  werden mit Werten befüllt.
//  was ist mit
//  
// 
// 
// AF: der Shop sollte auch mal ohne den Start einer Session lauffähig sein
// ich denke nicht, dass eine Session verloren geht sobald man die aktuelle Domain 
// auch mal ohne die Notwendigkeit einer Session ansteuert. In diesem Fall würde also
// PHP kein session_start() bekommen, die Session-Datei bliebe unverändert!
// Beispiel: klar, sobald eine suche läuft ODEr etwas im Warenkorb steht
// muss eine Session bei jedem Request benutzt werden, sonst kann ja oben in der
// ecke keine Warenkorb Menge angezeigt werden. Bei einer Artikel Einzehlansicht
// braucht uns PHP jedoch keine $_SESSION füllen!
// AF: Auf der Entwicklungsmaschine kommt das Session-System in Probleme:
// die Session überlebt Änderungen an serialisierten PHP Objekten, Properties
// kommen hinzu oder werden gelöscht, static wechselt zu protected, Klassennamen
// werden verändert -> das ist ein Problem: Bei WAMP reicht es nicht das
// Session-Verzeichnis zu löschen - die "letzte" Session ist immer noch im 
// Hauptspeucher des APapche - ich habe gesehen dass nach Löschung des verzeichnisses
// die Session plötzlich wieder mit 332k da war.
// AF: Domain-Identische Shops sollten NAmensraum Abhängige Variable haben,
// in den fremenden Session Namensräumen sollten sie nicht wildern, ich gehe 
// mal davon aus, dass Clients, die 3 Tabs auf die selbe Domin offen haben
// 
// http://shop.de/shop-002/index.php
// http://shop.de/shop-003/index.php
// http://shop.de/shop-004/index.php
//
// sich alle die selbe Session teilen - oder?
// Thema "tmp" - Vars, spezieller Session-Context-Pool
// AF: Alle tmp-Variable, die nicht dem aktuellen context entsprechen = "site"
//     werden VOR "Speicherung" also Verlassen den Skriptes 
//     gelöscht. Also werden alle tmp-Vars, die von anderen sites gespeichert 
//     wurden, in der aktuellen Site gelöscht.

class tsession {

    static private $instance = NULL;
    var $tmp_vars = array();

    const CLASS_NAME = "PHP5CLASS T_SESSION";

    private function __construct() {
        $this->tmp_vars = array();
    }

    public function __destruct() {
        $this->registerVar("self", $this);
        //echo self::debug_list();
    }

    public function __wakeup() {
        self::$instance = $this;
    }

    static public function create() {

        // Fill superglobal $_SESSION
        // unserialize all the objects?
        session_start();

        // Log session as it is
        if (defined("SESSION_LOG"))
            if (SESSION_LOG)
                self::doLog(FirePHP::INFO);

        if (self::$instance == NULL) {
            self::$instance = self::get(self::getSessionVarName("self"), new tsession());
        }
        return self::$instance;
    }

    static public function free() {
        self::$instance->destroy();
        self::$instance = NULL;
    }

    public function destroy() {
        // AF: Gefahr für andere Shops! Deren Session könnte zerstört werden
        // besser, ist es, nur alle Elemente der Session mit dem Namens-Prefix
        // zu löschen!
        // imp pend
        if (defined("SESSION_LOG"))
            if (SESSION_LOG)
                fb("Session Namespace '" . $this->getSessionPrefix() . "' killed", "Session", FirePHP::INFO);
        session_destroy();
        $_SESSION = null;
    }

    public function getSize() {
        return sizeof($_SESSION);
    }

    public function doLog($log_level = FirePHP::INFO) {
        
        if (count($_SESSION) == 0) {
            fb("null", "\$_SESSION", $log_level);
        }

        foreach ($_SESSION as $key => $_VALUE) {

            if (is_object($_VALUE)) {

                fb(json_encode($_VALUE), "(" . get_class($_VALUE) . ")$key", $log_level);
            } else {
                fb($_VALUE, "(" . gettype($_VALUE) . ")$key", $log_level);
            }
        }
    }

    public function getID() {
        return session_id();
    }

    static private function getSessionPrefix() {
        return TWEBSHOP_ID;
    }

    static private function getSessionVarName($_VAR) {
        return tsession::getSessionPrefix() . "_" . $_VAR;
    }

    static private function getSessionTmpVarName($_VAR, $context = "") {
        return tsession::getSessionPrefix() . "_tmp_" . $context . "_" . $_VAR;
    }

    static private function registered($key) {
        return isset($_SESSION[$key]);
    }

    public function isRegistered($key) {
        return self::registered(self::getSessionVarName($key));
    }

    public function isRegisteredTmp($key, $context) {
        return self::registered(self::getSessionTmpVarName($key, $context));
    }

    static private function get($key, $defaultValue) {
        return self::registered($key) ? $_SESSION[$key] : $defaultValue;
    }

    public function getVar($key, $defaultValue = NULL) {
        return self::get(self::getSessionVarName($key), $defaultValue);
    }

    public function getTmpVar($key, $context, $default = NULL) {
        //echo "get: $context<br />";
        return self::get(self::getSessionTmpVarName($key, $context), $default);
    }

    static private function register($key, $value) {
        $_SESSION[$key] = $value;
    }

    public function registerVar($key, $value) {
        self::register(self::getSessionVarName($key), $value);
    }

    public function registerVars($keys = array()) {
        foreach ($keys as $key) {
            global $$key;
            self::registerVar($key, $$key);
        }
    }

    public function registerTmpVar($key, $value, $context) {
//echo "register: $context<br />";
        $tmpKey = self::getSessionTmpVarName($key, $context);
        $this->tmp_vars[$tmpKey] = $context;
        self::register($tmpKey, $value);
    }

    static private function unregister($key) {

        unset($_SESSION["$key"]);
        //echo "Session-Registrierung von $_SESSION_VAR wurde aufgehoben<br />";
    }

    public function unregisterVar($key) {
        self::unregister(self::getSessionVarName($key));
    }

    public function unregisterTmpVar($_VAR, $context) {
        $_SESSION_VAR = self::getSessionTmpVarName($_VAR, $context);
        self::unregister($_SESSION_VAR);
        $this->removeFromTmpVarsList($_SESSION_VAR);
    }

    private function removeFromTmpVarsList($key) {
        $this->tmp_vars = array_diff_key($this->tmp_vars, array($key => NULL));
    }

    public function cleanupTmpVars($context) {
//echo "unregister: $context<br />";
        foreach ($this->tmp_vars as $_SESSION_VAR => $_CONTEXT) {
//echo $_SESSION_VAR . "@" . $_CONTEXT . BR;
            if ($_CONTEXT != $context) {
                self::unregister($_SESSION_VAR);
                //echo wrap(count($this->tmp_vars));
                $this->removeFromTmpVarsList($_SESSION_VAR);
                //echo wrap(count($this->tmp_vars));
            }
        }
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
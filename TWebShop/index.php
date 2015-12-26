<?php


// Stage "0" Init - keine Abhängigkeiten zu ext(ra) php-Modulen

include_once("./core/performance.php");     // Klasse zum Erfassen der Performance (benötigte Zeiten)
tperformance::setTimeStarted();

// richtige PHP-Einstellungen sicherstellen

date_default_timezone_set('Europe/Berlin');
mb_internal_encoding("UTF-8");


// Stage "1" Init - Pre-Config, keine Abhängigkeiten zur Shop-Konfiguration

include_once("./FirePHPCore/fb.php");       // Ausgabe von Log-Texten in die Firefox FireBug Konsole
include_once("./core/global_funcs.php");    // Globale Funktionensammlung
include_once("./logic/global_const.php");   // Globale System Konstanten 
include_once("./core/errorlist.php");       // Klasse zur Fehlerausgabe

include_once("./core/cryption.php");        // Verschlüsselungs-Klasse 
include_once("./core/crypt_id.php");        // Klasse zur Verschlüsselung der Datenbank-IDs
include_once("./core/shopstate.php");       // Verwaltet den Status der Anwendung, sie wird dadurch StateFull
include_once("./core/visual.php");          // Standardklassen, die beerbt werden
include_once("./core/global.php");          // Klasse zur Deklaration & Registrierung von globalen Variablen
include_once("./core/messagelist.php");     // Klasse zur Meldungsausgabe
include_once("./core/stringlist.php");      // Klasse zur Verwaltung von Stringlisten
include_once("./core/multistringlist.php"); // Vererbte Klasse zur Verwaltung von Stringlisten von Werten mit mehreren Zeilen 
include_once("./core/xmlrpc_client.php");   // XMLRPC - Client 
include_once("./core/session.php");         // Klasse zur Erleichterung des Handlings der $_SESSION

// Stage "2" Init - DIE SHOP KONFIGURATION

include_once("config.php");                 // Konfiguration

//
// pre init: Prüfen der zum Funktionieren notwendigen PHP-ext(ra)-Module, z.B. "php5-dom"
$i = 0;

// statische / unabänderliche Abhängigkeiten

$_PHPEXTENSIONS = array("dom", "iconv", "interbase", "mbstring", "mcrypt", "session");

// dynamische Abhängigkeiten, je nach Konfiguration
// a) Bei monolithischem XMLRPC ist kein memcached notwendig

if (defined("XMLRPC")) {

  define("XMLRPC_1", XMLRPC);
} else {

  array_push($_PHPEXTENSIONS, "memcached");
}    

// nun ALLE fehlenden Module ohne "Fail after Fail" direket auflisten
foreach ($_PHPEXTENSIONS as $_EXTENSION)
    if (!extension_loaded($_EXTENSION)) {
        echo "FATAL ERROR: missing PHP-extension: $_EXTENSION<br />";   // => Low-Level-LOG
        $i++;
    }
    

// Prüfung der Verschlüsselungsmöglichkeiten    
if (CRYPT_SHA256 != 1) {
    echo "FATAL ERROR: CRYPT_SHA256 missing<br />";   // => Low-Level-LOG
    $i++;
}

if ($i == 0) {


// Stage "3" - Existenz aller notwendigen Module ist sichergestellt
//             Konfiguration ist da 

    include_once("./core/ibase.php");           // Klasse zur Interbase-Anbindung
    include_once("./core/site.php");            // Klasse zur Verwaltung von Webseiten
    include_once("./core/pages.php");           // Klasse zur Verwaltung von Unterseiten (z.B. mehrseitige Suchtrefferanzeige) 
    include_once("./core/steps.php");           // Klasse zur Abbildung von Einzelschritten als Unterseiten (z.B. Seite Anmelden hat mehrere Schritte)
    include_once("./core/option.php");          // Klasse zur Abbildung von Benutzer-Optionen
    include_once("./core/template.php");        // Klasse zur Übergabe von Templates

// Stage "3" Webshop - Logik-Core

    include_once("./logic/orgamon.php");         // OrgaMon-Client-Klasse (nutzt XMLRPC-Client) und OrgaMon-Ereignis-Klasse
    include_once("./logic/orgatix.php");         // OrgaTix-Klasse 

// Stage "4" Webshop - Logik für "Sites"

    include_once("./logic/account.php");
    include_once("./logic/address.php");
    include_once("./logic/article.php");
    include_once("./logic/article_context.php");
    include_once("./logic/article_link.php");
    include_once("./logic/article_tree.php");
    include_once("./logic/articles.php");
    include_once("./logic/availability.php");
    include_once("./logic/bill.php");
    include_once("./logic/cart.php");
    include_once("./logic/country.php");
    include_once("./logic/mailings.php");
    include_once("./logic/musician.php");
    include_once("./logic/musicians.php");
    include_once("./logic/musician_list.php");
    include_once("./logic/mymusic.php");
    include_once("./logic/order_state.php");
    include_once("./logic/payment_info.php");
    include_once("./logic/person.php");
    include_once("./logic/price.php");
    include_once("./logic/publisher.php");
    include_once("./logic/publishers.php");
    include_once("./logic/twebshop_search.php");
    include_once("./logic/search_result_pages.php");
    include_once("./logic/user.php");
    include_once("./logic/article_variants.php");
    include_once("./logic/wishlist.php");

// neuer Ring ?, die "_GLOBALS" sind da!
// Webshop - Ring 4 - "Template, Language" - Phase
// Webshop - Ring 5 - "Action" - Phase
// Webshop - Ring 6 - "Site" - Phase
######## TEMPLATES ##############
// TEMPLATE AUS COOKIE ERMITTELN
    if (isset($_COOKIE["c_template"])) {
        $_TEMPLATE = $_COOKIE["c_template"];
    }

// TEMPLATE AUS REQUEST ERMITTELN
    if (isset($_REQUEST["template"])) {
        $_TEMPLATE = $_REQUEST["template"];
    }

// TEMPLATE SETZEN (ENTWEDER AUS COOKIE, AUS REQUEST ODER AUS CONFIG.PHP)
    $_TEMPLATE = (isset($_TEMPLATE)) ? $_TEMPLATE : TWEBSHOP_TEMPLATE;

    define("__TEMPLATE_PATH", __TEMPLATES_PATH . $_TEMPLATE . "/");
    define("__TEMPLATE_IMAGES_PATH", __TEMPLATE_PATH . "images/");

    if (!is_dir(__TEMPLATE_PATH))
        die(sprintf(SYS_VARIABLE_SENTENCE_TEMPLATE_PATH_NOT_FOUND, __TEMPLATE_PATH));

// SPRACHDATEIEN LADEN
### LANGUAGE ###
    define("__LANGUAGE_PATH", __TEMPLATE_PATH . "language/");

// SPRACHE DES COOKIES ERMITTELN
    if (isset($_COOKIE["c_language"])) {
        $_LANGUAGE = $_COOKIE["c_language"];
    }

// SPRACHE AUS REQUEST ERMITTELN
    if (isset($_REQUEST["language"])) {
        $_LANGUAGE = $_REQUEST["language"];
    }

// SPRACHE AUS REQUEST ERMITTELN, ABWAERTSKOMPATIBILITAET MIT ALTEN TEMPLATE-VERSIONEN
    if (isset($_REQUEST["lang"])) {
        $_LANGUAGE = $_REQUEST["lang"];
    }

// BENUTZERSPRACHE SETZEN
    $_LANGUAGE = (isset($_LANGUAGE)) ? $_LANGUAGE : DEFAULT_LANGUAGE;

// BENUTZERSPRACHE LADEN
    if (file_exists($includefile = __LANGUAGE_PATH . "l_" . $_LANGUAGE . ".inc.php5"))
        include_once($includefile);

// WAS NOCH NICHT DURCH DIE SPRACHDATEI GELADEN WURDE WIRD JETZT MIT DEM STANDARDWERT GELADEN
    include_once(__LANGUAGE_PATH . "l_default.inc.php5");

#####################
// TEMPLATES LADEN
    $templates = file_search(__TEMPLATE_PATH, "^i_template(_[a-z_]+){0,1}.inc.php5$");
    foreach ($templates as $includefile)
        include_once(__TEMPLATE_PATH . $includefile);
    unset($templates);
    unset($includefile);

#################################

    include_once("./logic/globals.php");            // Deklaration & Registrierung der globalen Variablen
// WebShop - Ring 7 - "Session gestartet" Phase
// INIT
    $errorlist = terrorlist::create("", "#CC0000", __TEMPLATE_IMAGES_PATH . "icon_error.png", _TEMPLATE_ERRORLIST);
    $errorlist->add($_REGISTRATION_ERRORS);
    unset($_REGISTRATION_ERRORS);

    $messagelist = tmessagelist::create("", "#00CC00", __TEMPLATE_IMAGES_PATH . "icon_message.png", _TEMPLATE_MESSAGELIST);
    $performance = tperformance::create();
    $cryption = tcryption::create();
    $crypt_ID = tcryptID::create();

    /* @var $ibase tibase */
    $ibase = new tibase;
    if (defined("IBASE_LOG"))
        if (IBASE_LOG) {
            $ibase->logSQL = true;
        }

    /* @var $xmlrpc txmlrpc_client */
    $xmlrpc = new txmlrpc_client;
    if (defined("XMLRPC_LOG"))
        if (XMLRPC_LOG) {
            $xmlrpc->logCALL = true;
        }

    $xmlrpchosts = array();
    $i = 1;
    while (defined("XMLRPC_$i")) {
        $params = new tstringlist();
        $params->assignString(constant("XMLRPC_$i"), ",");
        $h = new tserver_identity(
                        $params->getValueByName("host"),
                        $params->getValueByName("port"),
                        $params->getValueByName("timeout_open"),
                        $params->getValueByName("timeout_read"),
                        $params->getValueByName("retries")
        );

        if (!semiPersistentIsKnown($h->ConnectStr())) {

         $xmlrpc->add($h);
        }
        
        $i++;
        unset($params);
    }

    if ($i < 2) {

        $errorlist->add("need a XMLRPC Server");
    }

    unset($i);
    unset($xmlrpchosts);

    /* @var $orgamon torgamon */
    $orgamon = new torgamon;
    $ibase->requestImplementer = $orgamon;

    twebshop_bill::setPath($orgamon->getSystemString(torgamon::BASEPLUG_BILL_PATH));
    twebshop_article::setMP3Path($orgamon->getSystemString(torgamon::BASEPLUG_MP3_PATH));

    $session = tsession::create();

    if ($session->isRegistered("shop") AND $session->getVar("shop")->getID() != TWEBSHOP_ID) {
        $session->destroy();
        $session = tsession::create();
    }

    if (!$session->isRegistered("shop")) {
        $shop = new tshopState(TWEBSHOP_ID);
        $shop->setActionID();
        $shop->setSite(TWEBSHOP_FIRST_SITE);
        $session->registerVar("shop", $shop);
    }

    $shop = $session->getVar("shop");
    $user = $session->getVar("user", twebshop_user::create());
    $user->clearOptions();
    $cart = $session->getVar("cart", twebshop_cart::create());
    $wishlist = $session->getVar("wishlist", twebshop_wishlist::getInstance());
    $search = $session->getVar("search", twebshop_search::create());
    $search_result_pages = $session->getVar("search_result_pages", new twebshop_search_result_pages($search->getResult(), $search->getID(), $user->WEBSHOP_TREFFERPROSEITE));
    $tree = $session->getVar("tree", new twebshop_article_tree());
    $article_variants = $session->getVar("article_variants", twebshop_article_variants::create());

    toption::$properties["VERSION_MP3"] = $article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3);


// GLOBALE OBJEKTE
    $site = new tsite(isset($site) ? $site : ""); // AUS STRING WIRD OBJEKT
    tsite::$title_separator = TWEBSHOP_TITLE_SEPARATOR;
    tsite::deactivateBlocks(TWEBSHOP_INACTIVE_BLOCKS);
    $template = new ttemplate();


// Prüft ob ein User-Login für die aufgerufene Seite/Aktion erforderlich ist
// SEITEN, DIE EINEN LOGIN ERFORDERN (INDEX = SEITENNAME, WERT = HINWEISTEXT)
    $login_requiring_sites = array(
//"demo" => SENTENCE_PLEASE_LOGIN,
        "myshop" => SENTENCE_PLEASE_LOGIN_TO_CHANGE_SETTINGS,
        "order" => SENTENCE_PLEASE_LOGIN
    );


// AKTIONEN, DIE EINEN LOGIN ERFORDERN
    $login_requiring_actions = array(
        "change_password" => SENTENCE_PLEASE_LOGIN_TO_CHANGE_SETTINGS,
        "miniscore" => SENTENCE_PLEASE_LOGIN_TO_GET_MINISCORE,
        "load_cart" => SENTENCE_PLEASE_LOGIN_TO_LOAD_CART,
        "order" => SENTENCE_PLEASE_LOGIN,
        "order_accept_tob" => SENTENCE_PLEASE_LOGIN,
        "send_help_request" => SENTENCE_PLEASE_LOGIN,
        "set_hits_per_page" => SENTENCE_PLEASE_LOGIN_TO_CHANGE_SETTINGS,
        "download_mymusic" => SENTENCE_PLEASE_LOGIN,
        "update_wishlist" => SENTENCE_PLEASE_LOGIN,
        "delete_from_wishlist" => SENTENCE_PLEASE_LOGIN,
        "add_to_wishlist" => SENTENCE_PLEASE_LOGIN
    );


    // PRÜFEN OB EIN LOGIN ERFORDERLICH IST 
    $login_required_by_site = ($site->set() AND array_key_exists($site->getName(), $login_requiring_sites)) OR (!$site->set() AND array_key_exists($shop->getCurrentSite(), $login_requiring_sites));

    $login_required_by_action = (isset($action) AND array_key_exists($action, $login_requiring_actions));
// USER EINGELOGGT ? UND (ERFORDERT DIE AUFGERUFENE SEITE EINEN LOGIN ? ODER ERFORDERT DIE AUSZUFÜHRENDE AKTION EINEN LOGIN ?)
    if (!$user->loggedIn() AND ($login_required_by_site OR $login_required_by_action)) {

        // VARIABLEN für später SPEICHERN, MIT DER DAS AKTUELLE SKRIPT GERUFEN WURDE
        $shop->saveVars("login", tglobal::$_REGISTERED);

        // HINWEIS AUSGEBEN
        if ($login_required_by_site)
            $messagelist->add($login_requiring_sites[$site->getName()]);
        if ($login_required_by_action)
            $messagelist->add($login_requiring_actions[$action]);

        $site->setName("login");                   // VARIABLE ÜBERSCHREIBEN, ZUR LOGIN SEITE WECHSELN
        // VARIABLE LÖSCHEN, ERSTMAL KEINE AKTION AUSFÜHREN, wurde ja gespeichert
        if (isset($action))
            unset($action);
    }
    unset($login_required_by_site);
    unset($login_required_by_action);

// AF: Die Verarbeitung einer action kann wiederum eine andere auslösen
    // Aktion-Ketten, wobei es eine API gibt, an die man sich zufügen kann
    // wären mir da lieber - aber ich löse das mit einer Logik die einfach nur
    // verhindert, dass actions doppelt ausgeführt werden
    $actionsAlreadySeen = array();
    while (true) {

        // gar nix zu tun
        if (!isset($action))
            break;

        // heute bereits bearbeitet
        if (in_array($action, $actionsAlreadySeen))
            break;

        if (!file_exists($includefile = "./action/" . $action . ".php"))
            break;

        // Unabhängig von ihrer tatsächlichen Ausführung gilt die action als 
        // berücksichtigt
        $actionsAlreadySeen[] = $action;
        switch (true) {

            case(isset($aid) AND $aid > $shop->getActionID()): {
                    if (defined("ACTION_LOG"))
                        if (ACTION_LOG)
                            fb($action, "Action-" . $aid, FirePHP::INFO);
                    $shop->setActionID($aid);
                    unset($aid);
                    include_once($includefile);
                    break;
                }

            case(isset($aid) AND $aid <= $shop->getActionID()): {

                    // Verhindern, dass die $action wiederholt ausgeführt wird
                    unset($aid);
                    break;
                }

            case(!isset($aid)): {
                    if (defined("ACTION_LOG"))
                        if (ACTION_LOG)
                            fb($action, "Action", FirePHP::INFO);
                    include_once($includefile);
                    break;
                }
        }
    }

    toption::$properties["AID"] = $shop->getNextActionID();

#####################
// Suche?!

    toption::$properties["SID"] = $search->getID();
    toption::$properties["NEXT_SID"] = $search->getNextID();

    if (isset($sid)) {
        $search->checkID($sid);
    }

    if ($search->hasRun()) {
        $page = 1;
    }

    if ($search->hasRun() OR $search->isCached() OR $search->hasBeenSorted()) {
        $search_result_pages = new twebshop_search_result_pages($search->getResult(), $search->getID(), $user->WEBSHOP_TREFFERPROSEITE);
        //TS 05.12.2011: Indizes nur bilden, wenn sie später auch angezeigt werden
        if ($search->getHits() > $user->WEBSHOP_TREFFERPROSEITE) {
            $performance->addToken("page_index");
            $search_result_pages->buildPageIndex(10);
            $search_result_pages->buildABCIndex();
            $performance->getTimeNeededBy("page_index");
        }
    }


####  SITE  #### 
    $performance->addToken("p_site");

//$site->set() liefert true, wenn $site->name != ""
    $site->setName(($site->set()) ? $shop->setSite($site->getName()) : $shop->getCurrentSite());
    toption::$properties["SITE"] = $site->getName();

    if (file_exists($includefile = "./site/" . $site->getName() . ".php")) {
        include_once($includefile);
    } else {

        if ($site->loadTemplate(__TEMPLATE_PATH)) {
            if (isset($subsite))
                $site->setStepByName($subsite);
        }
        else {
            $site->setTemplate("~OBJ_ERRORLIST~");
            $errorlist->add("Seite " . $site->getName() . " nicht gefunden!");
        }
    }

#####################

    $performance->getTimeNeededBy("p_site");


    include_once("./logic/messages.php");           // Ausgabe Messagelist & Errorlist vorbereiten
// WebShop - Ring 7 (alle infos sind nun gesammelt -> Belichtung der Ausgabe!!)
//
    include_once("./logic/header.php");             // Seitenkopf
    include_once("./logic/footer.php");             // Seitenfuss
    //
// AF: ich glaube diese unset werden gemacht dass
// Referenzen darauf, die sich in den persistenten Objekten
// befinden NICHT gespeichert werden. Kommt mal auf einen Versuch an.
// Man müsste mal genau schauen, WAS in die Session läuft
// Ich denke es wäre eleganter alle von tsession_persistent abgeleitetes
// Objekt in die Session zu tragen, also dass man genau steuern kann
// und muss was man in der session haben will ...
//

    unset($errorlist);
    unset($messagelist);
    unset($ibase);
    unset($performance);
    unset($cryption);
    unset($crypt_ID);
    unset($template);
    unset($xmlrpc);
    unset($orgamon);


    $cart->clearHTMLTemplate();
//$cart->clearOptions();


    $search_result_pages->clearHTMLTemplate();
    $user->clearHTMLTemplate();
    $user->clearOptions();


//$versions->clearHTMLTemplate();


    $session->registerVars(
            array(
                "_LANGUAGE",
                "cart",
                "search",
                "search_result_pages",
                "tree",
                "user",
                "article_variants"
            )
    );

    include_once("./logic/output.php");             // reine Ausgabe, keine Fragen mehr!

    $session->cleanupTmpVars($shop->getCurrentSite());

    unset($cart);
    unset($search);
    unset($search_result_pages);
    unset($tree);
    unset($user);
    unset($article_variants);

    if (defined("SESSION_LOG"))
        if (SESSION_LOG)
            $session->doLog(FirePHP::WARN);
}
?>
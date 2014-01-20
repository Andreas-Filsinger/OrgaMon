<?php

ini_set("display_errors","Off");
ini_set("log_errors","On");
ini_set("error_log","php_error.log");

include_once("i_global_funcs.inc.php5"); // Globale Funktionensammlung
include_once("i_db_config.inc.php5");    // Datenbankanbindung
include_once("i_custom_vars.inc.php5");  // Sicherheitsrelevante Inhalte wie Zuganskennungen und Passwörter
include_once("i_global_vars.inc.php5");  // Globale Konstanten und Registrierung der globalen Variablen (register_globals=off)
include_once("i_language.inc.php5");     // Sprache
include_once("i_templates.inc.php5");    // Templates die von Klassen zur Ausgabe ihrer Inhalte genutzt werden

include_once("t_classes.inc.php5");         // Standardklassen, die beerbt werden
include_once("t_errorlist.inc.php5");       // Klasse zur Fehlerausgabe
include_once("t_messagelist.inc.php5");     // Klasse zur Meldungsausgabe
include_once("t_xmlrpc.inc.php5");          // XMLRPC-Client-Klasse
include_once("t_orgamon.inc.php5");         // Orgamon-Client-Klasse (nutzt XMLRPC-Client)
include_once("t_dbase.inc.php5");           // Klasse zur Datenbank-Anbindung
include_once("t_option.inc.php5");          // Klasse zur Abbildung von Benutzer-Optionen
include_once("t_template.inc.php5");        // Klasse zur Übergabe von Templates
include_once("t_webshop_classes.inc.php5"); // Klassen zur Abbildung von webshoprelevanten Datenbanktabellen (Artikel, Warenkorb,...)
include_once("t_crypt_id.inc.php5");        // Klasse zur Verschlüsselung der Datenbank IDs 
include_once("t_mp3player.inc.php5");       // Klasse zur Einbindung des Flash-MP3-Players

session_start();

// Instanzierung der global benötigten Objekte --->
$errorlist = terrorlist::create(SENTENCE_ERROR_HAS_OCCURED,"#CC0000","",$_TEMPLATE_ERRORLIST);
$messagelist = tmessagelist::create("","#000000","",$_TEMPLATE_MESSAGELIST);
$xmlrpc = txmlrpc::create(XMLRPC_HOST,XMLRPC_PORT,XMLRPC_PATH);
$orgamon = torgamon::create();
$dbase = tdbase::create(MYSQL_HOST,MYSQL_USER,MYSQL_PASSWORD,MYSQL_NAME);
$crypt_ID = tcryptID::create();
$search = twebshop_search::create();
$cart = (isset($_SESSION["session_cart"])) ? $_SESSION["session_cart"] : twebshop_cart::create();
$template = new ttemplate();
// <--- Ende der Instanzierung

include_once("p_session.inc.php5");

// Einbindung von Aktions-Skripts (Datenbankmanipulation,...)
if (isset($action) AND file_exists($includefile = "a_" . $action . ".inc.php5")) include_once($includefile);

include_once("h_header.inc.php5"); // HTML-Kopf

// Einbindung der Seiten
include_once("p_site_content_pre.inc.php5");
include_once("p_site_content_main.inc.php5");
include_once("p_site_content_post.inc.php5");

include_once("h_footer.inc.php5"); // HTML-Fuss
?>
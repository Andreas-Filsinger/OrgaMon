<?php
ob_start();
date_default_timezone_set('Europe/Berlin');
mb_internal_encoding("iso-8859-1");
iconv_set_encoding('internal_encoding', "iso-8859-1");
iconv_set_encoding('input_encoding', "iso-8859-1");
iconv_set_encoding('output_encoding', "iso-8859-1");
mb_http_output("iso-8859-1");


ini_set('ibase.timestampformat', "%d.%m.%Y %H:%M:%S");
ini_set('ibase.dateformat', "%d.%m.%Y");
ini_set('ibase.timeformat', "%H:%M:%S");

include_once("./core/performance.php");     // Klasse zum Erfassen der Performance (benötigte Zeiten)
tperformance::setTimeStarted();
include_once("./FirePHPCore/fb.php");

// Konfiguration
include_once("./core/global_funcs.php"); // Globale Funktionensammlung
include_once("./logic/global_const.php"); // Globale System Konstanten (muss nie editiert werden)
include_once("config.php");       // Konfiguration
// Kernel
include_once("./core/cryption.php");  // Verschlüsselungs-Klasse 
include_once("./core/crypt_id.php");        // Klasse zur Verschlüsselung der Datenbank-IDs
include_once("./core/visual.php");         // Standardklassen, die beerbt werden
include_once("./core/global.php");          // Klasse zur Deklaration & Registrierung von globalen Variablen
include_once("./core/errorlist.php");       // Klasse zur Fehlerausgabe
include_once("./core/messagelist.php");     // Klasse zur Meldungsausgabe
include_once("./core/stringlist.php");      // Klasse zur Verwaltung von Stringlisten
include_once("./core/xmlrpc_client.php");   // XMLRPC - Client 
include_once("./core/ibase.php");           // Klasse zur Interbase-Anbindung
include_once("./core/picupload.php");       // TPicUpload-Server-Klasse
// Projekt bezogen
include_once("./logic/orgamon.php");         // Orgamon-Client-Klasse (nutzt XMLRPC-Client)
include_once("./logic/tpicupload.php"); // TPicUpload-Klasse TWebShop-Erweiterung
include_once("./logic/person.php");     // TWebShop-Klasse für Person
include_once("./logic/user.php");       // TWebShop-Klasse für User
include_once("./logic/address.php");    // TWebShop-Klasse für Anschrift

function tpicupload_login_user($params) {
    $result = new tpicupload_user_func_result();

    $user = new twebshop_user();
    $user->logIn($params["user"], $params["pass"]);

    if ($user->loggedIn() AND $user->isService(TPICUPLOAD_USER_SERVICE_NAME)) {
        $result->value = true;
    }
    return $result;
}

function tpicupload_new_picture($params) {
    global $ibase;

    $result = new tpicupload_user_func_result();

    $numero = ($params["description"] == NULL OR $params["description"] == "") ? intval(basename(strtolower($params["filename"]), ".jpg")) : $params["description"];


    $article_id = $ibase->get_field("SELECT RID FROM " . TABLE_ARTICLE . " WHERE NUMERO=$numero", "RID");
    if ($article_id !== false) {
        $user = new twebshop_user();
        $user->logIn($params["user"], $params["pass"]);
        $id = $ibase->gen_id("GEN_" . TABLE_DOCUMENT);

        $insert = $ibase->exec("INSERT INTO " . TABLE_DOCUMENT . " (RID,ARTIKEL_R,PERSON_R,MEDIUM_R) VALUES ($id,$article_id," . $user->getID() . "," . TWEBSHOP_ARTICLE_MEDIUM_R_IMAGE . ")");
        //$id = $ibase->insert_id();
        if ($insert) {
            $thumb = twebshop_tpicupload::getThumbFileName($id);
            $image = twebshop_tpicupload::getImageFileName($id);
            // Grosses Bild verschieben
            if ($params["original"]["tmp_name"]) {
                if (move_uploaded_file($params["original"]["tmp_name"], $image)) {
                    chmod($image, 0766);
                    $result->value = true;
                } else {
                    $result->addMessage("Fehler: move '" . $params["original"]["tmp_name"] . "' '" . $image . "'");
                    $result->value = false;
                }
            } else {
                $result->addMessage("Fehler: Formular-Feld 'original' ohne Wert");
                $result->value = false;
            }
            // Thumbnail verschieben
            if ($params["thumb"]["tmp_name"]) {
                if (move_uploaded_file($params["thumb"]["tmp_name"], $thumb)) {
                    chmod($thumb, 0766);
                    $result->value = true;
                } else {
                    $result->addMessage("Fehler: move '" . $params["thumb"]["tmp_name"] . "' '" . $thumb . "'");
                    $result->value = false;
                }
            } else {
                $result->addMessage("Fehler: Formular-Feld 'thumb' ohne Wert");
                $result->value = false;
            }

            if ($result->value)
                $result->addMessage($params["filename"] . " uploaded.");
        }
        else {
            $result->addMessage("Fehler: Der Datenbankeintrag ist fehlgeschlagen !");
        }
        unset($id);
        unset($insert);
        unset($user);
    } else {
        $result->addMessage("Fehler: Es wurde kein Artikel zu Nummer *$numero* gefunden !");
    }
    unset($article_id);
    unset($numero);

    //var_dump($messages);
    return $result;
}

$errorlist = terrorlist::create("", "#CC0000");
$messagelist = tmessagelist::create("", "#00CC00");
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
    $h = new thost(
                    $params->getValueByName("name"),
                    $params->getValueByName("port"),
                    $params->getValueByName("path"),
                    $params->getValueByName("user"),
                    $params->getValueByName("password"),
                    $params->getValueByName("timeout"),
                    $params->getValueByName("retries")
    );
    $xmlrpc->addHost($h);
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


tpicupload::setPath($orgamon->getSystemString(torgamon::BASEPLUG_TWEBSHOP_IMAGE_URL));
$tpicupload = new twebshop_tpicupload(TPICUPLOAD_THUMB_WIDTH, TPICUPLOAD_IMAGE_WIDTH, false, true);

ob_end_clean();

switch ($tpicupload->getMode()) {
    case (TPICUPLOAD_MODE_GET_UPLOAD_INFO): {
            echo $tpicupload->getUploadInfo();
            break;
        }
    case (TPICUPLOAD_MODE_NEW_PICTURE): {
            echo $tpicupload->newPicture();
            break;
        }
}
?>
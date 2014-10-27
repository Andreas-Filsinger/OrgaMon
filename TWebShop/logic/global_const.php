<?php

// Feste Dateinamen
define("FILE_INDEX", "index.php");
define("FILE_SHOP",  "shop.php");

define("__PROJECTNAME","TWebShop");
define("__INDEX",     geturl_shop());
define("__INDEX_EXT", geturl_index());
define("__PATH",path());
define("LF","\n");
define("CRLF","\r\n");
define("TAB","\t");
define("BR","<br />");

define("__TEMPLATES_PATH","./templates/");

// Links für die Rewrite Rule
define("LINK_ARTICLES",  "artikel");
define("LINK_MUSICIAN",  "musiker");
define("LINK_PUBLISHER", "verlage");

// TABELLENNAMEN
define("TABLE_ADDRESS","ANSCHRIFT");
define("TABLE_ARTICLE","ARTIKEL");
define("TABLE_ARTICLE_CONTEXT","ARTIKEL_CONTEXT");

define("TABLE_ARTICLE_MEMBER","ARTIKEL_MITGLIED");
define("TABLE_CATEGORY","SORTIMENT");
define("TABLE_CONTRACT","VERTRAG");
define("TABLE_COUNTRY","LAND");
define("TABLE_DELIVERY","GELIEFERT");
define("TABLE_DOCUMENT","DOKUMENT");
define("TABLE_INTERNATIONAL_TEXT","INTERNATIONALTEXT");
define("TABLE_ITEM","POSTEN");
define("TABLE_MUSICIAN","MUSIKER");
define("TABLE_PAYMENT_INFO","PERSON");
define("TABLE_PERSON","PERSON");
define("TABLE_PROCESSOR","BEARBEITER");
define("TABLE_PUBLISHER","VERLAG");
define("TABLE_TICKET","TICKET");

// KONSTANTEN FÜR ZAHLUNGSARTEN
define("PAYMENT_AMERICAN_EXPRESS",203);
define("PAYMENT_CLICKNBUY",302);
define("PAYMENT_DIRECT_DEBITING",100);
define("PAYMENT_MASTERCARD",201);
define("PAYMENT_PAYPAL",301);
define("PAYMENT_VISACARD",202);

// KONSTANTEN FÜR OPTIONALE BENUTZER-SERVICES
define("TPICUPLOAD_USER_SERVICE_NAME","TPicUpload");
define("MOD_NEWSLETTER_USER_SERVICE_NAME","Newsletter");

// SYSTEM MELDUNGEN, UNABHÄNGIG VOM SPRACH SYSTEM
define("SYS_WORD_ARTICLE_ID","Artikel RID");
define("SYS_WORD_USER_ID","Person RID");

define("SYS_SENTENCE_AVAILABILITY_CHECK","Verfügbarkeits-Check");
define("SYS_SENTENCE_BROKEN_LINK_REPORT","Meldung eines veralteten Links");
define("SYS_SENTENCE_BILL_DELIVERY_BILL_SEPARATELY","Rechnung separat verschicken");
define("SYS_SENTENCE_BILL_DELIVERY_WITH_SHIPPING","Rechnung beilegen");
define("SYS_SENTENCE_NEWSLETTER_HAS_BEEN_CREATED","Ein Newsletter wurde erstellt.");
define("SYS_SENTENCE_THIS_FEATURE_ISNT_IMPLEMENTED_YET","Diese Funktion ist noch nicht implementiert.");
define("SYS_SENTENCE_TWEBSHOP_HELP_REQUEST","TWebShop Anfrage (Hilfe)");
define("SYS_SENTENCE_USER_MAYBE_REGISTERED_TWICE","Mögliche Doppelregistrierung");

define("SYS_VARIABLE_SENTENCE_TEMPLATE_PATH_NOT_FOUND","Der Template-Pfad (%s) wurde nicht gefunden.");

define("SYS_VARIABLE_TEXT_BROKEN_LINK_REPORT_EMAIL","~URL~\n\n~ARTICLE~\n\n~PERSON~\n\n~REFERER~");

?>
<?php

// dient der Identifizierung der Session, ist
// die ID in der Session unterschiedlich zu der hier
// angegebenen, so ist die Session für den WebShop nicht
// gültig. 
// 
// default "01"
define("TWEBSHOP_ID","01");

// default "TWebShop"
define("TWEBSHOP_TITLE","TWebShop");

// default " : "
define("TWEBSHOP_TITLE_SEPARATOR"," : ");

// default "welcome"
define("TWEBSHOP_FIRST_SITE","promo_pakets");

//
// gibt an, welches Template für die Benutzeroberfläche 
// verwendet wird. Alle Templates liegen im Verzeichnis
// ./templates und müssen alle "sites" in Form von 
// ~site~.html Dateien implementieren. Ausserdem müssen
// die Sprach-Dateien alle eingeführten WORD und SENTENCE
// Konstanten befüllen.
// "twebshop"
// "orgamon"
// "hebu2008streicher"
// "hebu2008musikverlag"
// "hebu2008music"
// "hebu"
// 
// default "twebshop"
//
define("TWEBSHOP_TEMPLATE","hebu2008music");

// Beispiel: define("TWEBSHOP_INACTIVE_BLOCKS","FIRSTBLOCK,NEXTBLOCK,LASTBLOCK");
// default ""
define("TWEBSHOP_INACTIVE_BLOCKS","");

// definiert den Namensraum für die Webshop-Suche.
// Der OrgaMon-Tagesabschluss erstellt für jeden definierten
// Namensraum einen eigenen Suchindex, so lassen sich Shop-Varianten
// bzw. Shop-Mandanten aus einem zentral geführten OrgaMon definieren
// 
// default "abu"
define("TWEBSHOP_NAMESPACE","abu");

// XMLRPC 
// default "name=localhost,port=3049,path=,user=,password=,timeout=20,retries=0"
// Kopiervorlage "name=,port=,path=,user=,password=,timeout="
#define("XMLRPC_1","name=KARLSRUHE,port=3040,path=,user=,password=,timeout=10,retries=2");
#define("XMLRPC_1","name=KARLSRUHE,port=3048,path=,user=,password=,timeout=8,retries=1");
define("XMLRPC_1","name=LOCALHOST,port=3049,path=,user=,password=,timeout=8,retries=1");
#define("XMLRPC_2","name=KHAO,port=3048,path=,user=,password=,timeout=8,retries=1");
#define("XMLRPC_3","name=KHAO,port=3047,path=,user=,password=,timeout=8,retries=1");
#define("XMLRPC_4","name=KHAO,port=3046,path=,user=,password=,timeout=8,retries=1");
#define("XMLRPC_1","name=KARLSRUHE,port=3040,path=,user=,password=,timeout=8,retries=1");

// LOG - Einstellungen
#define("XMLRPC_LOG",true);
#define("IBASE_LOG",true);
#define("SESSION_LOG",true);
define("ACTION_LOG",true);
#define("STATEFULL_LOG",true);


// EMAIL
define("EMAIL_ADMIN","thorsten.schroff@orgamon.org");
define("EMAIL_DEVELOPER","thorsten.schroff@orgamon.org");
define("SMTP_HOST","");
define("SMTP_USER","");
define("SMTP_PASSWORD","");

// DATENBANKABHÄNGIGE-KLASSEN-PARAMETER 
define("TWEBSHOP_ARTICLE_CONTEXT_R_PROMO",4);
define("TWEBSHOP_ARTICLE_CONTEXT_R_RECORD",2);
define("TWEBSHOP_ARTICLE_MEDIUM_R_SOUND",1);
define("TWEBSHOP_ARTICLE_MEDIUM_R_IMAGE",2);
define("TWEBSHOP_BILL_R_NEWSLETTER",84193);
define("TWEBSHOP_EVENT_TYPE_NEWSLETTER_CREATION",18);
define("TWEBSHOP_PERSON_DEFAULT_WEBSHOP_TREFFERPROSEITE",5);
define("TWEBSHOP_PERSON_DEFAULT_WEBSHOP_RABATT","N");
define("TWEBSHOP_ARTICLE_VERSION_SHORT_MP3","MP3");

// STANDARDWERTE
define("DEFAULT_LANGUAGE","german");
define("DEFAULT_CURRENCY","&euro;");
define("DEFAULT_DELIVERY_PRICE", 4.20);

// TPICUPLOAD
define("TPICUPLOAD_THUMB_WIDTH",80);
define("TPICUPLOAD_IMAGE_WIDTH",640);

// NEWSLETTER MODUL
define("MOD_NEWSLETTER_TEMPLATE","/newsletter.html");
define("MOD_NEWSLETTER_PATH","./newsletter/");
define("MOD_NEWSLETTER_FILENAME_PREFIX","newsletter_");
define("MOD_NEWSLETTER_FILENAME_POSTFIX","");
define("MOD_NEWSLETTER_FILENAME_EXTENSION",".eml");
define("MOD_NEWSLETTER_SMTP_HOST","");
define("MOD_NEWSLETTER_SMTP_PORT",25);
define("MOD_NEWSLETTER_SMTP_AUTH",true);
define("MOD_NEWSLETTER_SMTP_USER","");
define("MOD_NEWSLETTER_SMTP_PASS","");
define("MOD_NEWSLETTER_LISTS_PATH","");
define("MOD_NEWSLETTER_DEFAULT_LIST","recipients.txt");
define("MOD_NEWSLETTER_BLACK_LIST","blacklist.txt");
define("MOD_NEWSLETTER_NAME_FROM","newsletter@twebshop.de");
define("MOD_NEWSLETTER_EMAIL_FROM","newsletter@twebshop.de");
define("MOD_NEWSLETTER_EMAIL_TO","newsletter@twebshop.de");
define("MOD_NEWSLETTER_EMAIL_RETURN_PATH","newsletter@twebshop.de");
define("MOD_NEWSLETTER_EMAIL_REPLY_TO","newsletter@twebshop.de");
define("MOD_NEWSLETTER_FORCE_CC",false);
define("MOD_NEWSLETTER_RECIPIENTS_PER_SEND_COMMAND",10000);

// UPLOAD MODUL
define("MOD_UPLOAD_SAVE_PATH","");

// MP3-DOWNLOADS
define("MP3_DOWNLOAD_POSTFIX","-9");
define("MP3_DOWNLOAD_LOG_PATH","");
define("MP3_DOWNLOAD_LOG_NAME","download.log");

// VERZEICHNISSE
define("SHOP_WWW",         "http://localhost/TWebShop/");
define("SHOP_ROOT",        "C:\Temp\Build\TWebShop");
define("SHOP_SITEMAP_DIR", "sitemap/");
define("SHOP_PARTS_DIR",   "HeBuParts/");

?>
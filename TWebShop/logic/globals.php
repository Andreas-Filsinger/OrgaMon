<?php
// GLOBAL Variable, die inerhalb der URL übertragen werden, z.B. "$site" kommt via index.php?site=test
// diese (und nicht mehr!) sollten auch im gloablen Kontext sichtbar sein!
// GLOBALE VARIABLEN, DIE REGISTRIERT WERDEN SOLLEN
// SYNTAX: string NAME => new tvariable(string NAME, const TYP, array(VALIDATE-METHODE=>FEHLERMELDUNG), array(FILTER_METHODE), const STANDARDWERT)
$_GLOBALS = array(
// Seite, die aufgerufen werden soll
    "site" => new tglobal("site", T_VARIABLE_TYPE_STRING),
// Aktion, die durchgeführt werden soll
    "action" => new tglobal("action", T_VARIABLE_TYPE_STRING),
// Aktion ID
    "aid" => new tglobal("aid", T_VARIABLE_TYPE_INTEGER),
// ID (Artikel, Person, ...), kein INT, da crypted
    "id" => new tglobal("id", T_VARIABLE_TYPE_STRING),
// Unique Artikel-ID
    "uid" => new tglobal("uid", T_VARIABLE_TYPE_STRING),
// Version ID fix    
    "vid" => new tglobal("vid", T_VARIABLE_TYPE_INTEGER),
// Such-ID    
    "sid" => new tglobal("sid", T_VARIABLE_TYPE_INTEGER),
// Merklisten-ID    
    "wid" => new tglobal("wid", T_VARIABLE_TYPE_INTEGER),
// Unterseite, die aufgerufen werden soll
    "page" => new tglobal("page", T_VARIABLE_TYPE_INTEGER),
// Unterseite, die aufgerufen werden soll
    "subsite" => new tglobal("subsite", T_VARIABLE_TYPE_STRING),
// URL
    "url" => new tglobal("url", T_VARIABLE_TYPE_STRING),
// Sortierungstyp
    "type" => new tglobal("type", T_VARIABLE_TYPE_INTEGER),
// Sucheingabe des Benutzers über ein Form ("f_")
    "f_search_expression" => new tglobal("f_search_expression", T_VARIABLE_TYPE_STRING, array("form_input", "trim"), array("not_empty" => ERROR_NO_SEARCH_EXPRESSION_WAS_ENTERED)),
// Menge
    "f_quantity" => new tglobal("f_quantity", T_VARIABLE_TYPE_INTEGER, array("form_input")),
// Version ID aus Form
    "f_version_r" => new tglobal("f_version_r", T_VARIABLE_TYPE_INTEGER, array("form_input"), array("numeric_int" => NULL)),
// Detailangaben zu einem Artikel
    "f_detail" => new tglobal("f_detail", T_VARIABLE_TYPE_STRING, array("form_input")),
// Kundennummer
    "f_customer_no" => new tglobal("f_customer_no", T_VARIABLE_TYPE_INTEGER, array("form_input", "trim"), array("not_empty" => ERROR_NO_CUSTOMER_NO_GIVEN, "numeric_int" => ERROR_INVALID_CUSTOMER_NO)),
// Vorname
    "f_firstname" => new tglobal("f_firstname", T_VARIABLE_TYPE_STRING, array("form_input", "ucwords", "trim"), array("not_empty" => ERROR_NO_NAME_GIVEN)),
// Nachname
    "f_surname" => new tglobal("f_surname", T_VARIABLE_TYPE_STRING, array("form_input", "ucwords", "trim"), array("not_empty" => ERROR_NO_NAME_GIVEN)),
// Benutzername, Eingabe über ein Form
    "f_user" => new tglobal("f_user", T_VARIABLE_TYPE_STRING, array("form_input_low"), array("not_empty" => ERROR_NO_EMAIL_GIVEN, "email" => ERROR_INVALID_EMAIL)),
// Telefonnummer
    "f_phone" => new tglobal("f_phone", T_VARIABLE_TYPE_STRING, array("form_input", "trim")),
// Faxnummer
    "f_fax" => new tglobal("f_fax", T_VARIABLE_TYPE_STRING, array("form_input", "trim")),
// Zusatz-Name (Verein, Firma,...)
    "f_name" => new tglobal("f_name", T_VARIABLE_TYPE_STRING, array("form_input", "no_quotes")),
// Postleitzahl
    "f_zip_code" => new tglobal("f_zip_code", T_VARIABLE_TYPE_INTEGER, array("form_input", "trim"), array("not_empty" => ERROR_NO_ZIP_GIVEN, "numeric_int" => ERROR_INVALID_ZIP)),
// Land RID
    "f_country_r" => new tglobal("f_country_r", T_VARIABLE_TYPE_INTEGER, array("form_input")),
// Strasse
    "f_street" => new tglobal("f_street", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_ADDRESS_GIVEN)),
// Bundesland/Bundesstaat
    "f_state" => new tglobal("f_state", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_STATE_GIVEN)),
// Ort
    "f_city" => new tglobal("f_city", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_CITY_GIVEN)),
// Passwort, Eingabe über ein Form
    "f_pass" => new tglobal("f_pass", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_PASSWORD_GIVEN)),
// Passwort Bestätigung, Eingabe über ein Form
    "f_pass_confirm" => new tglobal("f_pass_confirm", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_PASSWORD_GIVEN)),
// Mailings, Eingabe über Form
    "f_mailings" => new tglobal("f_mailings", T_VARIABLE_TYPE_ARRAY),
// Hilfe Frage/Request
    "f_help_request" => new tglobal("f_help_request", T_VARIABLE_TYPE_STRING, array("form_input", "trim", "no_quotes"), array("not_empty" => ERROR_TEXT_FIELD_IS_EMPTY)),
// ID der Lieferadresse, aus Form
    "f_dcontact_r" => new tglobal("f_dcontact_r", T_VARIABLE_TYPE_INTEGER),
// ID der Rechnungsadresse, aus Form
    "f_bcontact_r" => new tglobal("f_bcontact_r", T_VARIABLE_TYPE_INTEGER),
// Auswahl über Form
    "f_choice" => new tglobal("f_choice", T_VARIABLE_TYPE_STRING),
// OrgaTix Ticket Info-Text
    "f_orgatix_ticket_info" => new tglobal("f_orgatix_ticket_info", T_VARIABLE_TYPE_STRING, array("form_input", "trim", "no_quotes"), array("not_empty" => ERROR_TEXT_FIELD_IS_EMPTY)),
// OrgaTix Ticket Aktion-Text
    "f_orgatix_ticket_action" => new tglobal("f_orgatix_ticket_action", T_VARIABLE_TYPE_STRING, array("form_input", "trim", "no_quotes"), array("not_empty" => ERROR_TEXT_FIELD_IS_EMPTY)),
// OrgaTix Bearbeiter ID
    "f_orgatix_processor_id" => new tglobal("f_orgatix_processor_id", T_VARIABLE_TYPE_INTEGER),
// Newsletter-Modul: Betreff über Form
    "f_subject" => new tglobal("f_subject", T_VARIABLE_TYPE_STRING, array("form_input", "trim", "no_quotes")),
// Newsletter-Modul, Upload-Modul: Text über Form
    "f_text" => new tglobal("f_text", T_VARIABLE_TYPE_STRING, array(), array("not_empty" => ERROR_TEXT_FIELD_IS_EMPTY)),
// Upload-Modul: Autor
    "f_author" => new tglobal("f_author", T_VARIABLE_TYPE_STRING, array("form_input", "ucwords", "trim"), array("not_empty" => ERROR_NO_NAME_GIVEN)),
// Upload-Modul: Verband
    "f_association" => new tglobal("f_association", T_VARIABLE_TYPE_STRING, array("form_input")),
// Upload-Modul: Verein
    "f_member" => new tglobal("f_member", T_VARIABLE_TYPE_STRING, array("form_input")),
// Upload-Modul: Ausgabe
    "f_edition" => new tglobal("f_edition", T_VARIABLE_TYPE_STRING, array("form_input")),
// Zahlungsart: Zahlungsart
    "f_payment" => new tglobal("f_payment", T_VARIABLE_TYPE_INTEGER),
// Zahlungsart: Kontoinhaber
    "f_depositor" => new tglobal("f_depositor", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_DEPOSITOR_GIVEN)),
// Zahlungsart: IBAN (international bank account number)
    "f_ban" => new tglobal("f_ban", T_VARIABLE_TYPE_STRING, array("form_input"), array("iban" => ERROR_INVALID_BAN)),
// Zahlungsart: Name der Bank
    "f_bank" => new tglobal("f_bank", T_VARIABLE_TYPE_STRING, array("form_input"), array("not_empty" => ERROR_NO_BANK_GIVEN)),
// Zahlungsart: BIC (bank identification code)
    "f_bic" => new tglobal("f_bic", T_VARIABLE_TYPE_STRING, array("form_input"), array("bic" => ERROR_INVALID_BIC)),
// Datum 
    "f_date" => new tglobal("f_date", T_VARIABLE_TYPE_STRING, array("form_input"), array("date" => ERROR_INVALID_DATE))
);

$j = 0;
$count = count($_GET) + count($_POST);
$_REGISTRATION_ERRORS = array();
foreach ($_GLOBALS as $_TGLOBAL) {
    $j += ($_TGLOBAL->register($_REGISTRATION_ERRORS)) ? 1 : 0;
    if ($j == $count) {
        break;
    }
}
unset($j);
unset($count);
unset($_TGLOBAL);
?>
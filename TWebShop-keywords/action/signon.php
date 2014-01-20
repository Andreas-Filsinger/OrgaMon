<?php

$country_r = $session->getTmpVar("country_r", $shop->getCurrentSite());
$person = $session->getTmpVar("person", $shop->getCurrentSite());
$address = $session->getTmpVar("address", $shop->getCurrentSite());

if ($person->isInDataBase()) { //$messagelist->add("Verdacht auf Doppelregistrierung");
    // -> LOG !
    $orgamon->sendMail(
            /**/ EMAIL_ADMIN,
            /**/ SYS_SENTENCE_USER_MAYBE_REGISTERED_TWICE,
            /**/ SYS_WORD_USER_ID . ":" . $person->getID() . CRLF .
            /**/ "VORNAME:" . $person->VORNAME . CRLF .
            /**/ "NACHNAME:" . $person->NACHNAME . CRLF .
            /**/ "USER_ID:" . $person->USER_ID . CRLF
    );
}

if ($person->setID($orgamon->newPerson()) != 0 AND $person->updateInDataBase()) {
    $person = new twebshop_user($person->getID());
    //$messagelist->add($person->getFromHTMLTemplate(VARIABLE_SENTENCE_HELLO_X));
    $messagelist->add(SENTENCE_THANK_YOU_FOR_SIGNING_ON);
    $messagelist->add($person->getFromHTMLTemplate(VARIABLE_SENTENCE_YOU_ARE_NOW_SIGNEDON_AS_CUSTOMER_NO_X));
    if ($person->sendPassword())
        $messagelist->add($person->getFromHTMLTemplate(VARIABLE_SENTENCE_YOUR_PASSWORD_WILL_BE_SENT_TO_X));
    //$messagelist->add(load_txt(__LANGUAGE_PATH.__LANGUAGE."/signon-finish.txt"),true,true);
    $address->setID($person->PRIV_ANSCHRIFT_R);
    if (!$address->updateInDataBase()) {
        $errorlist->add(ERROR_YOUR_ADDRESS_COULD_NOT_BE_SAVED);
    }
    $site->setName("login");
    setcookie("c_user", $person->USER_ID, time() + 60 * 60 * 24);
    $c_user = $person->USER_ID;
    // -> LOG !
} else {
    $errorlist->add(ERROR_YOUR_CUSTOMER_DATA_COULD_NOT_BE_SAVED);
}
?>
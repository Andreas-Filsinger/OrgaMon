<?php
if (isset($f_user))
    $errorlist->clear();

if (($person_r = twebshop_person::doeseMailExist($f_user)) != 0) { //$messagelist->add("eMailadresse existiert ($person_r).");
    $tmp_person = new twebshop_person($person_r);
    if ($tmp_person->isUser()) {
        header("Location: ?site=myshop&subsite=mailings");
    } else {
        require_once("./action/newsletter_signon_send_activation.php");
    }
} else { //$messagelist->add("eMailadresse unbekannt ($person_r).");
    $tmp_person = new twebshop_person(0, $f_firstname, $f_surname, "", $f_user);
    if ($tmp_person->setID($orgamon->newPerson()) != 0 AND $tmp_person->updateInDataBase()) {
        $messagelist->add(SENTENCE_YOUR_EMAIL_ADDRESS_HAS_BEEN_APPLIED);
        require_once("./action/newsletter_signon_send_activation.php");
    }
}

unset($person_r);
unset($tmp_person);

<?php
if (isset($f_user))
    $errorlist->clear();

if (($person_r = twebshop_person::doeseMailExist($f_user)) != 0) { //$messagelist->add("eMailadresse existiert ($person_r).");
    $tmp_person = new twebshop_person($person_r);
    if ($tmp_person->isUser()) {
        header("Location: ?site=myshop&subsite=mailings");
    } else {
        include_once("./action/newsletter_signout_send_activation.php");
    }
} else { //$messagelist->add("eMailadresse unbekannt ($person_r).");
}

unset($person_r);
unset($tmp_person);
?>
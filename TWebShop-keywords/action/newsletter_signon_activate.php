<?php
$site->setName("newsletter");

if (isset($f_user) AND ($person_r = twebshop_person::doeseMailExist($f_user)) != 0) {
    $tmp_person = new twebshop_person($person_r);
    if ($tmp_person->getIDasHash() == $id) {
        $mailings = new twebshop_mailings($tmp_person->getID());
        if (!$mailings->isActive(TWEBSHOP_BILL_R_NEWSLETTER)) {
            $ids = array_merge($mailings->getActiveIDs(), array(TWEBSHOP_BILL_R_NEWSLETTER));
            $mailings->updateInDataBase($ids);
            $messagelist->add(SENTENCE_YOUR_EMAIL_ADDRESS_HAS_BEEN_ADDED_TO_NEWSLETTER);
        }
        else
            $messagelist->add(SENTENCE_YOUR_EMAIL_ADDRESS_HAS_BEEN_ADDED_TO_NEWSLETTER);
        unset($mailings);
    }
    else {
        $errorlist->add(ERROR_IDENTIFICATION_CODE_SENT_DOESNT_MATCH);
    }
}
else
    $errorlist->add(ERROR_INVALID_EMAIL);
?>
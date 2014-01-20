<?php

if (($person_r = twebshop_user::getRIDbyUserID($f_user)) !== false) {
    $messagelist->add(SENTENCE_YOUR_LOGIN_DATA_WILL_BE_SENT);
    twebshop_user::sendUserPassword($person_r);
    $site->setName("login");
}

unset($person_r);
?>
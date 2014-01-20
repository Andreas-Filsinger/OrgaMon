<?php

if (!$errorlist->error) {
    if (($rid = twebshop_user::registerUser($f_customer_no, $f_surname, $f_zip_code, $f_user)) != false) {
        $person = new twebshop_user($rid);
        $messagelist->add(SENTENCE_YOU_HAVE_BEEN_REGISTERED_AS_WEBSHOP_USER);
        $messagelist->add($person->getFromHTMLTemplate(VARIABLE_SENTENCE_YOUR_PASSWORD_WILL_BE_SENT_TO_X));
        $person->sendPassword();
        setcookie("c_user", $f_user, time() + 60 * 60 * 24);
        $c_user = $f_user;
        $site->setName("login");
        unset($person);
    } else {
        $errorlist->add(ERROR_YOUR_INFORMATION_DOESNT_CORRESPOND);
        $site->setName("register");
    }
    unset($rid);
} else {
    $site->setName("register");
}
?>
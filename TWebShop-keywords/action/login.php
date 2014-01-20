<?php

$c_user = $f_user;

if (!$user->loggedIn()) {
    if ($user->logIn($f_user, $f_pass)) {
        setcookie("c_user", $f_user, time() + 60 * 60 * 24); // eMailadresse merken fürs Login-Formular in site/login.php

        
        $messagelist->add(SENTENCE_LOGIN_SUCCESSFUL);
        $messagelist->add($user->getFromHTMLTemplate(VARIABLE_SENTENCE_LOGGED_IN_AS_X));

        $cart->setPerson($user->getID());
        $cart->synchronizeWithDataBase();
        $messagelist->add(SENTENCE_YOUR_CART_HAS_BEEN_UPDATED);

        $shop->loadVars("login");
    } else {
        $errorlist->add(ERROR_LOGIN_FAILED);
    }
} else {
    $messagelist->add(SENTENCE_YOU_ARE_ALREADY_LOGGED_IN);
}
?>
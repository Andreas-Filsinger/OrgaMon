<?php

if (twebshop_user::existsUserID($f_user) !== false) 
{ $errorlist->add(ERROR_USERID_ALREADY_EXISTS);
}

$session->registerTmpVar("person",new twebshop_person(0, $f_firstname, $f_surname, $f_user, $f_user, $f_phone, $f_fax),$shop->getCurrentSite());
$session->registerTmpVar("address",new twebshop_address(0, $session->getTmpVar("country_r",$shop->getCurrentSite()), $f_street, $f_zip_code, $f_city, $_GLOBALS["f_state"]->getValue(""), $_GLOBALS["f_name"]->getValue("")),$shop->getCurrentSite());

if (!$errorlist->error)
{ $session->registerTmpVar("step",$session->getTmpVar("step",$shop->getCurrentSite()) + 1,$shop->getCurrentSite());
}

?>
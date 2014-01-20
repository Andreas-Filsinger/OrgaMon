<?php
$site->setName("register");
$site->setTitle(SENTENCE_ACCESS_VIA_CUSTOMER_NO);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);
$site->autoAddConstants();

if ($site->isActive()) {
    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
    $site->addComponent("VAR_F_CUSTOMER_NO", isset($f_customer_no) ? $f_customer_no : "");
    $site->addComponent("VAR_F_SURNAME", isset($f_surname) ? $f_surname : "");
    $site->addComponent("VAR_F_ZIP_CODE", isset($f_zip_code) ? $f_zip_code : "");
    $site->addComponent("VAR_F_USER", isset($f_user) ? $f_user : "");
}
?>




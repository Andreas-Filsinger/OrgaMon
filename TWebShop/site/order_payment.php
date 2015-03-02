<?php
if ($site->isActive()) {

    $default_payment = 0;
    $obj_payment_infos = "";

    /* --> 27.02.2015 michaelhacksoftware : Lastschriftdaten von der Person holen */
    $payment_info = $user->getPaymentInfo();

    if ($payment_info->getType() == $session->getTmpVar("type", $shop->getCurrentSite(), PAYMENT_DIRECT_DEBITING)) {
        $default_payment = $payment_info->getID();
        $payment_info->addOption("CHECKED", $payment_info->getID() == $session->getTmpVar("payment", $shop->getCurrentSite(), $default_payment) ? "checked=\"checked\"" : "");
        $obj_payment_infos .= $payment_info->getFromHTMLTemplate(_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_PREVIOUS);
    }
    /* <-- */

    $payment_info = new twebshop_payment_info(0, PAYMENT_DIRECT_DEBITING);
    $payment_info->setDepositor($session->getTmpVar("depositor", $shop->getCurrentSite(), ""));
    $payment_info->setBAN($session->getTmpVar("ban", $shop->getCurrentSite(), ""));
    $payment_info->setBank($session->getTmpVar("bank", $shop->getCurrentSite(), ""));
    $payment_info->setBIC($session->getTmpVar("bic", $shop->getCurrentSite(), ""));
    $payment_info->addOption("DEPOSITOR", _TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_DEPOSITOR);
    $payment_info->addOption("BAN", _TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BAN);
    $payment_info->addOption("BANK", _TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BANK);
    $payment_info->addOption("BIC", _TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BIC);
    $payment_info->addOption("CHECKED", $payment_info->getID() == $session->getTmpVar("payment", $shop->getCurrentSite(), $default_payment) ? "checked=\"checked\"" : "");
    $obj_payment_infos.= $payment_info->getFromHTMLTemplate(_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW);
    unset($payment_info);

    $site->addComponent("OBJ_PAYMENT_INFOS", $obj_payment_infos);

    unset($obj_payment_infos);
}
?>
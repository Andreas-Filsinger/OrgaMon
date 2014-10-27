<?php

$session->registerTmpVar("payment", $f_payment, $shop->getCurrentSite());
$session->registerTmpVar("type", $type, $shop->getCurrentSite());

if ($f_payment != 0) {
    $errorlist->clear();

    $session->registerTmpVar("step", $session->getTmpVar("step", $shop->getCurrentSite()) + 1, $shop->getCurrentSite());
} else {
    $session->registerTmpVar("depositor", $f_depositor, $shop->getCurrentSite());
    $session->registerTmpVar("ban", $f_ban, $shop->getCurrentSite());
    $session->registerTmpVar("bank", $f_bank, $shop->getCurrentSite());
    $session->registerTmpVar("bic", $f_bic, $shop->getCurrentSite());

    if ($type == twebshop_payment_info::PAYMENT_INFO_TYPE_DIRECT_DEBITING AND
            $_GLOBALS["f_depositor"]->isValid() AND
            $_GLOBALS["f_ban"]->isValid() AND
            $_GLOBALS["f_bank"]->isValid() AND
            $_GLOBALS["f_bic"]->isValid()
    ) {
        $session->registerTmpVar("step", $session->getTmpVar("step", $shop->getCurrentSite()) + 1, $shop->getCurrentSite());
    }
}
?>
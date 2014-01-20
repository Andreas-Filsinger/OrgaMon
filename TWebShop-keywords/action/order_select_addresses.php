<?php
$session->registerTmpVar("dcontact_r", $f_dcontact_r, $shop->getCurrentSite());
$session->registerTmpVar("bcontact_r", $f_bcontact_r, $shop->getCurrentSite());

//TS 02-01-2012: Rechnung an Rechnungsanschrift schicken?
// -1: keine Angabe nötig/möglich, da Rechnungs- und Lieferadresse identisch
//  0: Haken nicht gesetzt: Rechnung der Lieferung beilegen (an Lieferanschrift)
//  1: Haken gesetzt: Rechnung separat an Rechnungsanschrift senden
$tmp_bill_delivery_type = twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED;
if ($f_dcontact_r != $f_bcontact_r) {
    if (isset($f_choice)) {
        $tmp_bill_delivery_type = twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_SEND_SEPARATELY;
    } else {
        $tmp_bill_delivery_type = twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_WITH_SHIPPING;
    }
}
$session->registerTmpVar("bill_delivery_type", $tmp_bill_delivery_type, $shop->getCurrentSite());
unset($tmp_bill_delivery_type);

$session->registerTmpVar("step", $session->getTmpVar("step", $shop->getCurrentSite()) + 1, $shop->getCurrentSite());
?>

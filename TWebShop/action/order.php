<?php

if ($session->getTmpVar("tob_accepted", $shop->getCurrentSite())) {

    $Summary = $cart->getOrderSummary($user->showDiscount()); // 02.02.15 michaelhacksoftware: Zusammenfassung für Bestätigungsmail erstellen
    $beleg_r = $orgamon->execOrder($user->getID());

    while (true) {
        
        if ($errorlist->error) {
            unset($subsite);
            break;
        }    
        
        if ($beleg_r<1) {
           $errorlist->add(ERROR_ORDER_NOT_SENT);
           unset($subsite);
           break;
        }

        $bill = new twebshop_bill($beleg_r);
        $bill->setBillContact($session->getTmpVar("bcontact_r", $shop->getCurrentSite()));
        $bill->setDeliveryContact($session->getTmpVar("dcontact_r", $shop->getCurrentSite()));
        $bill->setDate($session->getTmpVar("date", $shop->getCurrentSite()));
        $bill->setDeliveryType($session->getTmpVar("bill_delivery_type", $shop->getCurrentSite()));

        /* --> 27.02.2015 michaelhacksoftware : Zahlungsinfos direkt im Beleg speichern */
        if ($session->isRegisteredTmp("payment", $shop->getCurrentSite())) {

            $payment_info = new twebshop_payment_info($session->getTmpVar("payment", $shop->getCurrentSite()));

            if ($payment_info->getID() == 0) {
                $payment_info->setDepositor($session->getTmpVar("depositor", $shop->getCurrentSite()));
                $payment_info->setBAN($session->getTmpVar("ban", $shop->getCurrentSite()));
                $payment_info->setBank($session->getTmpVar("bank", $shop->getCurrentSite()));
                $payment_info->setBIC($session->getTmpVar("bic", $shop->getCurrentSite()));
                $payment_info->setType($session->getTmpVar("type", $shop->getCurrentSite()));
            }

            $bill->setPaymentInfo($payment_info);
            $bill->setModeOfPayment(4);

        }
        /* <-- */
        
        if (!$bill->updateInDataBase()) {
            $errorlist->add(ERROR_BILL_AND_DELIVERY_CONTACTS_COULD_NOT_BE_SAVED);
            //Loggen? eMail an Admin?
        }

        if (($orgamon->execAccounting($beleg_r, $user->getID()) < 1) AND $cart->containsVersion($article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3))) {
            $event = $bill->getEvent(torgamon_event::eT_WebShopBestellung);
            $info  = $event->getInfo();
            if (strpos($info, "Zahlungspflichtiger") == FALSE) { // Vorrübergehend Fehler direkt auslassen --> Orgamon anpassen
                $errorlist->add($info);
            }
            unset($event);
        }

        $site->setName("myshop");
        if ($cart->containsVersion($article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3))) {
            $subsite = "mymusic";
        } else {
            $subsite = "order_state";
        }

        $cart->clear();

        $beleg_no = twebshop_bill::formatBillNumber($beleg_r, 0);
        $message = str_replace("~BELEG_NO~", $beleg_no, VARIABLE_SENTENCE_YOUR_ORDER_HAS_BEEN_PLACED_UNDER_BILL_NO_X);

        $messagelist->add($message);

        /* --> 02.02.2015 michaelhacksoftware: Detaillierte Bestellübersicht */
        if ($bill->TERMIN != "01.01.1970") {
            $Delivery = CRLF . SENTENCE_EXPECTED_DATE_OF_DELIVERY . ": " . $bill->TERMIN . CRLF;
        } else {
            $Delivery = "";
        }
        
        $Template = $user->getFromHTMLTemplate(_TEMPLATE_PERSON_ORDER_EMAIL);
        
        $Template = str_replace("~BELEG_NO~",         $beleg_no,            $Template);
        $Template = str_replace("~ORDER_LIST_ITEMS~", $Summary['Items'],    $Template);
        $Template = str_replace("~ORDER_SUM_SHIP~",   $Summary['Shipping'], $Template);
        $Template = str_replace("~ORDER_SUM_TOTAL~",  $Summary['Total'],    $Template);
        $Template = str_replace("~ORDER_DELIVERY~",   $Delivery,            $Template);

        $orgamon->sendMail($user->getID(), $message, $Template);
        /* <-- */
        
        $messagelist->add(SENTENCE_YOU_WILL_RECEIVE_A_CONFIRMATION_EMAIL);
        break;
    }
    unset($bill);
    unset($message);
    unset($beleg_no);
    unset($beleg_r);
} else {
    $errorlist->add(ERROR_ORDER_NOT_SENT);
    unset($subsite);
}
?>
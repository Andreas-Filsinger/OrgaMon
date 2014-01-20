<?php

if ($session->getTmpVar("tob_accepted", $shop->getCurrentSite())) {

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

        if ($session->isRegisteredTmp("payment", $shop->getCurrentSite())) {
            $payment_info = new twebshop_payment_info($session->getTmpVar("payment", $shop->getCurrentSite()));
            if ($payment_info->getID() == 0) {
                $payment_info->setID($orgamon->newPerson());
                $payment_info->setDepositor($session->getTmpVar("depositor", $shop->getCurrentSite()));
                $payment_info->setBAN($session->getTmpVar("ban", $shop->getCurrentSite()));
                $payment_info->setBank($session->getTmpVar("bank", $shop->getCurrentSite()));
                $payment_info->setBIC($session->getTmpVar("bic", $shop->getCurrentSite()));
                if (!$payment_info->updateInDataBase()) {
                    $errorlist->add(ERROR_PAYMENT_INFO_COULD_NOT_BE_SAVED);
                    //Loggen? eMail an Admin?
                }
            }
            $bill->setPayer($payment_info->getID());
            $bill->setModeOfPayment(4);
            unset($payment_info);
        }

        if (!$bill->updateInDataBase()) {
            $errorlist->add(ERROR_BILL_AND_DELIVERY_CONTACTS_COULD_NOT_BE_SAVED);
            //Loggen? eMail an Admin?
        }

        if (($orgamon->execAccounting($beleg_r, $user->getID()) < 1) AND $cart->containsVersion($article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3))) {
            $event = $bill->getEvent(torgamon_event::eT_WebShopBestellung);
            $errorlist->add($event->getInfo());
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

        $orgamon->sendMail($user->getID(), $message, str_replace("~BELEG_NO~", $beleg_no, $user->getFromHTMLTemplate(_TEMPLATE_PERSON_ORDER_EMAIL)));
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
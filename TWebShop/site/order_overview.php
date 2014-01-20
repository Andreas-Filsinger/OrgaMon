<?php
if ($site->isActive()) {
    $template->setTemplates(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_ORDER,
        twebshop_cart::CLASS_NAME => _TEMPLATE_CART_ORDER,
        twebshop_article_variants::CLASS_NAME => _TEMPLATE_VERSIONS_ORDER,
        twebshop_price::CLASS_NAME => _TEMPLATE_PRICE_ORDER,
        twebshop_delivery::CLASS_NAME => _TEMPLATE_PRICE_ORDER_DELIVERY,
        twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_ORDER_OVERVIEW,
        twebshop_user::CLASS_NAME => _TEMPLATE_PERSON_ORDER_OVERVIEW,
        twebshop_address::CLASS_NAME => "~STREET~<br />" . $user->getAddressFormatAsHTMLTemplate(false),
        twebshop_payment_info::CLASS_NAME => _TEMPLATE_PAYMENT_INFO_ORDER_OVERVIEW,
        twebshop_bill_delivery_type::CLASS_NAME => _TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW));

    $cart->buildSum(true);

    $site->getCurrentStep()->addComponent("OBJ_CART", $cart->getFromHTMLTemplate($template));

    $contact_bill = new twebshop_person($session->getTmpVar("bcontact_r", $shop->getCurrentSite()));
    $contact_bill->getAddress();

    $contact_delivery = new twebshop_person($session->getTmpVar("dcontact_r", $shop->getCurrentSite()));
    $contact_delivery->getAddress();

    $obj_payment_info = "";
    if ($session->getTmpVar("payment", $shop->getCurrentSite(), NULL) !== NULL) {
        $payment_info = new twebshop_payment_info($session->getTmpVar("payment", $shop->getCurrentSite()));
        if ($payment_info->getID() == 0) {
            $payment_info->setDepositor($session->getTmpVar("depositor", $shop->getCurrentSite()));
            $payment_info->setBAN($session->getTmpVar("ban", $shop->getCurrentSite()));
            $payment_info->setBank($session->getTmpVar("bank", $shop->getCurrentSite()));
            $payment_info->setBIC($session->getTmpVar("bic", $shop->getCurrentSite()));
            $payment_info->setType($session->getTmpVar("type", $shop->getCurrentSite()));
        }
        $obj_payment_info = $payment_info->getFromHTMLTemplate($template);
        unset($payment_info);
    }

    $obj_date = "";
    if ($session->isRegisteredTmp("date", $shop->getCurrentSite())) {
        $obj_date = str_replace("~DATE~", date("d.m.Y", $session->getTmpVar("date", $shop->getCurrentSite())), _TEMPLATE_ORDER_ORDER_OVERVIEW_OPTION_DATE);
    }

    $bill_delivery_type = new twebshop_bill_delivery_type(0, $session->getTmpVar("bill_delivery_type", $shop->getCurrentSite()));
    switch ($bill_delivery_type->getType()) {
        case(twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_WITH_SHIPPING): {
                $bill_delivery_type->addOption("STRING", _TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_WITH_SHIPPING);
                break;
            }
        case(twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_SEND_SEPARATELY): {
                $bill_delivery_type->addOption("STRING", _TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_SEND_SEPARATELY);
                break;
            }
        case(twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED):
        default: $bill_delivery_type->addOption("STRING", _TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_NOT_DEFINED);
    }

    $site->addComponent("OBJ_CONTACT_BILL", $contact_bill->getFromHTMLTemplate($template));
    $site->addComponent("OBJ_CONTACT_DELIVERY", $contact_delivery->getFromHTMLTemplate($template));
    $site->addComponent("OBJ_BILL_DELIVERY_TYPE", $bill_delivery_type->getFromHTMLTemplate($template));
    $site->addComponent("OBJ_PAYMENT_INFO", $obj_payment_info);
    $site->addComponent("OBJ_DATE", $obj_date);

    unset($bill_delivery_type);
    unset($obj_date);
    unset($obj_payment_info);
    unset($contact_delivery);
    unset($contact_bill);
}
?>
<?php

if ($site->isActive()) 
{ $user->getAddress();
  
  $contacts_bill = array_merge(array($user),twebshop_bill::getFormerBillContacts($user->getID())); // array of twebshop_person & twebshop_user
  $contacts_delivery = array_merge(array($user),twebshop_bill::getFormerDeliveryContacts($user->getID())); // array of twebshop_person & twebshop_user
  
  $bcontact_r = $session->getTmpVar("bcontact_r",$shop->getCurrentSite(),$user->getID());
  $dcontact_r = $session->getTmpVar("dcontact_r",$shop->getCurrentSite(),$user->getID());
     
  $contacts = ""; 
  foreach($contacts_bill as $contact)
  { $template->setTemplates(array(twebshop_address::CLASS_NAME => "(~NAME1~&nbsp;~NAME2~),&nbsp;~STREET~,&nbsp;". $contact->getAddressFormatAsHTMLTemplate(false),
                                  twebshop_user::CLASS_NAME => _TEMPLATE_PERSON_ORDER_ADDRESSES_BILL,
		       				      twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_ORDER_ADDRESSES_BILL));
  
    $contact->addOption("CHECKED",($contact->getID() == $bcontact_r) ? "checked=\"checked\"" : "");
    $contacts .= $contact->getFromHTMLTemplate($template);
  }
  //$site->getCurrentStep()->addComponent("OBJ_DELIVERY_ADDRESSES", $addresses);
  $site->addComponent("OBJ_CONTACTS_BILL", $contacts);
    
  $contacts = "";
  foreach($contacts_delivery as $contact)
  { $template->setTemplates(array(twebshop_address::CLASS_NAME => "(~NAME1~&nbsp;~NAME2~),&nbsp;~STREET~,&nbsp;". $contact->getAddressFormatAsHTMLTemplate(false),
                                  twebshop_user::CLASS_NAME => _TEMPLATE_PERSON_ORDER_ADDRESSES_DELIVERY,
								  twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_ORDER_ADDRESSES_DELIVERY));
  
    $contact->addOption("CHECKED",($contact->getID() == $dcontact_r) ? "checked=\"checked\"" : "");
    $contacts .= $contact->getFromHTMLTemplate($template);
  }
  //$site->getCurrentStep()->addComponent("OBJ_DELIVERY_ADDRESSES", $addresses);
  $site->addComponent("OBJ_CONTACTS_DELIVERY", $contacts);
  
  $site->addComponent("VAR_BILL_DELIVERY_TYPE", ($session->getTmpVar("bill_delivery_type",$shop->getCurrentSite(), twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_NOT_DEFINED) == twebshop_bill_delivery_type::TWEBSHOP_BILL_DELIVERY_TYPE_SEND_SEPARATELY) ? "checked=\"checked\"" : "");
  
  unset($contact);
  unset($contacts);
  unset($contacts_delivery);
  unset($contacts_bill);
}

?>

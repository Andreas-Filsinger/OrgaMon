<?php

if ($site->isActive()) 
{ //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");
  
  //$template->setTemplates(array(twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_MYSHOP, 
  //                              twebshop_address::CLASS_NAME => _TEMPLATE_ADDRESS_MYSHOP));
  
  $user->clearHTMLTemplate();
  $user->getAddress();
  
  $user->address->addOption("ORT_FORMAT", $user->getAddressFormatAsHTMLTemplate());
  $user->address->addOption("STREET",_TEMPLATE_ADDRESS_MYSHOP_OPTION_STREET);
  $user->address->addOption("ZIP",_TEMPLATE_ADDRESS_MYSHOP_OPTION_ZIP);
  $user->address->addOption("STATE",_TEMPLATE_ADDRESS_MYSHOP_OPTION_STATE);
  $user->address->addOption("CITY",_TEMPLATE_ADDRESS_MYSHOP_OPTION_CITY);
  $user->address->addOption("NAME",_TEMPLATE_ADDRESS_MYSHOP_OPTION_NAME);
  $user->address->addOption("AID","~AID~");
  $user->addOption("AID","~AID~");
  $user->address->setHTMLTemplate(_TEMPLATE_ADDRESS_MYSHOP);
  unset($country);
  
  $site->getCurrentStep()->addComponent("OBJ_USER", $user->getFromHTMLTemplate(_TEMPLATE_PERSON_MYSHOP));
  //$site->getCurrentStep()->addComponent("OBJ_USER", $user->getFromHTMLTemplate($template));
}

?>
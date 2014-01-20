<?php

if ($site->isActive()) 
{ $country = new twebshop_country($country_r, $country_r);

  $person->addOption("FIRSTNAME",_TEMPLATE_PERSON_SIGNON_OPTION_FIRSTNAME);
  $person->addOption("SURNAME",_TEMPLATE_PERSON_SIGNON_OPTION_SURNAME);
  $person->addOption("USER",_TEMPLATE_PERSON_SIGNON_OPTION_USER);
  
  // NEU 25.11.2009 für HeBu2008
  //$person->addOption("CONFIRM",_TEMPLATE_PERSON_SIGNON_OPTION_CONFIRM);
  $person->addOption("PHONE",_TEMPLATE_PERSON_SIGNON_OPTION_PHONE);
  $person->addOption("FAX",_TEMPLATE_PERSON_SIGNON_OPTION_FAX);

  $address->addOption("ORT_FORMAT",twebshop_address::convertCountryFormatToTemplate($country->ORT_FORMAT,$country->ISO_KURZZEICHEN));
  $address->addOption("STREET",_TEMPLATE_ADDRESS_SIGNON_OPTION_STREET);
  $address->addOption("ZIP",_TEMPLATE_ADDRESS_SIGNON_OPTION_ZIP);
  $address->addOption("STATE",_TEMPLATE_ADDRESS_SIGNON_OPTION_STATE);
  $address->addOption("CITY",_TEMPLATE_ADDRESS_SIGNON_OPTION_CITY);
  $address->addOption("NAME",_TEMPLATE_ADDRESS_SIGNON_OPTION_NAME);
  
  $site->getCurrentStep()->addComponent("OBJ_PERSON", $person->getFromHTMLTemplate(_TEMPLATE_PERSON_SIGNON));
  $site->getCurrentStep()->addComponent("OBJ_ADDRESS_NAME", $address->getFromHTMLTemplate("~OPTION_NAME~"));
  $site->getCurrentStep()->addComponent("OBJ_ADDRESS", $address->getFromHTMLTemplate(_TEMPLATE_ADDRESS_SIGNON)); 
}

?>
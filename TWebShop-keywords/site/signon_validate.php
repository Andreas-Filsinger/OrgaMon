<?php

if ($site->isActive()) 
{ $country = new twebshop_country($country_r, $country_r);
  $address->addOption("ORT_FORMAT",twebshop_address::convertCountryFormatToTemplate($country->ORT_FORMAT,$country->ISO_KURZZEICHEN,false));
  
  $person->addOption("PHONE",(!empty($person->PRIV_TEL)) ? _TEMPLATE_PERSON_SIGNON_VALIDATE_OPTION_PHONE : "");
  $person->addOption("FAX",(!empty($person->PRIV_FAX)) ? _TEMPLATE_PERSON_SIGNON_VALIDATE_OPTION_FAX : "");
  $person->address = $address;
  
  $site->getCurrentStep()->addComponent("OBJ_PERSON", 
    $person->getFromHTMLTemplate(new ttemplate(array(
	  twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_SIGNON_VALIDATE,
	  twebshop_address::CLASS_NAME => _TEMPLATE_ADDRESS_SIGNON_VALIDATE
  ))));
  $site->getCurrentStep()->addComponent("OBJ_ADDRESS", $address->getFromHTMLTemplate(_TEMPLATE_ADDRESS_SIGNON_VALIDATE));
}

?>

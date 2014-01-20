<?php

if ($site->isActive()) 
{ $countries = new twebshop_countries($country_r);
  if ($country_r == 0)
  { $countries->setUserCountry(SHORT_COUNTRY);
  }
  foreach($countries->list as $rid => $country)
  { $country->addOption("SELECT",($countries->getRID() == $rid) ? _TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_SELECTED : _TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_UNSELECTED);
  }
  
  $site->getCurrentStep()->addComponent("OBJ_COUNTRIES", $countries->getFromHTMLTemplate($template));   
}

?>

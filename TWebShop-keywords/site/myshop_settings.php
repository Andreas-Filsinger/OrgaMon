<?php

if ($site->isActive()) 
{ //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");

  $user->clearHTMLTemplate();
  $user->addOption("DISCOUNT",$user->getsDiscount() ? _TEMPLATE_PERSON_MYSHOP_SETTINGS_OPTION_DISCOUNT : "");
  $user->addOption("USER_RABATT_" . ($user->getSettingShowDiscount() ? "Y" : "N"), "checked=\"checked\"");
  $user->addOption("AID","~AID~");
  $user->setHTMLTemplate(_TEMPLATE_PERSON_MYSHOP_SETTINGS_DISCOUNT);

  $site->addComponent("VAR_USER_TREFFERPROSEITE_{$user->getSettingHitsPerPage()}", "checked=\"checked\"");
  $site->addComponent("OBJ_USER_DISCOUNT", $user->getFromHTMLTemplate());
}

?>

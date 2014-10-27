<?php
define("CAPTION_BACK_BUTTON", "«&nbsp;" . WORD_BACK);
define("CAPTION_GOON_BUTTON", WORD_GOON . "&nbsp;»");

$site->setName("signon");
$site->setTitle(SENTENCE_ACCESS_AS_NEW_CUSTOMER);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) 
{ $template->setTemplates(array(twebshop_country::CLASS_NAME => _TEMPLATE_COUNTRY_SIGNON, 
                                twebshop_countries::CLASS_NAME => _TEMPLATE_COUNTRIES_SIGNON));

  $step = (!$session->isRegisteredTmp("step",$shop->getCurrentSite())) ? 1 : $session->getTmpVar("step",$shop->getCurrentSite());

  $session->registerTmpVar("step",$step,$shop->getCurrentSite());
 
  $site->setStep($step);

  $site->getCurrentStep()->addComponent("VAR_SITE", $shop->getCurrentSite());
  $site->getCurrentStep()->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
  
  $country_r = $session->getTmpVar("country_r",$shop->getCurrentSite(),0);
  $person = $session->getTmpVar("person",$shop->getCurrentSite(),new twebshop_person(0));
  $address = $session->getTmpVar("address",$shop->getCurrentSite(),new twebshop_address(0));

  $site->addComponent("VAR_STEP", $site->getStep());
  $site->addComponent("VAR_SITE_STEP_TITLE", $site->getCurrentStep()->getTitle());
  //$site->appendTitle($site->getCurrentStep()->getTitle()," : "); //Titel wird innerhalb $site->setStep() gesetzt
  include_once($site->getCurrentStepFileName());
  
  unset($step);
  unset($address);
  unset($person);
  unset($country_r);
}
?>

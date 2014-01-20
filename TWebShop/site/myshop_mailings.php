<?php

if ($site->isActive()) 
{ //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");

  $template->setTemplates(array(twebshop_mailings::CLASS_NAME => _TEMPLATE_MAILINGS, 
                                twebshop_mailing::CLASS_NAME => _TEMPLATE_MAILING));

  $mailings = twebshop_mailings::create($user->getID());
  $mailings->addOption("AID", $shop->getNextActionID());
  //$site->addComponent("OBJ_MAILINGS",$mailings->getFromHTMLTemplate($template));
  $site->getCurrentStep()->addComponent("OBJ_MAILINGS", $mailings->getFromHTMLTemplate($template));
}

?>
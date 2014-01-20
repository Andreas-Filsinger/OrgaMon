<?php

$site->setName("newsletter");
$site->setTitle(WORD_NEWSLETTER);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive())
{ 
  $site->addComponent("VAR_NEXT_ACTION_ID",$shop->getNextActionID());
  $site->addComponent("VAR_F_USER",isset($f_user) ? $f_user : "");
  $site->addComponent("VAR_F_FIRSTNAME",isset($f_firstname) ? $f_firstname : "");
  $site->addComponent("VAR_F_SURNAME",isset($f_surname) ? $f_surname : "");
  
}

?>
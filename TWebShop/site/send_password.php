<?php
$site->setName("send_password");
$site->setTitle(SENTENCE_FORGOTTEN_PASSWORD);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

//$site->deactivate();

if ($site->isActive()) {
    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
    $site->addComponent("VAR_C_USER", isset($c_user) ? $c_user : "");
}
?>
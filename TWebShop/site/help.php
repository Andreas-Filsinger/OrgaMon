<?php
$site->setName("help");
$site->setTitle(WORD_HELP);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
    $site->addComponent("VAR_F_HELP_REQUEST", (isset($f_help_request)) ? $f_help_request : "");
}
?>
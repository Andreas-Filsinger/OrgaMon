<?php
$site->setName("myshop");
$site->setTitle(SENTENCE_MY_SHOP);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    if (isset($subsite))
        $session->registerTmpVar("subsite", $subsite, $shop->getCurrentSite());

    $site->setStepByName($session->getTmpVar("subsite", $shop->getCurrentSite(), $site->getStepName()));

    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
    $site->addComponent("OBJ_WRITE_NEWSLETTER", $user->isService("Newsletter") ? "<a href=\"" . __INDEX . "?site=myshop&subsite=write_newsletter\">Newsletter schreiben</a>" : "");

    if (file_exists($site->getCurrentStepFileName()))
        include_once($site->getCurrentStepFileName());
}
?>

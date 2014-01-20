<?php
$site->setName("order");
$site->setTitle(SENTENCE_PLACE_ORDER);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    if ($cart->containsVersion($article_variants->getVersionIDByShortName(TWEBSHOP_ARTICLE_VERSION_SHORT_MP3))) {
        $site->activateStepByName("payment");
    }

    if ($cart->getAvailability(true)->getSoonest() == $cart->getAvailability()->getLatest()) {
        $site->deactivateStepByName("date");
    }

    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());

    $step = (!$session->isRegisteredTmp("step", $shop->getCurrentSite())) ? 1 : $session->getTmpVar("step", $shop->getCurrentSite());

    $session->registerTmpVar("step", $step, $shop->getCurrentSite());

    $site->setStep($step);

    $site->getCurrentStep()->addComponent("VAR_SITE", $shop->getCurrentSite());
    $site->getCurrentStep()->addComponent("VAR_LAST_SITE", ($shop->getLastSite() == $shop->getCurrentSite()) ? "cart" : $shop->getLastSite());
    $site->getCurrentStep()->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());

    $site->addComponent("VAR_STEP", $site->getStep());
    $site->addComponent("VAR_SITE_STEP_TITLE", $site->getCurrentStep()->getTitle());
    $site->addComponent("VAR_SITE_STEP_DESCRIPTION", $site->getCurrentStep()->getDescription());
    //$site->appendTitle($site->getCurrentStep()->getTitle()," : "); //Titel wird innerhalb $site->setStep() gesetzt
    // echo $site->getCurrentStep()->getTitle();
    if (file_exists($site->getCurrentStepFileName()))
        include_once($site->getCurrentStepFileName());
}
?>

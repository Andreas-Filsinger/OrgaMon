<?php
if ($site->isActive()) { //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");
    $template->setTemplates(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_MYSHOP_MYMUSIC,
        twebshop_mymusic::CLASS_NAME => _TEMPLATE_MYMUSIC_MYSHOP,
        twebshop_mymusic_item::CLASS_NAME => _TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM));

    if (!isset($action) AND $session->isRegisteredTmp("result", $shop->getCurrentSite())) {
        if ($session->getTmpVar("result", $shop->getCurrentSite()) == true) {
            $messagelist->add(SENTENCE_DOWNLOAD_WAS_SUCCESSFUL);
            $messagelist->add($session->getTmpVar("result_string", $shop->getCurrentSite()));
        } else {
            $errorlist->add(SENTENCE_DOWNLOAD_FAILED);
            $errorlist->add($session->getTmpVar("result_string", $shop->getCurrentSite()));
        }
        $session->unregisterTmpVar("result", $shop->getCurrentSite());
        $session->unregisterTmpVar("result_string", $shop->getCurrentSite());
    }

    $mymusic = $user->getMyMusic(true);

    for ($i = 0; $i < $mymusic->count(); $i++) {
        $mymusic->items[$i]->addOption("DOWNLOAD", ($mymusic->items[$i]->areDownloadsAvailable()) ? _TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM_OPTION_DOWNLOAD_LINK : _TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM_OPTION_DOWNLOAD_DISABLED);
    }

    $site->addComponent("OBJ_MYMUSIC", $mymusic->getFromHTMLTemplate($template));
}
?>
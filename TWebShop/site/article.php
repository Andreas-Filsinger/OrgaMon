<?php

$site->setName("article");
$site->setTitle(SENTENCE_ARTICLE_DETAIL_VIEW);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    $shop->loadVarsIfDontExist("s_article");
    $shop->saveVars("s_article", array("id"));

    $template->setTemplates(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_ARTICLE,
        twebshop_price::CLASS_NAME => $user->showDiscount() ? _TEMPLATE_PRICE_ARTICLE_DISCOUNT : _TEMPLATE_PRICE_ARTICLE,
        twebshop_availability::CLASS_NAME => _TEMPLATE_AVAILABILITY,
        twebshop_article_link::CLASS_NAME => _TEMPLATE_ARTICLE_LINK_ARTICLE_MEMBER
    ));

    $article = new twebshop_article($id);
    
    $article->getAll();
    $article->getInfo();
    $article->getMembers();

    /* --> 07.07.2014 michaelhacksoftware : Wenn AutoPlay vorgemerkt, dann in Artikelseite ausführen */
    if ($site->getAutoPlay()) {
        $article->setAutoPlay();
    }
    /* <-- */

    $article->addOption("CART", _TEMPLATE_ARTICLE_ARTICLE_OPTION_CART);
    $article->addOption("PLAY", (count($article->getSounds(true))  > 0) ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_PLAY : "");
    $article->addOption("DEMO", (count($article->getSounds(false)) > 0) ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_DEMO : "");
    $article->addOption("MINISCORE", ($article->getMiniScore($orgamon->getSystemString(torgamon::BASEPLUG_MINISCORE_PATH)) ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_MINISCORE : ""));
    $article->addOption("RECORDS", ($article->existRecords() ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_RECORDS : ""));
    $article->addOption("THUMB", (count($article->getThumbs()) > 0 ) ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_THUMB : "");
    $article->addOption("MP3", ($article->existsMP3Download()) ? _TEMPLATE_ARTICLE_ARTICLE_OPTION_MP3 : "" );

    $site->addComponent("OBJ_ARTICLE", $article->getFromHTMLTemplate($template));
    $site->addComponent("OBJ_PLAY",    $article->getPlayCode());
	
    $site->appendTitle($article->TITEL);
}
?>
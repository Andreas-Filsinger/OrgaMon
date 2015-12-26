<?php

// ehemals s_search, also eine "site"

$site->setName("search");
$site->setTitle(WORD_SEARCHRESULTS);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    $shop->loadVarsIfDontExist("s_search");
    $shop->saveVars("s_search", array("page", "sid"));

    //debug: $session->listVars();

    $template->setTemplates(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_SEARCH,
        twebshop_price::CLASS_NAME => $user->showDiscount() ? _TEMPLATE_PRICE_SEARCH_DISCOUNT : _TEMPLATE_PRICE_SEARCH,
        twebshop_availability::CLASS_NAME => _TEMPLATE_AVAILABILITY,
        twebshop_search_result_pages::CLASS_NAME => _TEMPLATE_SEARCH_RESULT_PAGES,
        tpages_index_option::CLASS_NAME => array(_TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION, _TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION_DISABLED, _TEMPLATE_SEARCH_RESULT_PAGES_ABC_INDEX_OPTION)
    ));


    tpages_index_option::setTemplateSelector("template_selector_tpages_index_option");

    function template_selector_tpages_index_option($param) {
        global $page;
        if ($param->getText() != "") {
            return 2;
        }
        if ($param->getPage() != $page) {
            return 0;
        } else {
            return 1;
        }
    }

    //Vorübergehendes Loggen der Session als Debughilfe
    //if (!is_object($search_result_pages) OR !is_a($search_result_pages, "twebshop_search_result_pages"))
    //{ file_put_contents("search_result_pages.txt", date("d-m-Y H:i") . CRLF . $session->getID() . CRLF . $user->getID() . CRLF . $session->getDebugList() . CRLF . file_get_contents($session->getFile()) . CRLF . CRLF, FILE_APPEND); 
    //}

    if ($search->getHits() > $user->WEBSHOP_TREFFERPROSEITE) {
        $search_result_pages->setPage($page);
        $search_result_pages->setHTMLTemplate($template);
        $search_result_pages->addOption("PREV_PAGE", ($search_result_pages->prevPage() !== false) ? _TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE : _TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE_DISABLED);
        $search_result_pages->addOption("NEXT_PAGE", ($search_result_pages->nextPage() !== false) ? _TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE : _TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE_DISABLED);
        $search_result_pages->addOption("ALPHABETICAL_INDEX", ($search_result_pages->existsABCIndex()) ? _TEMPLATE_SEARCH_RESULT_PAGES_OPTION_ALPHABETICAL_INDEX : "");
    }

    $site->addComponent("VAR_SID", $search->getID());
    $site->addComponent("VAR_SORT_ORDER_TYPE", $search->getSortOrderType());
    $site->addComponent("OBJ_SEARCH_RESULT_PAGES", ($search->getHits() > $user->WEBSHOP_TREFFERPROSEITE) ? $search_result_pages->getFromHTMLTemplate() : "");
    $site->addComponent("OBJ_ARTICLE", "");  //wird unten erweitert
    $site->addComponent("OBJ_PLAY", "");

    $performance->addToken("search_obj_articles");
    for ($i = $search_result_pages->getItemStartIndex(); $i <= $search_result_pages->getItemStopIndex(); $i++) {
        $article = new twebshop_article($search_result_pages->getItem($i), 0, $user->getID());
        $article->addOption("CART", _TEMPLATE_ARTICLE_SEARCH_OPTION_CART);
        if (defined("_TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS"))
            $article->addOption("DETAILS", _TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS);
        $article->addOption("PLAY", (count($article->getSounds())  > 0) ? _TEMPLATE_ARTICLE_SEARCH_OPTION_PLAY : "");
        $article->addOption("DEMO", (count($article->getDemos()) > 0) ? _TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO : "");
        $article->addOption("MINISCORE", ($article->getMiniScore($orgamon->getSystemString(torgamon::BASEPLUG_MINISCORE_PATH)) ? _TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE : ""));
        $article->addOption("RECORDS", ($article->existRecords() ? _TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS : ""));
        $article->addOption("THUMB", ($article->getFileName_Thumbnail()==false) ? "" : _TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB );
        $article->addOption("MP3", ($article->existsMP3Download()) ? _TEMPLATE_ARTICLE_SEARCH_OPTION_MP3 : "" );
        $article->addOption("WISHLIST", _TEMPLATE_ARTICLE_SEARCH_OPTION_WISHLIST);
        $site->appendComponent("OBJ_ARTICLE", $article->getFromHTMLTemplate($template));
        $site->appendComponent("OBJ_PLAY", $article->getPlayCode());
        unset($article);
    }
    $performance->getTimeNeededBy("search_obj_articles");
}
?>
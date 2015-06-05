<?php

if ($site->isActive()) {

    $template->setTemplates(array(
        twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_WISHLIST,
        twebshop_article_variants::CLASS_NAME => _TEMPLATE_VERSIONS,
        twebshop_version::CLASS_NAME => _TEMPLATE_VERSION,
        twebshop_price::CLASS_NAME => $user->showDiscount() ? _TEMPLATE_PRICE_CART_DISCOUNT : _TEMPLATE_PRICE_CART,
        twebshop_delivery::CLASS_NAME => _TEMPLATE_PRICE_CART_DELIVERY,
        twebshop_availability::CLASS_NAME => _TEMPLATE_AVAILABILITY
    ));

    foreach ($wishlist->article as $index => $article) {
        $wishlist->article[$index]->getAvailability();
        $wishlist->article[$index]->addOption("DETAILS",      _TEMPLATE_ARTICLE_WISHLIST_OPTION_DETAILS);
        $wishlist->article[$index]->addOption("DELETE",       _TEMPLATE_ARTICLE_WISHLIST_OPTION_DELETE);
        $wishlist->article[$index]->addOption("MOVE_TO_CART", _TEMPLATE_ARTICLE_WISHLIST_OPTION_MOVE_TO_CART);
        $wishlist->article[$index]->addOption("THUMB",        (count($article->getThumbs()) > 0 ) ? _TEMPLATE_ARTICLE_WISHLIST_OPTION_THUMB : "");
    }

    foreach ($article_variants->version as $rid => $version) {
        if ($version->isPublic()) {
            $site->appendComponent("JS_HAS_DETAIL", "hasDetail[$rid] = " . (($version->hasDetail()) ? "true" : "false") . ";" . CRLF);
        }
    }

    $site->addComponent("OBJ_WISHLIST", $wishlist->getFromHTMLTemplate($template));

}

?>
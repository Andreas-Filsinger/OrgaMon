<?php

$site->setName("cart");
$site->setTitle(WORD_CART);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) 
{ $template->setTemplates(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_CART, 
                                twebshop_cart::CLASS_NAME => _TEMPLATE_CART,
								twebshop_article_variants::CLASS_NAME => _TEMPLATE_VERSIONS,
								twebshop_version::CLASS_NAME => _TEMPLATE_VERSION,
							    twebshop_price::CLASS_NAME => $user->showDiscount() ? _TEMPLATE_PRICE_CART_DISCOUNT : _TEMPLATE_PRICE_CART,
								twebshop_delivery::CLASS_NAME => _TEMPLATE_PRICE_CART_DELIVERY,
								twebshop_availability::CLASS_NAME => _TEMPLATE_AVAILABILITY
  ));

  $cart->buildSum();
  $cart->addOption("LOAD","");
  $cart->addOption("ORDER",($cart->getPositions() > 0) ? _TEMPLATE_CART_OPTION_ORDER : "");
  $cart->addOption("REFRESH_DELIVERY",($cart->getPositions() > 0) ? _TEMPLATE_CART_OPTION_REFRESH_DELIVERY : "");

  foreach($cart->article as $index => $article) 
  { $cart->article[$index]->getAvailability();
    $cart->article[$index]->addOption("DETAILS",_TEMPLATE_ARTICLE_CART_OPTION_DETAILS);
    $cart->article[$index]->addOption("DELETE",_TEMPLATE_ARTICLE_CART_OPTION_DELETE);
    $cart->article[$index]->addOption("REFRESH",_TEMPLATE_ARTICLE_CART_OPTION_REFRESH);
    $cart->article[$index]->addOption("AID","~AID~");
    $cart->article[$index]->addOption("DEMO",(count($article->getSounds(false)) > 0) ? _TEMPLATE_ARTICLE_CART_OPTION_DEMO : "");
    $cart->article[$index]->addOption("MINISCORE",($article->getMiniScore($orgamon->getSystemString(torgamon::BASEPLUG_MINISCORE_PATH))) ? _TEMPLATE_ARTICLE_CART_OPTION_MINISCORE : "");
    $cart->article[$index]->addOption("RECORDS",($article->existRecords() ? _TEMPLATE_ARTICLE_CART_OPTION_RECORDS : ""));
    $cart->article[$index]->addOption("COPY",($article_variants->hasDetail($article->version_r) AND $article->detail != "") ? _TEMPLATE_ARTICLE_CART_OPTION_COPY : "");
	$cart->article[$index]->addOption("THUMB",(count($article->getThumbs()) > 0 ) ? _TEMPLATE_ARTICLE_CART_OPTION_THUMB : "");
	$cart->article[$index]->addOption("VERSION",($article_variants->existsVersion($article->getVersion()) AND $article_variants->getByID($article->getVersion())->isPublic()) ? _TEMPLATE_ARTICLE_CART_OPTION_VERSION_PUBLIC : _TEMPLATE_ARTICLE_CART_OPTION_VERSION_NOT_PUBLIC);
    unset($article);
  }
  
  foreach($article_variants->version as $rid => $version)
  { if ($version->isPublic()) 
    { $site->appendComponent("JS_HAS_DETAIL", "hasDetail[$rid] = " . (($version->hasDetail()) ? "true" : "false") . ";" . CRLF);
	}
  }
    
  $site->addComponent("OBJ_CART", $cart->getFromHTMLTemplate($template));
}
?>
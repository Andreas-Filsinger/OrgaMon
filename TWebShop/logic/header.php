<?php

$header = new tsite("header");
$header->loadTemplate(__TEMPLATE_PATH,".html","h_");

$header->addComponent("VAR_SITE_TITLE",$site->getTitle());
$header->addComponent("VAR_META_KEYWORDS", $site->getKeywords());
$header->addComponent("VAR_NEXT_SEARCH_ID",$search->getNextID());
$header->addComponent("VAR_SEARCH_USER_EXPRESSION",$search->getUserExpression());
$header->addComponent("VAR_CART_POSITIONS",$cart->getPositions());
$header->addComponent("VAR_CART_SUM",twebshop_price::toCurrency($cart->getSum()));
$header->addComponent("OBJ_COOKIES", "<script type=\"text/javascript\"> checkCookies('{$site->getName()}'); </script>");
$header->addComponent("OBJ_DATE",date("d.m.Y"));
$header->addComponent("OBJ_LOGIN",(!$user->loggedIn()) ? str_replace("~SITE~",$shop->getCurrentSite(),_TEMPLATE_OPTION_LOGIN) : str_replace("~SITE~",$shop->getCurrentSite(),_TEMPLATE_OPTION_LOGOUT));
$header->addComponent("OBJ_LOGIN_INFO",($user->loggedIn()) ? $user->getFromHTMLTemplate(VARIABLE_SENTENCE_LOGGED_IN_AS_X) : WORD_GUEST);
$header->addComponent("OBJ_NEWSLETTER",(!$user->loggedIn()) ? str_replace("~SITE~","newsletter",_TEMPLATE_OPTION_NEWSLETTER) : str_replace("~SITE~","myshop&subsite=mailings",_TEMPLATE_OPTION_NEWSLETTER));
	  
?>
<?php

// Seitenkopf 
$site->addComponent("VAR_SITE_TITLE",$site->getTitle());
$site->addComponent("VAR_META_KEYWORDS", $site->getKeywords());
$site->addComponent("VAR_NEXT_SEARCH_ID",$search->getNextID());
$site->addComponent("VAR_SEARCH_USER_EXPRESSION",$search->getUserExpression());
$site->addComponent("VAR_CART_POSITIONS",$cart->getPositions());
$site->addComponent("VAR_CART_SUM",twebshop_price::toCurrency($cart->getSum()));
$site->addComponent("OBJ_COOKIES", "<script type=\"text/javascript\"> checkCookies('{$site->getName()}'); </script>");
$site->addComponent("OBJ_DATE",date("d.m.Y"));
$site->addComponent("OBJ_LOGIN",(!$user->loggedIn()) ? str_replace("~SITE~",$shop->getCurrentSite(),_TEMPLATE_OPTION_LOGIN) : str_replace("~SITE~",$shop->getCurrentSite(),_TEMPLATE_OPTION_LOGOUT));
$site->addComponent("OBJ_LOGIN_INFO",($user->loggedIn()) ? $user->getFromHTMLTemplate(VARIABLE_SENTENCE_LOGGED_IN_AS_X) : WORD_GUEST);
$site->addComponent("OBJ_NEWSLETTER",(!$user->loggedIn()) ? str_replace("~SITE~","newsletter",_TEMPLATE_OPTION_NEWSLETTER) : str_replace("~SITE~","myshop&subsite=mailings",_TEMPLATE_OPTION_NEWSLETTER));
        
// Seitenfuss 
$site->addComponent("VAR_REVISION",get_revision());
$site->addComponent("VAR_TEMPLATE_REVISION",(defined("__TEMPLATE_PROJECTNAME")) ? get_revision("", __TEMPLATE_PATH) : "");

$performance->addToken("SQL",0.0,$ibase->get_time());
$performance->addToken("XMLRPC",0.0,$xmlrpc->getTime());

// Performance Werte übertragen

$performance_overall = $performance->getTimeNeeded();
$performance_xmlrpc = $performance->getTimeNeededBy("XMLRPC");
$performance_sql = $performance->getTimeNeededBy("SQL");
$performance_php = $performance_overall - $performance_xmlrpc - $performance_sql;

$site->addComponent("VAR_PERF_MS",  sprintf("%0.1f",round($performance_overall, 1)));
$site->addComponent("VAR_PERF_XMLRPC", sprintf("%0.1f",round($performance_xmlrpc,1)));
$site->addComponent("VAR_PERF_SQL", sprintf("%0.1f",round($performance_sql,1)));
$site->addComponent("VAR_PERF_PHP", sprintf("%0.1f",round($performance_php,1)));
$site->addComponent("OBJ_PERFORMANCE",$performance->getAllTokens());


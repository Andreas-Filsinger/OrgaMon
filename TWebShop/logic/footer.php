<?php

$footer = new tsite("footer");
$footer->loadTemplate(__TEMPLATE_PATH,".html","f_");
$footer->addComponent("VAR_REVISION",get_revision());
$footer->addComponent("VAR_TEMPLATE_REVISION",(defined("__TEMPLATE_PROJECTNAME")) ? get_revision("", __TEMPLATE_PATH) : "");

$performance->addToken("SQL",0.0,$ibase->get_time());
$performance->addToken("XMLRPC",0.0,$xmlrpc->getTime());

// Performance Werte übertragen
$footer->addComponent("VAR_PERF_MS",  sprintf("%0.1f",round($performance->getTimeNeeded(), 1)));
$footer->addComponent("VAR_PERF_XMLRPC", sprintf("%0.1f",round($performance->getTimeNeededBy("XMLRPC"),1)));
$footer->addComponent("VAR_PERF_SQL", sprintf("%0.1f",round($performance->getTimeNeededBy("SQL"),1)));
$footer->addComponent("OBJ_PERFORMANCE",$performance->getAllTokens());

?>
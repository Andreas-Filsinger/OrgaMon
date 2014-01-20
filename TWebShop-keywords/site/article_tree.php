<?php

$site->setName("article_tree");
$site->setTitle(SENTENCE_EXTENDED_SEARCH);
$site->addToSiteMap();
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    $site->addComponent("VAR_NEXT_SEARCH_ID", $search->getNextID());
    $site->addComponent("VAR_SEARCH_USER_EXPRESSION", $search->getUserExpression());
    $site->addComponent("OBJ_TREE", $tree()->getHTML());
}
//echo $tree->getLinkedPath($tree->getCode(166));
?>

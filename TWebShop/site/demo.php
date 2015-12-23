<?php

$site->setName("demo");
$site->setTitle(WORD_DEMO);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive())
{ $shop->loadVarsIfDontExist("s_demo");
  $shop->saveVars("s_demo",array("id"));

  $article = new twebshop_article($id);
  $sounds  = $article->getDemos();
  
  foreach($sounds as $link)
  { $link->addOption("BROKEN_LINK",_TEMPLATE_ARTICLE_LINK_DEMO_OPTION_BROKEN_LINK);
    $site->appendComponent("OBJ_LINK", $link->getFromHTMLTemplate(_TEMPLATE_ARTICLE_LINK_DEMO));
  }
  
  $site->appendTitle($article->TITEL);
}

?>

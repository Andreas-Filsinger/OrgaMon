<?php
// FLAGS
// $flag_search_input = false;        // ob die Such-Eingabezeile angezeigt wird.
// $flag_categories = false;          // ob Sortimente relevant sind
// $flag_output_selectable = false;   // ob Ausgabeart wählbar ist
// $flag_show_attention = false;      // ob TrefferHinweise angezeigt werden
// $flag_quantity = false;            // ob die Spalte "Menge" angezeigt wird
// $flag_options = false;             // ob Optionen angeboten/angezeigt werden
// $flag_user_exists = false;         // ob der User relevant ist

image_show(__PNG_PATH."icon_search.png",WORD_SEARCHRESULTS,"margin-bottom:0px; margin-right:20px; vertical-align:middle;");
echo "<span style=\"font-size:20px; vertical-align:middle\"><b>" . WORD_SEARCHRESULTS . "</b> (" . $search->hits . " " . WORD_HITS . ")</span><br />";

$result = $search->getResult();
for ($i = 0; $i < $search->hits; $i++)
{ $article = new twebshop_article($result[$i]);
  $article->getComposer();
  $article->getArranger();
  $article->price->setHTMLTemplate($_TEMPLATE_PRICE_SEARCH);
  $article->addOption("DETAILS",$_TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS);
  $article->addOption("CART",$_TEMPLATE_ARTICLE_SEARCH_OPTION_CART);
  $article->addOption("LISTEN",(count($article->getSounds(MP3_PATH)) > 0) ? $_TEMPLATE_ARTICLE_SEARCH_OPTION_LISTEN : "");
  echo $article->getFromHTMLTemplate($_TEMPLATE_ARTICLE_SEARCH);
  unset($article);
}
?>
<?php

$template->setTemplates(array(twebshop_article::CLASS_NAME => $_TEMPLATE_ARTICLE_CART, 
                              twebshop_cart::CLASS_NAME => $_TEMPLATE_CART, 
							  twebshop_price::CLASS_NAME => $_TEMPLATE_PRICE_CART));

foreach($cart->article as $index => $article) 
{ //var_dump($cart->article[$index]);
  $cart->article[$index]->addOption("DETAILS",$_TEMPLATE_ARTICLE_CART_OPTION_DETAILS);
}
echo $cart->getFromHTMLTemplate($template);
echo "<span class=\"smallblack\">" . SENTENCE_HOWTO_DELETE_ITEMS . "</span>";


?>
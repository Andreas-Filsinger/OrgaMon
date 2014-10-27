<?php

// $messagelist->add("Version_R: $version_r Quantity: $quantity");
$cart->updateArticle($uid, $f_quantity, $f_version_r, $_GLOBALS["f_detail"]->getValue(""));
$messagelist->add(SENTENCE_YOUR_CART_HAS_BEEN_UPDATED);

?>
<?php

twebshop_user::free();
$user = twebshop_user::create();
$messagelist->add(SENTENCE_LOGGED_OUT);

$cart->setPerson(0);
$cart->clear();
$messagelist->add(SENTENCE_YOUR_CART_HAS_BEEN_SAVED);

tsession::free();

$site->setName("login");

?>

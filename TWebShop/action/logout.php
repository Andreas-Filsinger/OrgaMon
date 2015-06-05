<?php

twebshop_user::free();
$user = twebshop_user::create();
$messagelist->add(SENTENCE_LOGGED_OUT);

$cart->setPerson(0);
$cart->clear();
$messagelist->add(SENTENCE_YOUR_CART_HAS_BEEN_SAVED);

/* 04.05.2015 michaelhacksoftware : Wishlist in Session erstellen */
twebshop_wishlist::destroy();
$session->unregisterVar("wishlist");
/* --- */

tsession::free();

$site->setName("login");

?>
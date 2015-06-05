<?php

    if ($wishlist->moveToCart($uid)) {
        $messagelist->add(SENTENCE_ARTICLE_HAS_BEEN_MOVED_TO_CART);
    }
    
?>
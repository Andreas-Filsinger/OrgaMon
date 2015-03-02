<?php

    if ($cart->addArticle($id, 1, $_GLOBALS["vid"]->getValue(0))) {
        $messagelist->add(SENTENCE_ARTICLE_HAS_BEEN_ADDED_TO_CART);
    }

?>
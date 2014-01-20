<?php

$orgamon->orderMiniscore($user->getID(), twebshop_article::decryptRID($id));
$messagelist->add($user->getFromHTMLTemplate(VARIABLE_SENTENCE_MINISCORE_WILL_BE_SENT_TO_X));
if ($site->getName() == "login")
    $site->setName("article");
?>
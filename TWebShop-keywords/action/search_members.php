<?php

if (!isset($sid)) {
    $sid = $search->getNextID();
}

$page = 1;

$search->doSearch($sid, "searchMembers", array("article_r" => $id));
$messagelist->add($search->getHits() . " " . WORD_HITS);
?>
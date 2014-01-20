<?php

if (!isset($sid))
{ $sid = $search->getNextID();
}

if (!isset($f_search_expression)) 
{ $f_search_expression = "";
}

$search->doSearch($sid, "searchUserExpression", array("expression" => $f_search_expression, "assortment" => 0));
$messagelist->add($search->getHits() . " " . WORD_HITS);


?>

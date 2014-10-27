<?php
if (!isset($sid)) {
    $sid = $search->getNextID();
}

if (count($tree()->selected_nodes) > 0) {
    $search->doSearch($sid, "searchUserExpressionExtended", array("expression" => $f_search_expression, "assortment" => 0, "tree_node_ids" => $tree()->selected_nodes));
    $messagelist->add($search->getHits() . " " . WORD_HITS);
} else {
    include_once("search_user_expression.php");
}
?>
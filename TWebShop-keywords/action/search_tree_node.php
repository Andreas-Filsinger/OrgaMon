<?php

if (!isset($sid))
{ $sid = $search->getNextID();
}

$search->doSearch($sid, "searchTreeNode", array("tree_node_id" => $id));
$messagelist->add($search->getHits() . " " . WORD_HITS);

?>

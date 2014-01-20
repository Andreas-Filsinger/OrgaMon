<?php

if (!isset($sid))
{ $sid = $search->getNextID();
}

$search->doSearch($sid, "searchRecords", array("record_id" => $id));
$messagelist->add($search->getHits() . " " . WORD_HITS);

?>

<?php

if (!isset($sid))
{ $sid = $search->getID();
}

if (!isset($type)) 
{ $type = twebshop_search_result_sort_order::DEFAULT_TYPE;
}

$search->sortResult($sid,$type);
$page = 1;

?>
<?php

$session->registerTmpVar("tob_accepted",true,$shop->getCurrentSite());
$session->registerTmpVar("step",$session->getTmpVar("step",$shop->getCurrentSite()) + 1,$shop->getCurrentSite());

?>

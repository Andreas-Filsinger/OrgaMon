<?php

$session->registerTmpVar("country_r",$f_country_r,$shop->getCurrentSite());
$session->registerTmpVar("step",$session->getTmpVar("step",$shop->getCurrentSite()) + 1,$shop->getCurrentSite());

?>
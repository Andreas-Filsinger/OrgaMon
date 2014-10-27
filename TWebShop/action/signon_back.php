<?php

$session->registerTmpVar("step",$session->getTmpVar("step",$shop->getCurrentSite()) - 1,$shop->getCurrentSite());

?>
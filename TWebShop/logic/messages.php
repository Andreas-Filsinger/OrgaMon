<?php

$site->addComponent("OBJ_ERRORLIST",($errorlist->error) ? $errorlist->getFromHTMLTemplate($errorlist->getAsCustomHTML("")) : ""); 
$site->addComponent("OBJ_MESSAGELIST",($messagelist->message) ? $messagelist->getFromHTMLTemplate($messagelist->getAsCustomHTML("")) : ""); 

?>
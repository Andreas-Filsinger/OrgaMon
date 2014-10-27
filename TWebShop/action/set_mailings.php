<?php

//var_dump($f_mailings);

$mailings = twebshop_mailings::create($user->getID());
$mailings->updateInDataBase(isset($f_mailings) ? $f_mailings : array());
unset($mailings);

$messagelist->add(SENTENCE_YOUR_SETTINGS_HAVE_BEEN_SAVED); 

$subsite = "mailings";

?>
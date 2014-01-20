<?php

$tmp_address = $user->getAddress();

$user->address->setStreet($f_street);
$user->address->setZIP($f_zip_code);
$user->address->setCity($f_city);
$user->address->setState($_GLOBALS["f_state"]->getValue(""));
$user->address->setName1($_GLOBALS["f_name"]->getValue(""));

if ($user->address->updateInDataBase()) 
{ $messagelist->add(SENTENCE_YOUR_ADDRESS_HAS_BEEN_SAVED);
}
else
{ $user->address = $tmp_address;
  $errorlist->add(ERROR_YOUR_ADDRESS_COULD_NOT_BE_SAVED);
}

unset($tmp_address);

$subsite = "customer_data";

?>

<?php

if (twebshop_user::existsUserID($f_user) !== false) 
{ $errorlist->add(ERROR_USERID_ALREADY_EXISTS);
}
else
{ $tmp_emails = $user->geteMails();
  $tmp_user_id = $user->getUserID();

  $user->addeMail($f_user);
  $user->setUserID($f_user);
  if ($user->updateInDataBase())
  { $messagelist->add(SENTENCE_YOUR_EMAIL_ADDRESS_HAS_BEEN_UPDATED);
  }
  else
  { $user->seteMails($tmp_emails);
    $user->setUserID($tmp_user_id);
    $errorlist->add(ERROR_YOUR_EMAIL_ADDRESS_COULD_NOT_BE_UPDATED);
  }

  unset($tmp_emails);
  unset($tmp_user_id);
}

$subsite = "customer_data";

?>

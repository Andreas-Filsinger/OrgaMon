<?php

if ($f_pass == $f_pass_confirm) 
{ if ($user->setPassword($f_pass) !== false)
  { $messagelist->add(SENTENCE_YOUR_PASSWORD_HAS_BEEN_CHANGED);
  }
}
else
{ $errorlist->add(ERROR_GIVEN_PASSWORDS_DONT_MATCH);
}

$subsite = "customer_data";

?>
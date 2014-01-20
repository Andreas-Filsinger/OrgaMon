<?php

if (!$errorlist->error)
{ if ($orgamon->sendMail(EMAIL_ADMIN,SYS_SENTENCE_TWEBSHOP_HELP_REQUEST,$f_help_request . $user->getFromHTMLTemplate(_TEMPLATE_PERSON_HELP_EMAIL)))
  { $messagelist->add(SENTENCE_YOUR_REQUEST_HAS_BEEN_SENT);
    unset($f_help_request);
  }
  else
  { $errorlist->add(ERROR_YOUR_REQUEST_COULD_NOT_BE_SENT);
  }
}

$site->setName("help");

?>

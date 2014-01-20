<?php

include_once("./core/email.php");

if ($user->isService(MOD_NEWSLETTER_USER_SERVICE_NAME)) {
    
    include_once("./logic/newsletter_build_html.php");

    if (!$errorlist->error) {
        $result = false;
        if (($version = torgamon::createEvent(torgamon_event::eT_Newsletter, SYS_SENTENCE_NEWSLETTER_HAS_BEEN_CREATED, $user->getID())) != false) {
            $file = MOD_NEWSLETTER_PATH . MOD_NEWSLETTER_FILENAME_PREFIX . $version . MOD_NEWSLETTER_FILENAME_POSTFIX . MOD_NEWSLETTER_FILENAME_EXTENSION;

            $newsletter = new temail();
            $newsletter->setCRLF(CRLF); //LF für mail(), CRLF für smtp
            $newsletter->setSubject($f_subject);
            $newsletter->setHTML($html);
            $newsletter->setPlain($html_title . $newsletter->getCRLF() . html_entity_decode(strip_tags($html_content)));

            $result = $newsletter->writeToEMLFile($file);

            if ($result) {
                $messagelist->add(str_replace("~FILE~", $file, VARIABLE_SENTENCE_NEWSLETTER_HAS_BEEN_WRITTEN_TO_FILE_X));
            }
            unset($file);
            unset($newsletter);
        }
        unset($version);
        if (!$result) {
            $errorlist->add(ERROR_NEWSLETTER_COULD_NOT_BE_CREATED);
        }
        unset($result);
    }
    unset($html);
} else {
    $errorlist->add(ERROR_NO_AUTHORIZATION_TO_RUN_THIS_ACTION);
}
?>
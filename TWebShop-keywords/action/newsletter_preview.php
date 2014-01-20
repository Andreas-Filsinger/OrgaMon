<?php
if ($user->isService(MOD_NEWSLETTER_USER_SERVICE_NAME)) {
    
    $site->setHeader(false);
    $site->setFooter(false);

    include_once("./logic/newsletter_build_html.php");

    echo $html;

    unset($html);
    
    // AF: Sinn verstehe ich nicht "blank" gibt es nicht!
    $site->setName("blank");
    
} else {
    $errorlist->add(ERROR_NO_AUTHORIZATION_TO_RUN_THIS_ACTION);
}
?>

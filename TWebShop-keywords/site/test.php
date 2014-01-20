<?php

$site->setName("test");
$site->setTitle(SYS_SENTENCE_AVAILABILITY_CHECK);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    
    $messagelist->add(__PROJECTNAME . " Rev " . get_revision());
    $site->addComponent("OBJ_BASEPLUG", "~BEGIN BASEPLUG~<br />" . CRLF .
            implode("<br />" . CRLF, $orgamon->getSystemStrings()) . "<br />" . CRLF .
            "~END BASEPLUG~<br />" . CRLF
    );
    $site->addComponent("OBJ_FIREBIRD","~BEGIN FIREBIRD~<br />" . CRLF .
            implode("<br />" . CRLF, $orgamon->getFirebirdStrings()) . "<br />" . CRLF .
            "~END FIREBIRD~<br />" . CRLF
            
            );
}
?>

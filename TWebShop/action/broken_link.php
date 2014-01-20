<?php

$agent = $_SERVER['HTTP_USER_AGENT'];
while (true) {

    // filtere "klicks" durch Bots
    if (strpos($agent, "Googlebot") != false)
        break;

    if (strpos($agent, "DotBot") != false)
        break;

    $article = new twebshop_article($id);

    $message = SYS_VARIABLE_TEXT_BROKEN_LINK_REPORT_EMAIL;
    $message = str_replace("~URL~", $url, $message);
    $message = str_replace("~ARTICLE~", $article->getFromHTMLTemplate(_TEMPLATE_ARTICLE_BROKEN_LINK_EMAIL), $message);
    $message = str_replace("~PERSON~", (($user->loggedIn()) ? ($user->getFromHTMLTemplate(_TEMPLATE_PERSON_BROKEN_LINK_EMAIL)) : "unauthentifiziert"), $message);
    $message = str_replace("~REFERER~",
            /**/ $agent . "@" .
            /**/ $_SERVER['REMOTE_ADDR']
            , $message);

    $orgamon->sendMail(
            /**/ EMAIL_ADMIN,
            /**/ SYS_SENTENCE_BROKEN_LINK_REPORT,
            /**/ $message, ($user->loggedIn() ? $user->getID() : "NULL"));
    $messagelist->add(SENTENCE_THANK_YOU_FOR_YOUR_SUPPORT);

    unset($message);
    unset($article);
    break;
}
?>
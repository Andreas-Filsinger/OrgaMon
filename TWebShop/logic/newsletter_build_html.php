<?php

function replace_code($text, $tag, $template, $function) { //echo "*$tag*";
    $pattern = "/(\[$tag\]{1}[a-zA-Z0-9 -,;\/:~._=?äÄöÖüÜß@<>!|&\"]*\[\/$tag\]{1})/";
    $split = preg_split($pattern, $text, -1, PREG_SPLIT_DELIM_CAPTURE);
    //var_dump($split);
    $tags = array_diff($split, preg_split($pattern, $text));
    foreach ($tags as $index => $tag) { //echo "*$tag*";
        $a = strpos($tag, "]", 0) + 1;
        $o = strpos($tag, "[", $a);
        $replace = $template;
        $values = explode(";", substr($tag, $a, $o - $a));
        if ($function != false) {
            $replace = call_user_func_array($function, $values);
        } else {
            foreach ($values as $i => $value) {
                $replace = str_replace("~VALUE$i~", $value, $replace);
            }
        }
        $split[$index] = $replace;
    }
    return implode("", $split);
}

function get_articles($params) {
    global $orgamon;
    $template = new ttemplate(array(twebshop_article::CLASS_NAME => _TEMPLATE_ARTICLE_NEWSLETTER,
                twebshop_price::CLASS_NAME => _TEMPLATE_PRICE_SEARCH,
                twebshop_availability::CLASS_NAME => _TEMPLATE_AVAILABILITY
            ));

    $ids = explode(",", $params);

    $articles = "";
    foreach ($ids as $id) {
        $article = new twebshop_article($id);
        $article->getAll();
        $article->addOption("CART", _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_CART);
        if (defined("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DETAILS"))
            $article->addOption("DETAILS", _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DETAILS);
        $article->addOption("DEMO", (count($article->getSounds()) > 0) ? _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DEMO : "");
        $article->addOption("MINISCORE", ($article->getMiniScore($orgamon->getSystemString(torgamon::BASEPLUG_MINISCORE_PATH)) ? _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MINISCORE : ""));
        $article->addOption("RECORDS", ($article->existRecords() ? _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_RECORDS : ""));
        $article->addOption("THUMB", (count($article->getThumbs()) > 0 ) ? _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_THUMB : "");
        $article->addOption("MP3", ($article->existsMP3Download()) ? _TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MP3 : "" );

        $articles.= $article->getFromHTMLTemplate($template);

        unset($article);
    }
    return $articles;
}

$f_subject = strip_tags($f_subject);
$f_text = str_replace("\\\"", "\"", $f_text);
$f_text = str_replace("\\'", "'", $f_text);
$f_text = str_replace("\r", "", $f_text);

$html_title = $f_subject;
$html_content = $f_text;
//CODE ERSETZEN
foreach ($_TAGS as $index => $property) {
    $html_content = replace_code($html_content, $index, $property["TEMPLATE"], $property["FUNCTION"]);
}
$html_content = str_replace(":semi:", ";", $html_content);
//***


$html = file_get_contents(__TEMPLATE_PATH . MOD_NEWSLETTER_TEMPLATE);
$html = str_replace("~NEWSLETTER_TITLE~", $html_title, $html);
$html = str_replace("~NEWSLETTER_CONTENT~", $html_content, $html);
?>
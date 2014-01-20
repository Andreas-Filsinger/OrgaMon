<?php

define("_TEMPLATE_ARTICLE_LINK_DEMO",
image_tag(__TEMPLATE_IMAGES_PATH."icon_internet_blue.png","","float:left; margin-right:10px; margin-bottom:10px;") . CRLF . 
str_replace("~TITEL~","<b>~TITEL~</b>",VARIABLE_SENTENCE_LISTEN_TO_X_ON) . CRLF .
"<br /><a href=\"~URL_RAW~\" target=\"_blank\"><b>~HOST~</b></a><br />" . CRLF .
"<span class=\"smallblack\">" . VARIABLE_SENTENCE_PLEASE_CLICK_X_IF_BROKEN_LINK . "</span><br /><br />" . CRLF
);

define("_TEMPLATE_ARTICLE_LINK_DEMO_OPTION_BROKEN_LINK",
"<a class=\"a01s\" href=\"" . __INDEX . "?action=broken_link&id=~ARTICLE_R~&url=~URL~\">" . WORD_HERE . "</a>"
);

define("_TEMPLATE_ARTICLE_LINK_ARTICLE_MEMBER",
"<a href=\"" . __INDEX . "?site=article&id=~ARTICLE_R~\">~TITEL~</a><br />" . CRLF
);

?>
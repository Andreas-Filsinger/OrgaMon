<?php

define("_TEMPLATE_SEARCH_RESULT_PAGES",
"<p style=\"margin-bottom:5px;\"><b>" . VARIABLE_SENTENCE_SHOWING_ARTICLE_FROM_X_TILL_Y . "</b></p>" . CRLF .
"<p style=\"display:inline;\"><b>" . WORD_PAGE . "</b>:&nbsp;~INDEX~&nbsp;&nbsp;</p>~OPTION_PREV_PAGE~~OPTION_NEXT_PAGE~" . CRLF .
"~OPTION_ALPHABETICAL_INDEX~" . 
"<p class=\"righttitle\">~COUNT~&nbsp;" . WORD_HITS . "</p>" . CRLF
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PREV_PAGE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_prev_page.png",SENTENCE_PREV_PAGE,"border:0px; vertical-align:middle; margin:0px;") . 
"</a>&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE_DISABLED",
image_tag(__TEMPLATE_IMAGES_PATH."option_prev_page_disabled.png",SENTENCE_NO_PREV_PAGE,"border:0px; vertical-align:middle; margin:0px;")
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~NEXT_PAGE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_next_page.png",SENTENCE_NEXT_PAGE,"border:0px; vertical-align:middle; margin:0px;") . 
"</a>&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE_DISABLED", 
image_tag(__TEMPLATE_IMAGES_PATH."option_next_page_disabled.png",SENTENCE_NO_NEXT_PAGE,"border:0px; vertical-align:middle; margin:0px;")
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PAGE~\">~PAGE~</a>&nbsp;-&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION_DISABLED",
"<b>~PAGE~</b>&nbsp;-&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_ALPHABETICAL_INDEX",
"<p style=\"margin-top:5px; margin-bottom:5px;\"><b>" . SENTENCE_ALPHABETICAL_INDEX . "</b>:&nbsp;~ABC~</p>" . CRLF
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_ABC_INDEX_OPTION",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PAGE~#~ANCHOR~\">~TEXT~</a>&nbsp;-&nbsp;"
);


?>
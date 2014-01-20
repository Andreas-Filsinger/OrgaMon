<?php

define("_TEMPLATE_SEARCH_RESULT_PAGES",
"<table style=\"background:#CCFFB3; margin-bottom:10px;\" cellspacing=\"0\" cellpadding=\"0\">" . CRLF . 
"<tr>" . CRLF .
"<td style=\"vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_search_result_pages_left_top_corner.png","","vertical-align:top;") . "</td>" . CRLF .
"<td rowspan=\"2\" style=\"padding:5px; color:#00AA00; text-align:center;\">" . CRLF .
" <span st2yle=\"font-size:18px;\"><b>" . VARIABLE_SENTENCE_SHOWING_ARTICLE_FROM_X_TILL_Y_OF_Z . "</b></span><br /> 
  <span s2tyle=\"font-size:18px;\"><b>" . WORD_PAGE . "</b>:</span>&nbsp;~OPTION_PREV_PAGE~&nbsp;&nbsp;~INDEX~&nbsp;&nbsp;~OPTION_NEXT_PAGE~<br />
  <b>" . SENTENCE_ALPHABETICAL_INDEX . "</b>:&nbsp;~ABC~" . CRLF .
"</td>" . CRLF .
"<td style=\"vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_search_result_pages_right_top_corner.png","","vertical-align:top;") . "</td>" . CRLF .
"</tr>" . CRLF .
"<tr>" . CRLF .
"<td style=\"vertical-align:bottom;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_search_result_pages_left_bottom_corner.png","","vertical-align:bottom;") . "</td>" . CRLF .
"<td style=\"vertical-align:bottom;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_search_result_pages_right_bottom_corner.png","","vertical-align:bottom;") . "</td>" . CRLF .
"</tr>" . CRLF .
"</table>" . CRLF
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PREV_PAGE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_prev_page.png",SENTENCE_PREV_PAGE,"border:0px; vertical-align:middle;") . 
"</a>&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_PREV_PAGE_DISABLED",
image_tag(__TEMPLATE_IMAGES_PATH."option_prev_page_disabled.png",SENTENCE_NO_PREV_PAGE,"border:0px; vertical-align:middle;")
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE",
"<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~NEXT_PAGE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_next_page.png",SENTENCE_NEXT_PAGE,"border:0px; vertical-align:middle;") . 
"</a>&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_NEXT_PAGE_DISABLED", 
image_tag(__TEMPLATE_IMAGES_PATH."option_next_page_disabled.png",SENTENCE_NO_NEXT_PAGE,"border:0px; vertical-align:middle;")
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION",
"[<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PAGE~\">~PAGE~</a>]&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_INDEX_OPTION_DISABLED",
"<span style=\"font-size:18px;\">[<b>~PAGE~</b>]</span>&nbsp;"
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_OPTION_ALPHABETICAL_INDEX",
""
);

define("_TEMPLATE_SEARCH_RESULT_PAGES_ABC_INDEX_OPTION",
"[<a href=\"" . __INDEX . "?site=search&sid=~SID~&page=~PAGE~\">~TEXT~</a>]&nbsp;"
);


?>
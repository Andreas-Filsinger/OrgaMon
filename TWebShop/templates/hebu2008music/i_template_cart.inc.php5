<?php

define("_TEMPLATE_CART",
"<p class=\"title\">" . SENTENCE_YOUR_CART . "</p>" . CRLF . 
"~OBJ_MESSAGELIST~" . CRLF .
"<p class=\"righttitle\">" . VARIABLE_SENTENCE_YOUR_CART_CONTAINS_X_ITEMS . "</p>" . CRLF .
"~ARTICLES~" . CRLF . 
"<p id=\"right\">~OPTION_REFRESH_DELIVERY~&nbsp;" . WORD_SHIPPING . ":&nbsp;<b>~DELIVERY~</b></p>" . CRLF . 
"<p id=\"right\">" . WORD_SUM . ":&nbsp;<b>~SUM~</b></p><hr>" . CRLF .
"<!-- ~OPTION_LOAD~ -->" . CRLF .
"<p id=\"right\">~OPTION_ORDER~</p>" . CRLF 
);


define("_TEMPLATE_CART_OPTION_ORDER",
"<a href=\"" . __INDEX . "?site=order\">" . SENTENCE_GO_TO_CHECKOUT . "&nbsp;&gt;&gt;&gt;</a>"
);

define("_TEMPLATE_CART_OPTION_REFRESH_DELIVERY",
"<a href=\"" . __INDEX . "?site=cart&action=refresh_delivery\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_refresh.png",WORD_REFRESH,"vertical-align:middle;") . 
"</a>"
);

define("_TEMPLATE_CART_OPTION_LOAD",
"<a href=\"" . __INDEX . "?site=cart&action=load_cart&aid=~AID~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_load_cart.png",SENTENCE_LOAD_LAST_CART,"vertical-align:middle; margin-right:10px;") . 
"</a>"
);

define("_TEMPLATE_CART_ORDER",
"<table style=\"width:75%; border:2px #545454 solid; padding:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr><td><b>" . WORD_ORDER_NO . "</b></td><td><b>" . WORD_TITLE . "</b></td><td><b>" . WORD_VERSION . "</b></td><td><b>" . WORD_QUANTITY . "</b></td><td><b>" . WORD_PRICE . "</b></td></tr>" . CRLF . 
"~ARTICLES~" . CRLF .
"<tr><td></td><td>" . WORD_SHIPPING . "</td><td></td><td></td><td>~DELIVERY~</td></tr>" . CRLF . 
"<tr><td></td><td><b>" . WORD_SUM . "</b></td><td></td><td></td><td><b>~SUM~</b></td></tr>" . CRLF . 
"</table>" . CRLF
);

?>
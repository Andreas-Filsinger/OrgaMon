<?php

define("_TEMPLATE_ORDER_STATE_MYSHOP",
"<table cellspacing=\"0\">" . CRLF . 
"<tr>" . CRLF .
"<th style=\"text-align:left; padding-left:10px; padding-right:10px;\">" . WORD_BILL . "</th>" . CRLF . 
"<th style=\"text-align:left; padding-left:10px; padding-right:10px;\">" . WORD_TITLE . "</th>" . CRLF . 
"<th style=\"padding-left:10px; padding-right:10px;\">" . WORD_ORDER_NO . "</th>" . CRLF . 
"<th style=\"padding-left:10px; padding-right:10px;\">" . SENTENCE_QUANTITY_BILL . "</th>" . CRLF .
"<th style=\"padding-left:10px; padding-right:10px;\">" . SENTENCE_QUANTITY_ORDER . "</th>" . CRLF . 
"</tr>" . CRLF .
"~ITEMS~" . CRLF .
"</table>" . CRLF
);

define("_TEMPLATE_ORDER_STATE_MYSHOP_ORDER_ITEM",
"<tr>" . CRLF .
"<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~BILL_NUMBER~</td>" . CRLF . 
"<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~TITEL~</td>" . CRLF . 
"<td style=\"text-align:right; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~NUMERO~</td>" . CRLF . 
"<td style=\"text-align:center; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~MENGE_RECHNUNG~</td>" . CRLF . 
"<td style=\"text-align:center; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~MENGE_AGENT~</td>" . CRLF . 
"</tr>" . CRLF
);


?>

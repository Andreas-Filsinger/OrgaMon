<?php

define("_TEMPLATE_ORDER_STATE_MYSHOP",
"<table style=\"padding:0px; border:0px; margin:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr>" . CRLF .
"<td style=\"background:#ADCBE7; padding-left:10px; padding-right:10px;\">" . WORD_BILL . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:10px; padding-right:10px;\">" . WORD_TITLE . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:10px; padding-right:10px;\">" . WORD_ORDER_NO . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:10px; padding-right:10px;\">" . SENTENCE_QUANTITY_BILL . "</td>" . CRLF .
"<td style=\"background:#ADCBE7; padding-left:10px; padding-right:10px;\">" . SENTENCE_QUANTITY_ORDER . "</td>" . CRLF . 
"</tr>" . CRLF .
"~ITEMS~" . CRLF .
"</table>" . CRLF
);

define("_TEMPLATE_ORDER_STATE_MYSHOP_ORDER_ITEM",
"<tr>" . CRLF .
"<td style=\"text-align:left;   padding-left:10px; padding-right:10px; border-bottom:1px dashed #ADCBE7;\">~BILL_NUMBER~</td>" . CRLF . 
"<td style=\"text-align:left;   padding-left:10px; padding-right:10px; border-bottom:1px dashed #ADCBE7;\">~TITEL~</td>" . CRLF . 
"<td style=\"text-align:right;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #ADCBE7;\">~NUMERO~</td>" . CRLF . 
"<td style=\"text-align:right; padding-left:10px; padding-right:10px; border-bottom:1px dashed #ADCBE7;\">~MENGE_RECHNUNG~</td>" . CRLF . 
"<td style=\"text-align:right; padding-left:10px; padding-right:10px; border-bottom:1px dashed #ADCBE7;\">~MENGE_AGENT~</td>" . CRLF . 
"</tr>" . CRLF
);

?>

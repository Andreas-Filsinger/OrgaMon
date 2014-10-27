<?php

define("_TEMPLATE_MYMUSIC_MYSHOP",
"<table cellspacing=\"0\">" . CRLF . 
"<tr>" . CRLF . 
"<th style=\"text-align:left; padding-left:10px; padding-right:10px;\">" . WORD_DATE . "</th>" . CRLF . 
"<!-- <th style=\"text-align:left; padding-left:10px; padding-right:10px;\">" . WORD_ORDER_NO . "</th> -->" . CRLF . 
"<th style=\"text-align:left; padding-left:10px; padding-right:10px;\">" . WORD_TITLE . "</th>" . CRLF . 
"<th style=\"text-align:center; padding-left:20px; padding-right:20px;\">" . WORD_SIZE . "</th>" . CRLF . 
"<!-- <th style=\"padding-left:10px; padding-right:10px;\">" . WORD_BILL . "</th> -->" . CRLF . 
"<th style=\"padding-left:10px; padding-right:10px;\">" . SENTENCE_REMAINING_DOWNLOADS . "</th>" . CRLF . 
"<th style=\"padding-left:10px; padding-right:10px;\">" . WORD_OPTIONS . "</th>" . CRLF . 
"</tr>" . CRLF . 
"~ITEMS~" . CRLF . 
"</table>" . CRLF
);

define("_TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM",
//"<!-- ~RID~ -->" . CRLF . 
"<tr>" . CRLF . 
"<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~DATE~</td>" . CRLF . 
"~ARTICLE~" . 
"<!-- <td style=\"text-align:right; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~BELEG_NO~</td> -->" . CRLF . 
"<td style=\"text-align:center; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\"><b>~REMAINING_DOWNLOADS~ / ~MENGE_AGENT~</b></td>" . CRLF . 
"<td style=\"text-align:center; padding:5px; padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">" . CRLF . 
"~OPTION_DOWNLOAD~" . CRLF . 
"</td>" . CRLF . 
"</tr>" . CRLF
);

define("_TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM_OPTION_DOWNLOAD_LINK",
//"<a href=\"javascript:openDownload('~ARTIKEL_R~')\">" . image_tag(__TEMPLATE_IMAGES_PATH . "option_mp3.png", WORD_DOWNLOAD) . "</a>"
"<a href=\"" . __INDEX . "?site=~SITE~&action=download_mymusic&aid=~AID~&id=~ARTIKEL_R~\" onclick=\"doReload()\">" . image_tag(__TEMPLATE_IMAGES_PATH . "option_download_mp3.png", WORD_DOWNLOAD) . "</a>"
);

define("_TEMPLATE_MYMUSIC_MYSHOP_MYMUSIC_ITEM_OPTION_DOWNLOAD_DISABLED",
image_tag(__TEMPLATE_IMAGES_PATH . "option_download_mp3_disabled.png", WORD_DISABLED)
);

?>
<?php

$_TEMPLATE_ERRORLIST = 
"<table style=\"width:700px; border:0px solid #CC0000; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr>
<td><b>&nbsp;~TITLE~</b><br />~LIST~</td>
</tr>
</table>";

$_TEMPLATE_MESSAGELIST = 
"<table style=\"width:700px; border:0px solid #00CC00; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr>
<td>~LIST~</td>
</tr>
</table>";

$_TEMPLATE_ARTICLE_SEARCH =
"<table style=\"width:700px; padding:0px; border:2px #545454 solid; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr><td>
  <table style=\"width:100%; padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
  <tr>
    <td style=\"vertical-align:middle; padding:0px; padding-left:10px; height:20px; border:0px; background-color:#D9D9D9; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">
	  ~OPTION_DETAILS~&nbsp;&nbsp;&nbsp;<span class=\"smallblack\">[" . SHORT_ORDER_NO . " ~NUMERO~]</span></td>
    <td style=\"width:150px; padding:0px; padding-right:10px; height:20px; border:0px; background-color:#D9D9D9; font-size:11px; text-align:right;  background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">" . " ~PRICE~</td>
  </tr>
  <tr>
    <td colspan=\"2\" style=\"border:0px; padding-left:10px; padding-top:3px; background-color:#FFFFFF; font-size:11px;\">"
    . WORD_COMPOSER . ": ~COMPOSER~ <b>|</b> "
    . WORD_ARRANGER . ": ~ARRANGER~ <b>|</b> "
	. WORD_DURATION . " (min): ~DAUER~<b>|</b> "
    . WORD_DIFFICULTY . ": ~SCHWER~
	</td>
  </tr>
  <tr>
  <td colspan=\"2\" style=\"vertical-align:middle; height:30px; padding-top:0px; padding-left:10px; border:0px solid #D9D9D9; border-top:0px; border-right:0px; background-color:#FFFFFF; font-size:11px; background-image:url('" . __PNG_PATH . "ba3ck_options.png'); background-repeat:repeat-x;\">
    ~OPTION_CART~&nbsp;&nbsp;&nbsp;~OPTION_LISTEN~ 
  </td>
  </tr>
  </table>
</td></tr>
</table>" . CRLF;

$_TEMPLATE_ARTICLE_ARTICLE =
"<table style=\"border:0px; padding:0px; table-layout:fixed;\" cellspacing=\"0\">
<tr>
<td style=\"width:170px; padding:0px; vertical-align:bottom; text-align:left;\">" . 
  image_tag(__PNG_PATH."icon_article.png","","margin-bottom:0px; vertical-align:middle; text-align:left;") .
"</td>
<td style=\"vertical-align:middle; text-align:left;\"><span style=\"font-size:20px; vertical-align:middle\"><b>~TITEL~</b></span></td>
<td style=\"width:150px;\">~PLAYER~</td>
</tr>
<tr>
<td colspan=\"3\" style=\"padding:0px;\">" .
"<table style=\"width:650px; padding:0px; border:2px #545454 solid; table-layout:fixed;\" cellspacing=\"0\">
<tr>
<td style=\"padding:5px; border:0px; background:url('" . __PNG_PATH . "back_article.png') repeat-x;\"><b>" . WORD_ORDER_NO . ":</b> ~NUMERO~
<p style=\"margin-bottom:0px; margin-top:10px;\"><b>
" . WORD_COMPOSER . ":</b> ~COMPOSER~<br /><b>
" . WORD_ARRANGER . ":</b> ~ARRANGER~
</p><p style=\"margin-bottom:0px; margin-top:10px;\"><b>
" . WORD_DURATION . " (min):</b> ~DAUER~<br /><b>
" . WORD_DIFFICULTY . ":</b> ~SCHWER~<br /></p>
</td>
<td style=\"border:0px #000000 solid; vertical-align:bottom; text-align:right; padding:5px; width:150px; background:url('" . __PNG_PATH . "back_article.png') repeat-x;\">
<b>" . WORD_PRICE . ":</b> ~PRICE~<br />
~OPTION_CART~
</td>
</tr>
</table>
</td></tr>
</table>";

$_TEMPLATE_ARTICLE_CART_SMALL =
"<tr><td style=\"color:#FFFFFF; padding:0px; border:0px #000000 solid; text-align:left; vertical-align:middle; font-size:10px; background:transparent;\">\r\n
<table style=\"border:0px; padding:0px; width:100%;\" cellspacing=\"0\"><tr>
<td style=\"color:#FFFFFF; vertical-align:top; padding:0px; padding-right:5px; font-size:10px; width:20px; text-align:right; background:#444444;\">~QUANTITY~</td>
<td style=\"color:#FFFFFF; vertical-align:top; padding:0px; padding-left:5px;  font-size:10px; background:#000000;\">~TITEL~</td>
<td style=\"color:#FFFFFF; vertical-align:top; padding:0px; padding-right:5px; font-size:10px; width:45px; text-align:right; background:#444444;\">~PRICE~</td>
</tr></table>\r\n</td></tr>\r\n";

$_TEMPLATE_PRICE_SEARCH =
"<b>~STRING~~FLAT_NETTO~</b>";

$_TEMPLATE_PRICE_ARTICLE =
"<b>~STRING~~FLAT_NETTO~</b>";

$_TEMPLATE_PRICE_CART_SMALL =
"~STRING~~SUM_NETTO~";

$_TEMPLATE_PRICE_CART =
"~STRING~~SUM_NETTO~";

$_TEMPLATE_PRICE_CART_EMAIL =
"~STRING~~SUM_NETTO~";

$_TEMPLATE_AVAILABILITY =
"~STRING~";

$_TEMPLATE_CART_SMALL =
"<tr><td style=\"color:#FFFFFF; padding-left:10px; border:0px #000000 solid; height:20px; text-align:left; vertical-align:middle; font-size:11px; background-image:url('" . __PNG_PATH . "back_menu_head.png'); background-repeat:repeat-x;\">\r\n"
. WORD_CART . 
"</td></tr>\r\n
~ARTICLES~\r\n
<!--
<tr><td style=\"color:#000000; padding-left:10px; border:0px #000000 solid; height:20px; text-align:left; vertical-align:middle; font-size:10px; background:transparent;\">\r\n
delivery&nbsp;&nbsp;&nbsp;~DELIVERY~
</td></tr>\r\n
-->
<tr><td style=\"color:#000000; padding-left:10px; padding-right:5px; border:0px #000000 solid; height:20px; text-align:right; vertical-align:middle; font-size:11px; background:transparent url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">\r\n
<b>" .  WORD_SUM . "&nbsp;&nbsp;&nbsp;~SUM~</b>
</td></tr>\r\n
<tr><td style=\"color:#000000; padding-left:10px; padding-right:5px; border:0px #000000 solid; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">\r\n
&gt; <a href=\"" . $_INDEX . "?site=cart\">" . SENTENCE_CHANGE_CART . "</a>
</td></tr>\r\n<!--
<tr><td style=\"color:#000000; padding-left:10px; padding-right:5px; border:0px #000000 solid; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">\r\n
&gt; <a href=\"" . $_INDEX . "?site=order\">" . SENTENCE_PLACE_ORDER . "</a> -->
</td></tr>";

$_TEMPLATE_ARTICLE_CART =
"<form action=\"" . $_INDEX ."\" method=\"post\">
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">
<input class=\"text_02\" type=\"text\" name=\"quantity\" value=\"~QUANTITY~\" size=\"2\" maxlength=\"2\">
<input type=\"image\" src=\"./png/refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:top; margin:0px;\">
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">~NUMERO~</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:5px;  font-size:11px; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">~OPTION_DETAILS~</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">~PRICE~</td>
</tr>
<input type=\"hidden\" name=\"action\" value=\"update_cart\">
<input type=\"hidden\" name=\"id\" value=\"~RID_RAW~\">
</form>";

$_TEMPLATE_CART =
image_tag(__PNG_PATH."icon_cart.png",WORD_CART,"margin-bottom:0px; margin-right:20px; vertical-align:middle;") .
"<span style=\"font-size:20px; vertical-align:middle\"><b>" . WORD_CART . "</b></span><br />" . 
"<table style=\"border:2px #545454 solid; width:750px;\" cellspacing=\"1\">\r\n
<tr style=\"height:20px;\">
<td style=\"color:#FFFFFF; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; width:70px; text-align:right; background:url('" . __PNG_PATH . "back_menu_head.png') repeat-x;\">" . WORD_QUANTITY . "</td>
<td style=\"color:#FFFFFF; vertical-align:middle; padding:0px; padding-left:5px; padding-right:5px; font-size:11px; width:70px; text-align:right; background:url('" . __PNG_PATH . "back_menu_head.png') repeat-x;\">" . WORD_ORDER_NO. "</td>
<td style=\"color:#FFFFFF; vertical-align:middle; padding:0px; padding-left:5px;  font-size:11px; background:url('" . __PNG_PATH . "back_menu_head.png') repeat-x;\">" . WORD_TITLE . "</td>
<td style=\"color:#FFFFFF; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; width:100px; text-align:right; background:url('" . __PNG_PATH . "back_menu_head.png') repeat-x;\">" . WORD_PRICE . "</td>
</tr>
~ARTICLES~
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; text-align:right; padding-right:5px; padding-left:5px;  font-size:11px; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\"><b>" . WORD_SUM . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:url('" . __PNG_PATH . "back_menu_item.png') repeat-x;\">~SUM~</td>
</tr>
</table>\r\n";

$_TEMPLATE_ARTICLE_CART_ORDER =
"<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\">~QUANTITY~</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\">~NUMERO~</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:5px;  font-size:11px; background:transparent;\">~TITEL~</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\">~PRICE~</td>
</tr>";

$_TEMPLATE_CART_ORDER =
"<table style=\"border:1px #000000 solid; width:100%; padding:0px;\" cellspacing=\"0\">\r\n
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; width:30px; text-align:right; background:transparent;\"><b>" . SHORT_QUANTITY . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:5px; padding-right:5px; font-size:11px; width:50px; text-align:right; background:transparent;\"><b>" . SHORT_ORDER_NO. "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:5px;  font-size:11px; background:transparent;\"><b>" . WORD_TITLE . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; width:100px; text-align:right; background:transparent;\"><b>" . WORD_PRICE . "</b></td>
</tr>
~ARTICLES~
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; text-align:right; padding-right:5px; padding-left:5px;  font-size:11px; background:transparent;\"><b>" . WORD_SUM . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"><b>~SUM~</b></td>
</tr>
</table>\r\n";

$_TEMPLATE_ARTICLE_CART_EMAIL =
"~QUANTITY~" . TAB . TAB . "~NUMERO~" . TAB . TAB . "~TITEL~ (~PRICE~)" . LF;

$_TEMPLATE_CART_EMAIL =
SHORT_QUANTITY . TAB . TAB . SHORT_ORDER_NO . TAB. TAB . WORD_TITLE . LF .
"~ARTICLES~" . LF . WORD_SUM . " ~SUM~" . LF;

$_TEMPLATE_MP3PLAYER =
"<object id=\"player1_ie\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0\" width=\"150\" height=\"49\" align=\"middle\">
<param name=\"allowScriptAccess\" value=\"sameDomain\" />
<param name=\"movie\" value=\"~SWFPATH~wmplayer.swf~CONFIGXML~&autostart=true\"/>
<param name=\"quality\" value=\"best\" />
<param name=\"scale\" value=\"noscale\" />
<param name=\"salign\" value=\"lt\" />
<param name=\"bgcolor\" value=\"#ffffff\" />
<embed src=\"~SWFPATH~wmplayer.swf~CONFIGXML~&autostart=true\"
	quality=\"best\"
	scale=\"noscale\"
	salign=\"lt\"
	bgcolor=\"#ffffff\"
	width=\"150\"
	height=\"49\"
	name=\"player\"
	id=\"player1_moz\"
	align=\"middle\"
	allowScriptAccess=\"sameDomain\"
	type=\"application/x-shockwave-flash\"
	pluginspage=\"http://www.macromedia.com/go/getflashplayer\">
</embed>
</object>";

$_TEMPLATE_ARTICLE_CART_OPTION_DETAILS =
"<a class=\"lnk_04\" href=\"" . $_INDEX . "?site=article&id=~RID~\">~TITEL~</a>";

$_TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS =
"<a class=\"lnk_04\" href=\"" . $_INDEX . "?site=article&id=~RID~\"><b>~TITEL~</b></a>";

$_TEMPLATE_ARTICLE_SEARCH_OPTION_LISTEN =
"<a class=\"lnk_06\" href=\"" . $_INDEX . "?site=article&id=~RID~\">" . image_tag(__PNG_PATH."button_listen.png",WORD_LISTEN,"vertical-align:middle;") . " <b>" . WORD_LISTEN . "</b></a>";

$_TEMPLATE_ARTICLE_SEARCH_OPTION_CART =
"<a class=\"lnk_06\" href=\"" . $_INDEX . "?action=add_to_cart&id=~RID~\">" . image_tag(__PNG_PATH."button_add_to_cart.png",SENTENCE_ADD_TO_CART,"vertical-align:middle;") . " <b> " . SENTENCE_ADD_TO_CART . "</b></a>";

$_TEMPLATE_ARTICLE_ARTICLE_OPTION_CART =
"<a class=\"lnk_07\" href=\"" . $_INDEX . "?action=add_to_cart&id=~RID~\">" . image_tag(__PNG_PATH."button_add_to_cart.png",SENTENCE_ADD_TO_CART,"vertical-align:middle;") . " <b> " . SENTENCE_ADD_TO_CART . "</b></a>";

?>
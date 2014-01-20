<?php

// ARTIKEL-TEMPLATE FÜR DIE SUCHTREFFER
define("_TEMPLATE_ARTICLE_SEARCH",
"<!-- ~RID_INT~ //-->" . CRLF .
"<table style=\"width:100%; padding:0px; border:0px; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr>
<td style=\"padding:0px; height:19px; width:5px; border:0px; background-color:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."article_title_left.png") . "</td>
<td colspan=\"2\" style=\"padding:0px; padding-left:10px; height:19px; border:0px; background-color:#D9D9D9; text-align:left;\">
  <a class=\"a02\" name=\"~RID~\" href=\"./?site=article&id=~RID~\"><b>~TITEL~</b></a>
</td>
<td colspan=\"2\" style=\"padding:0px; height:19px; padding-right:7px; border:0px; background-color:#D9D9D9; font-size:13px; text-align:right;\"><b>" . WORD_ORDER_NO . " ~NUMERO~</b></td>
<td style=\"padding:0px; height:19px; width:5px; border:0px;\">" . image_tag(__TEMPLATE_IMAGES_PATH."article_title_right.png") . "</td>
</tr>
<tr>
<td colspan=\"2\" style=\"width:325px; border-left:2px solid #D9D9D9; padding-left:10px; padding-top:10px; background-color:#F3F3F3; font-size:13px; background-image:url('" . __TEMPLATE_IMAGES_PATH . "back_article_inner_left_top_corner.png'); background-repeat:no-repeat;\">"
. image_tag(__TEMPLATE_IMAGES_PATH . "icon_availability_grey.png","","vertical-align:middle") . "&nbsp;"
. WORD_AVAILABILITY . ": ~AVAILABILITY~<br />"
. image_tag(__TEMPLATE_IMAGES_PATH . "icon_price_grey.png","","vertical-align:middle"). "&nbsp;"
. WORD_PRICE . ": ~PRICE~</td>
<td rowspan=\"2\" style=\"padding:0px; border-bottom:2px solid #D9D9D9; background-color:#F3F3F3; font-size:11px; text-align:left; vertical-align:top;\">"
. WORD_COMPOSER . ": ~COMPOSER~<br />"
. WORD_ARRANGER . ": ~ARRANGER~<br />"
. WORD_DURATION . ": ~DAUER~<br />"
. WORD_DIFFICULTY . ": ~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~<br /><!--"
. WORD_PUBLISHER . ": ~PUBLISHER~<br />--><br />" . CRLF
. "~TREE_PATH~" . CRLF . 
"</td>" . CRLF . 
"<td rowspan=\"2\" style=\"padding:0px; padding-left:20px; border-bottom:2px solid #D9D9D9; background-color:#F3F3F3; font-size:11px; text-align:left; vertical-align:top;\">" .
"~BEM~" . CRLF .
"</td>" . CRLF . 
"<td rowspan=\"2\" style=\"padding-top:10px; padding-right:7px; border-bottom:2px solid #D9D9D9; background-color:#F3F3F3; font-size:11px; text-align:right; vertical-align:top;\">
  ~OPTION_THUMB~&nbsp;
</td>
<td rowspan=\"2\" style=\"padding:0px; border:2px solid #D9D9D9; border-top:0px; border-left:0px; background-color:#F3F3F3; font-size:11px;\">&nbsp;</td>
</tr>
<tr>
<td colspan=\"2\" style=\"vertical-align:bottom; padding-top:15px; padding-left:10px; padding-bottom:5px; border:2px solid #D9D9D9; border-top:0px; border-right:0px; font-size:11px; background-color:#F3F3F3; background-image:url('" . __TEMPLATE_IMAGES_PATH . "back_article_options.png'); background-repeat:no-repeat; background-position:bottom left;\">
~OPTION_CART~~OPTION_DEMO~~OPTION_MINISCORE~~OPTION_RECORDS~</td>
</tr></table>" . CRLF
);


// ARTIKEL-TEMPLATE FÜR DIE ARTIKEL-EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE",
"<span style=\"font-size:22px;\"><b>~TITEL~</b></span><br />" . CRLF . 
"~NUMERO~<br />" . CRLF .
"~TREE_PATH~<br />" . CRLF .
"<table style=\"padding:0px; width:780px; border:0px; table-layout:fixed; margin-bottom:0px; margin-top:10px;\" cellspacing=\"0\">" . CRLF . 
"<tr>" . CRLF . 
"<td style=\"width:50px; height:50px; vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."icon_composer_arranger_small.png") . "</td>" .
"<td style=\"vertical-align:top;\">" .
"<b>" . WORD_COMPOSER . ":</b> ~COMPOSER~<br />" . 
"<b>" . WORD_ARRANGER . ":</b> ~ARRANGER~" .
"</td>" . CRLF .
"<td rowspan=\"2\" style=\"width:120px; text-align:right; vertical-align:top;\">~OPTION_THUMB~</td></tr>" . CRLF . 
"<tr>" . CRLF . 
"<td style=\"width:50px; height:50px; vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."icon_duration_grade_small.png") . "</td>" . CRLF . 
"<td style=\"vertical-align:top;\">" . CRLF . 
"<b>" . WORD_DURATION . ":</b> ~DAUER~<br />" . CRLF . 
"<b>" . WORD_DIFFICULTY . ":</b> ~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</td></tr>" . CRLF . 
"<!--<tr>" . CRLF . 
"<td style=\"width:50px; height:50px; vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."icon_publisher_small.png") . "</td>" . CRLF . 
"<td style=\"vertical-align:top;\"><b>" . WORD_PUBLISHER . ":</b> ~PUBLISHER~</td>" .
"</tr>-->" . CRLF . 
"<tr>" . CRLF . 
"<td style=\"width:50px; vertical-align:top;\">&nbsp;</td>" . CRLF . 
"<td colspan=\"2\" style=\"vertical-align:top; padding-bottom:20px;\"><div style=\"padding:10px; width:100%; border:1px dashed #555555;\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."icon_info_small.png","","float:left; margin-right:10px;") . 
"~BEM~<br />~MEMBERS~</div></td>" .
"</tr>" . CRLF .
"<tr>" . CRLF . 
"<td style=\"width:50px; height:45px; vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."icon_availability.png") . "</td>" . CRLF . 
"<td colspan=\"2\" style=\"vertical-align:top;\"><b>" . WORD_AVAILABILITY . ":</b> ~AVAILABILITY~</td>" .
"</tr>" . CRLF . 
"<tr>" . CRLF . 
"<td style=\"width:50px; height:75px; vertical-align:top;\">" . image_tag(__TEMPLATE_IMAGES_PATH."icon_price.png") . "</td>" . CRLF . 
"<td colspan=\"2\" style=\"vertical-align:top;\"><b>" . WORD_PRICE . ":</b><br />~PRICE~</td>" .
"</tr>" . CRLF .
"<tr>" . CRLF . 
"<td style=\"width:50px; vertical-align:top;\">&nbsp;</td>" . CRLF . 
"<td colspan=\"2\" style=\"vertical-align:top; text-align:right;\">" . CRLF .
"<table style=\"width:350px; padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">" . CRLF .
"<tr>" . CRLF .
"  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_top_corner_grey.png","","border:0px;") . "</td>" . CRLF .
"  <td rowspan=\"2\" style=\"font-size:11px; background:#D9D9D9; vertical-align:middle; text-align:right; padding:0px;\">" . CRLF .
"    ~OPTION_MINISCORE~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_CART~" . CRLF .
"  </td>" . CRLF .
"  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_top_corner_grey.png","","border:0px;") . "</td>" . CRLF .
"</tr>" . CRLF .
"<tr>" . CRLF .
"  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_bottom_corner_grey.png","","border:0px;") . "</td>" . CRLF .
"  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_bottom_corner_grey.png","","border:0px;") . "</td>" . CRLF .
"</tr>" . CRLF .
"</table>" . CRLF .
"</td>" . CRLF .
"</tr>" . CRLF .
"</table>" . CRLF
);

// ARTIKEL-TEMPLATE FÜR DEN EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART",
"<form id=\"~UID~\" action=\"" . __INDEX ."\" method=\"get\">
<input type=\"hidden\" name=\"site\" value=\"cart\">
<input type=\"hidden\" name=\"action\" value=\"update_cart\">
<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">
<input type=\"hidden\" name=\"uid\" value=\"~UID~\">
<tr>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:0px; font-size:11px; text-align:right;\">
<table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_top_corner_grey.png","","border:0px;") . "</td>
  <td rowspan=\"2\" style=\"font-size:11px; width:100px; background:#D9D9D9; vertical-align:top; padding-top:5px; padding-left:0px;\">
    ". WORD_QUANTITY . "&nbsp;<input id=\"quantity\" class=\"char05\" type=\"text\" name=\"f_quantity\" value=\"~QUANTITY~\" size=\"1\" maxlength=\"2\" style=\"margin-bottom:5px;\"><br />
    ~OPTION_REFRESH~~OPTION_DELETE~
  </td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_top_corner_grey.png","","border:0px;") . "</td>
</tr>
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_bottom_corner_grey.png","","border:0px;") . "</td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_bottom_corner_grey.png","","border:0px;") . "</td>
</tr>
</table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:0px;  font-size:11px;\">
<table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#ADCBE7;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_top_corner_blue.png","","border:0px;") . "</td>
  <td rowspan=\"2\" style=\"width:45px !important; background:#ADCBE7; text-align:right; vertical-align:top; padding-top:5px; padding-left:0px;\">~NUMERO~</td>
  <td rowspan=\"2\" style=\"width:100%; background:#ADCBE7; vertical-align:top; padding-top:5px; padding-bottom:5px; padding-left:10px;\">
    <b>~OPTION_DETAILS~</b><br />
	<span class=\"smallblack\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~<!-- &nbsp;|&nbsp;~PUBLISHER~ --></span><br />
	~VERSION~&nbsp;~OPTION_COPY~<br />
	~OPTION_MINISCORE~~OPTION_DEMO~~OPTION_RECORDS~
  </td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#ADCBE7;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_top_corner_blue.png","","border:0px;") . "</td>
</tr>
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#ADCBE7;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_bottom_corner_blue.png","","border:0px;") . "</td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#ADCBE7;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_bottom_corner_blue.png","","border:0px;") . "</td>
</tr>
</table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\">~PRICE~</td>
</tr>
</form>
<script type=\"text/javascript\"> checkDetail('~UID~'); </script>" . CRLF
);

// ARTIKEL-TEMPLATE FÜR DIE BESTELLÜBERSICHT
define("_TEMPLATE_ARTICLE_ORDER",
"<tr>" . CRLF . 
"<td style=\"border-bottom:1px solid #000000;\">~NUMERO~</td> " . CRLF . 
"<td style=\"border-bottom:1px solid #000000;\">~TITEL~<br /><span class=\"smallgrey\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~<!-- &nbsp;|&nbsp;~PUBLISHER~ --></span></td>" . CRLF . 
"<td style=\"border-bottom:1px solid #000000;\">~VERSION~</td>" . CRLF . 
"<td style=\"border-bottom:1px solid #000000;\">~QUANTITY~</td>" . CRLF . 
"<td style=\"border-bottom:1px solid #000000;\">~PRICE~</td></tr>" . CRLF
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_CART",
"<a href=\"" . __INDEX . "?site=~SITE~&action=add_to_cart&aid=~AID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_cart.png",SENTENCE_ADD_TO_CART,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO", 
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_demo.png",WORD_DEMO,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&aid=~AID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore.png",SENTENCE_SEND_MINISCORE,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_record.png",SENTENCE_SEARCH_RECORDS,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_BLANK\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\"></a>"
);

// TEMPLATE FÜR OPTION DETAILS ANZEIGEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DETAILS",
"<a class=\"a02\" href=\"" . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>"
);

// TEMPLATE FÜR OPTION AKTUALISIEREN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_REFRESH",
"<input type=\"image\" src=\"" . __TEMPLATE_IMAGES_PATH . "option_refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:middle; margin-right:10px;\">"
);

// TEMPLATE FÜR OPTION LÖSCHEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DELETE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=delete_from_cart&aid=~AID~&uid=~UID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_delete.png",SENTENCE_DELETE_FROM_CART,"vertical-align:middle; margin-right:10px;")
);

// TEMPLATE FÜR OPTION DEMO IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DEMO", 
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_demo_blue.png",WORD_DEMO,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore_blue.png",SENTENCE_SEND_MINISCORE,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_record_blue.png",SENTENCE_SEARCH_RECORDS,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);


// TEMPLATE FÜR OPTION KOPIEREN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_COPY",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&id=~RID~&vid=~VERSION_R~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_copy_blue.png",SENTENCE_COPY_ARTICLE_VERSION,"vertical-align:middle; margin-right:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_CART",
_TEMPLATE_ARTICLE_SEARCH_OPTION_CART
);

// TEMPLATE FÜR OPTION DEMO IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_DEMO", 
_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO
);

// TEMPLATE FÜR OPTION MINISCORE IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_MINISCORE",
_TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_RECORDS",
_TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_BLANK\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\"></a>"
);

// TEMPLATE FÜR EMAIL MELDUNG BROKEN LINK
define("_TEMPLATE_ARTICLE_BROKEN_LINK_EMAIL",
SYS_WORD_ARTICLE_ID . ": ~RID_INT~" . CRLF . WORD_TITLE . ": ~TITEL~"
);

?>

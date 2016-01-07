<?php

define("__TEMPLATE_PROJECTNAME","TemplateHeBu");


define("_TEMPLATE_ACCOUNT_MYSHOP_ACCOUNT",
"<span style=\"color:#0C0;\">~POSITIVE~</span><span style=\"color:#C00;\">~NEGATIVE~</span>~BALANCED~~STRING~"
);


define("_TEMPLATE_ADDRESS_SIGNON",
"~OPTION_STREET~" . CRLF . "~OPTION_ORT_FORMAT~"
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_STREET",
"" . WORD_STREET . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_street\" maxlength=\"50\" size=\"35\" value=\"~STREET~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_ZIP",
"" . WORD_ZIP_CODE . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_zip_code\" maxlength=\"10\" size=\"5\" value=\"~ZIP~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_CITY",
"" . WORD_CITY  . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_city\" maxlength=\"50\" size=\"25\" value=\"~CITY~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_STATE",
"" . WORD_STATE . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_state\" maxlength=\"5\" size=\"5\" value=\"~STATE~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_NAME",
SENTENCE_CLUB_NAME . " / " . SENTENCE_COMPANY_NAME . "*<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_name\" maxlength=\"50\" size=\"30\" value=\"~NAME1~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_VALIDATE",
"~NAME1~<br /><br />~STREET~<br />" . CRLF . "~OPTION_ORT_FORMAT~" . CRLF
);


define("_TEMPLATE_ADDRESS_MYSHOP",
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF . 
"~OPTION_STREET~" . CRLF . "~OPTION_ORT_FORMAT~<br />" . CRLF . "~OPTION_NAME~" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_user_address\">" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF .
"<input type=\"submit\" value=\"" . WORD_SAVE . "\" style=\"margin-top:10px; font-family:Tahoma; font-size:11px; font-weight:bold; border:2px solid #6699CC; padding-left:10px; padding-right:10px; background:#FFFFFF;\">" . CRLF . 
"</form>" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_STREET",
"" . WORD_STREET . ":&nbsp;" . CRLF .
"<input class=\"char05\" type=\"text\" name=\"f_street\" maxlength=\"50\" size=\"35\" value=\"~STREET~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_ZIP",
"" . WORD_ZIP_CODE . ":&nbsp;" . CRLF .
"<input class=\"char05\" type=\"text\" name=\"f_zip_code\" maxlength=\"10\" size=\"5\" value=\"~ZIP~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_CITY",
"" . WORD_CITY  . ":&nbsp;" . CRLF .
"<input class=\"char05\" type=\"text\" name=\"f_city\" maxlength=\"50\" size=\"25\" value=\"~CITY~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_STATE",
"" . WORD_STATE . ":&nbsp;" . CRLF .
"<input class=\"char05\" type=\"text\" name=\"f_state\" maxlength=\"5\" size=\"5\" value=\"~STATE~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_NAME",
SENTENCE_CLUB_NAME . " / " . SENTENCE_COMPANY_NAME . "*:&nbsp;" . CRLF .
"<input class=\"char05\" type=\"text\" name=\"f_name\" maxlength=\"50\" size=\"30\" value=\"~NAME1~\" /><br />" . CRLF
);

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


define("_TEMPLATE_AVAILABILITY",
"~STRING~"
);


define("_TEMPLATE_BILL_MYSHOP_ACCOUNT",
"<tr><td style=\"padding-left:5px;\"><a href=\"./viewer.php?file=~ENCRYPTED_DOCUMENT~\" target=\"_blank\">~NUMBER~</a></td><td style=\"text-align:right;\">~TOPAY~</td><td style=\"text-align:right;\">~DATE~</td><td style=\"text-align:right; padding-right:5px;\">~TIME~</td></tr>" . CRLF
);

/**
 * define("_TEMPLATE_BILL_MYSHOP_ACCOUNT_OPTION_HTML",
 * "<a href=\"./viewer.php?file=~OPTION_ENCRYPTED_DOCUMENT~\" target=\"_blank\">~NUMBER~</a>"
 * );

 */

define("_TEMPLATE_CART",
image_tag(__TEMPLATE_IMAGES_PATH."icon_cart.png",WORD_CART,"margin-bottom:10px; margin-right:20px; vertical-align:middle;") .
"<span style=\"font-size:22px; vertical-align:middle;\"><b>" . WORD_CART . "</b></span><br />" . 
"~OBJ_MESSAGELIST~" . CRLF .
"<table style=\"border:0px #545454 solid; width:780px;\" cellspacing=\"5\">" . CRLF . 
"~ARTICLES~
<tr>
<td>
  <table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
  <tr>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_top_corner_grey.png","","border:0px;") . "</td>
    <td rowspan=\"2\" style=\"font-size:11px; width:100px; background:#D9D9D9; vertical-align:top; text-align:center; padding-top:5px; padding-left:0px;\">
      " . WORD_REFRESH . "<br />~OPTION_REFRESH_DELIVERY~
    </td>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_top_corner_grey.png","","border:0px;") . "</td>
  </tr>
  <tr>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_bottom_corner_grey.png","","border:0px;") . "</td>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_bottom_corner_grey.png","","border:0px;") . "</td>
  </tr>
  </table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:0px; font-size:11px;\">
<table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_left_top_corner_green.png","","border:0px;") . "</td>
  <td rowspan=\"2\" style=\"width:45px !important; background:#CCFFB3; text-align:right; vertical-align:top; padding-top:5px; padding-left:0px;\"></td>
  <td rowspan=\"2\" style=\"width:100%; background:#CCFFB3; vertical-align:top; padding-top:5px; padding-left:10px;\">
    <b>" . WORD_SHIPPING . "</b><br /><br />&nbsp;
  </td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_right_top_corner_green.png","","border:0px;") . "</td>
</tr>
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_left_bottom_corner_green.png","","border:0px;") . "</td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_right_bottom_corner_green.png","","border:0px;") . "</td>
</tr>
</table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\"><b>~DELIVERY~</b></td>
</tr>
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; text-align:right; padding-right:5px; padding-left:5px;  font-size:14px;\"><b>" . WORD_SUM . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\"><b>~SUM~</b></td>
</tr>
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<!-- <td style=\"color:#000000; vertical-align:middle; text-align:left; padding-right:5px; padding-left:5px; font-size:14px;\">~OPTION_LOAD~</td> -->
<td colspan=\"2\" style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\">~OPTION_ORDER~</td>
</tr>
</table>" . CRLF
);

define("_TEMPLATE_CART_OPTION_ORDER",
"<a href=\"" . __INDEX . "?site=order\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_order.png",SENTENCE_GO_TO_CHECKOUT,"vertical-align:middle; margin-bottom:5px;") . 
"<br />" . SENTENCE_GO_TO_CHECKOUT .
"</a>"
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
"<table style=\"border:2px #545454 solid; width:780px; padding:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr><td><b>" . WORD_ORDER_NO . "</b></td><td><b>" . WORD_TITLE . "</b></td><td><b>" . WORD_VERSION . "</b></td><td><b>" . WORD_QUANTITY . "</b></td><td><b>" . WORD_PRICE . "</b></td></tr>" . CRLF . 
"~ARTICLES~" . CRLF .
"<tr><td></td><td>" . WORD_SHIPPING . "</td><td></td><td></td><td>~DELIVERY~</td></tr>" . CRLF . 
"<tr><td></td><td><b>" . WORD_SUM . "</b></td><td></td><td></td><td><b>~SUM~</b></td></tr>" . CRLF . 
"</table>" . CRLF
);

define("_TEMPLATE_COUNTRIES_SIGNON",
"<select class=\"select01\" name=\"f_country_r\">" . CRLF .
"~LIST~" . CRLF .
"</select>" . CRLF
);

define("_TEMPLATE_COUNTRY_SIGNON",
"~OPTION_SELECT~" . CRLF
);

define("_TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_UNSELECTED",
"<option value=\"~RID~\">~NAME~</option>"
);

define("_TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_SELECTED",
"<option value=\"~RID~\" selected>~NAME~</option>"
);

define("_TEMPLATE_ERRORLIST",
"<table style=\"width:780px; border:2px solid #CC0000; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr>
<td style=\"width:25px; border:0px; padding:5px; background-color:#FFFFFF; vertical-align:top; text-align:left;\">~ICON~</td>
<td style=\"border:0px; padding:5px; background-color:#FFCCCC; background-image:url('" . __TEMPLATE_IMAGES_PATH . "back_error.png'); background-repeat:repeat-y;\"><b>~LIST~</b></td>
</tr>
</table>"
);


define("_TEMPLATE_MAILINGS",
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF .
"~ITEMS~" . CRLF .
"<input type=\"hidden\" name=\"action\" value=\"set_mailings\"><br />" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF .  
"<input type=\"submit\" value=\"" . WORD_SAVE . "\" style=\"font-family:Tahoma; font-size:11px; font-weight:bold; border:2px solid #6699CC; padding-left:10px; padding-right:10px; background:#FFFFFF;\">" . CRLF .
"</form>"
);

define("_TEMPLATE_MAILING",
"<input type=\"checkbox\" id=\"chkbox~RID~\" name=\"f_mailings[]\" value=\"~RID~\" ~CHECKED~>&nbsp;<label for=\"chkbox~RID~\">~NAME~</label><br />"
);

define("_TEMPLATE_MESSAGELIST",
"<table style=\"width:780px; border:2px solid #00CC00; table-layout:fixed; margin-bottom:10px;\" cellspacing=\"0\">
<tr>
<td style=\"width:25px; border:0px; padding:5px; background-color:#FFFFFF; vertical-align:top; text-align:left;\">~ICON~</td>
<td style=\"border:0px; padding:5px; background-color:#E5FFCB; background-image:url('" . __TEMPLATE_IMAGES_PATH . "back_message.png'); background-repeat:repeat-y;\"><b>~LIST~</b></td>
</tr>
</table>"
);

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

define("_TEMPLATE_PERSON_SIGNON",
"~OPTION_FIRSTNAME~" . CRLF . 
"~OPTION_SURNAME~" . CRLF . 
"~OPTION_USER~" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_FIRSTNAME",
WORD_FIRSTNAME . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_firstname\" maxlength=\"50\" size=\"15\" value=\"~VORNAME~\" /><br />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_SURNAME",
WORD_SURNAME . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_surname\" maxlength=\"50\" size=\"30\" value=\"~NACHNAME~\" /><br />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_USER",
WORD_EMAIL . "<br />" . CRLF .
"<input class=\"char04\" type=\"text\" name=\"f_user\" maxlength=\"50\" size=\"35\" value=\"~USER_ID~\" /><br />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_VALIDATE",
"~VORNAME~&nbsp;~NACHNAME~<br />" . CRLF .
"~USER_ID~" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_ADDRESSES_DELIVERY",
"<input type=\"radio\" id=\"dradio~RID~\" name=\"f_dcontact_r\" value=\"~RID~\" ~OPTION_CHECKED~><label for=\"dradio~RID~\">~VORNAME~&nbsp;~NACHNAME~&nbsp;" . CRLF .
"~ADDRESS~</label><br />" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_ADDRESSES_BILL",
"<input type=\"radio\" id=\"bradio~RID~\" name=\"f_bcontact_r\" value=\"~RID~\" ~OPTION_CHECKED~><label for=\"bradio~RID~\">~VORNAME~&nbsp;~NACHNAME~&nbsp;" . CRLF .
"~ADDRESS~</label><br />" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_OVERVIEW",
"~VORNAME~&nbsp;~NACHNAME~<br />" . CRLF .
"~ADDRESS~" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_EMAIL",
load_raw_txt(__LANGUAGE_PATH.__LANGUAGE."/order-email.txt")
);

define("_TEMPLATE_PERSON_HELP_EMAIL",
CRLF . CRLF .
"~RID~" . CRLF .
"~VORNAME~ ~NACHNAME~" . CRLF .
"~USER_ID~"
);

define("_TEMPLATE_PERSON_MYSHOP",
"<div style=\"padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
WORD_CUSTOMER_NO . ": <b>~NUMMER~</b><br />" . CRLF .
WORD_NAME . ": <b>~VORNAME~&nbsp;~NACHNAME~</b></div><br /><br />" . CRLF .
"<b>" . WORD_ADDRESS . "</b><br />" . CRLF .
"<div style=\"padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
"~ADDRESS~</div><br /><br />" . CRLF .
"<!-- ~EMAIL~<br /> -->" . CRLF .
"<b>" . WORD_EMAIL . "</b><br />" . CRLF . 
"<div style=\"padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF .
WORD_ACTUAL . ":&nbsp;" . CRLF . 
"<input class=\"char05\" type=\"text\" name=\"f_user\" maxlength=\"50\" size=\"35\" value=\"~USER_ID~\" /><br />" . CRLF .
"<span class=\"smallgrey\">~EMAILS~</span><br />" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_user_id\">" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF .
"<input type=\"submit\" value=\"" . WORD_SAVE . "\" style=\"margin-top:10px; font-family:Tahoma; font-size:11px; font-weight:bold; border:2px solid #6699CC; padding-left:10px; padding-right:10px; background:#FFFFFF;\">" . CRLF .
"</form>" . CRLF . 
"</div><br /><br />" . CRLF
);

define("_TEMPLATE_PERSON_MYSHOP_ACCOUNT_BILLS",
"<table style=\"padding:0px; border:0px; margin:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr><td style=\"background:#ADCBE7; padding-left:5px;\">" . WORD_BILL . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:15px;\">" . SENTENCE_AMOUNT_OUTSTANDING . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:50px;\">" . WORD_DATE . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:15px; padding-right:5px;\">" . WORD_TIME . "</td></tr>" . CRLF .
"~BILLS~" . CRLF .
"</table>" . CRLF
);

define("_TEMPLATE_PERSON_MYSHOP_SETTINGS_DISCOUNT",
"~OPTION_DISCOUNT~"
);

define("_TEMPLATE_PERSON_MYSHOP_SETTINGS_OPTION_DISCOUNT",
"<div style=\"padding:5px; border:1px dashed #AAAAAA; margin-top:15px;\">" . CRLF .
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF . 
"<b>" . SENTENCE_SHOW_DISCOUNT . ":</b>" . CRLF . 
"<input type=\"radio\" name=\"f_choice\" value=\"Y\"  style=\"vertical-align:middle;\" ~OPTION_USER_RABATT_Y~>&nbsp;" . WORD_YES . CRLF . 
"<input type=\"radio\" name=\"f_choice\" value=\"N\"  style=\"vertical-align:middle;\" ~OPTION_USER_RABATT_N~>&nbsp;" . WORD_NO . CRLF . 
"<br /><br />" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_show_discount\">" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF .
"<input type=\"submit\" value=\"" . WORD_SAVE . "\" style=\"font-family:Tahoma; font-size:11px; font-weight:bold; border:2px solid #6699CC; padding-left:10px; padding-right:10px; background:#FFFFFF;\">" . CRLF .
"</form>" . CRLF .
"</div>" . CRLF
);


// TEMPLATE FÜR EMAIL MELDUNG BROKEN LINK
define("_TEMPLATE_PERSON_BROKEN_LINK_EMAIL",
SYS_WORD_USER_ID . ": ~RID~" . CRLF . WORD_EMAIL . ": ~EMAIL~"
);

define("_TEMPLATE_PRICE_SEARCH",
"<b>~STRING~~SUM_NETTO~</b>"
);

define("_TEMPLATE_PRICE_SEARCH_DISCOUNT",
"<b>~STRING~~SUM_BRUTTO~</b> <span class=\"grey\">(~SUM_NETTO~ - ~PERCENT~)</span>"
);

define("_TEMPLATE_PRICE_CART",
"~STRING~<b>~SUM_NETTO~</b><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DISCOUNT",
"~STRING~<b>~SUM_BRUTTO~</b><br /><span class=\"smallred\">~PERCENT~</span><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DELIVERY",
"~STRING~<b>~SUM_NETTO~</b>"
);

define("_TEMPLATE_PRICE_ARTICLE",
"<span style=\"font-size:22px;\"><b>~FLAT_NETTO~~STRING~</b></span>"
);

define("_TEMPLATE_PRICE_ARTICLE_DISCOUNT",
"<span style=\"font-size:22px;\"><b>~SUM_BRUTTO~~STRING~</b></span><br /><span class=\"smallgrey\">~PERCENT~<br />~SUM_NETTO~</span>"
);

define("_TEMPLATE_PRICE_ORDER",
"~STRING~~SUM_BRUTTO~"
);

define("_TEMPLATE_PRICE_ORDER_DELIVERY",
"~STRING~~SUM_NETTO~"
);

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

define("_TEMPLATE_OPTION_LOGIN",
"<a class=\"a01\" href=\"" . __INDEX . "?action=prepare_login&site=~SITE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."icon_small_login_header.png","","vertical-align:middle;") . 
"<b>" . WORD_LOGIN . "</b></a>"
);

define("_TEMPLATE_OPTION_LOGOUT",
"<a class=\"a01\" href=\"" . __INDEX . "?action=logout&site=~SITE~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."icon_small_logout_header.png","","vertical-align:middle;") . 
"<b>" . WORD_LOGOUT . "</b></a>"
);

define("_TEMPLATE_TREE_NODE_INDENT",
image_tag(__TEMPLATE_IMAGES_PATH."tree_space.png","","text-align:center; vertical-align:middle;") . "&nbsp;"
);

define("_TEMPLATE_TREE_NODE_OPEN",
"<a href=\"" . __INDEX . "?action=open_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_plus.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_CLOSE",
"<a href=\"" . __INDEX . "?action=close_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_minus.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_EMPTY", 
image_tag(__TEMPLATE_IMAGES_PATH."tree_empty.png","","text-align:center; vertical-align:middle;")
);

define("_TEMPLATE_TREE_NODE_SELECT",
"<a href=\"" . __INDEX . "?action=select_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_unselected.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_UNSELECT",
"<a href=\"" . __INDEX . "?action=unselect_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_selected.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_NAME",
"<a name=\"~CODE~\" href=\"" . __INDEX . "?action=search_tree_node&site=search&sid=~NEXT_SID~&id=~CODE~\" style=\"vertical-align:middle;\">~NAME~</a>"
);

define("_TEMPLATE_VERSIONS",
"<select id=\"version\" class=\"select01\" name=\"f_version_r\" onchange=\"javascript:checkDetail('~ID~',true);\">
~VERSIONS~
</select>
<input id=\"detail\" class=\"char05\" type=\"text\" name=\"f_detail\" value=\"~DETAIL~\" onblur=\"submit();\">"
);

define("_TEMPLATE_VERSION",
"<option value=\"~RID~\" ~PRESELECT~>~NAME~</option>" . CRLF
);

define("_TEMPLATE_VERSIONS_ORDER",
"~NAME~&nbsp;~DETAIL~"
);

<?php

define("__TEMPLATE_PROJECTNAME","TemplateHeBu2008Music");

define("_TEMPLATE_ERRORLIST",
"<div class=\"errorlist\">
<p><b>~LIST~</b></p>
</div>" . CRLF
);

define("_TEMPLATE_MESSAGELIST",
"<div class=\"messagelist\">
<p><b>~LIST~</b></p>
</div>" . CRLF
);

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

define("__TEMPLATE_ARTICLE_LINK_DEMO",
image_tag(__TEMPLATE_IMAGES_PATH."icon_internet_blue.png","","float:left; margin-right:10px; margin-bottom:10px;") . CRLF . 
str_replace("~TITEL~","<b>~TITEL~</b>",VARIABLE_SENTENCE_LISTEN_TO_X_ON) . CRLF .
"<br /><a href=\"~URL_RAW~\" target=\"_blank\"><b>~HOST~</b></a><br />" . CRLF .
"<span class=\"smallblack\">" . VARIABLE_SENTENCE_PLEASE_CLICK_X_IF_BROKEN_LINK . "</span><br /><br />" . CRLF
);

define("_TEMPLATE_ARTICLE_LINK_DEMO",
"<p>" . str_replace("~TITEL~","<b>~TITEL~</b>",VARIABLE_SENTENCE_LISTEN_TO_X_ON). "&nbsp;<a href=\"~URL_RAW~\" target=\"_blank\"><b>~HOST~</b></a></p>" . CRLF .
"<p class=\"hint\">" . VARIABLE_SENTENCE_PLEASE_CLICK_X_IF_BROKEN_LINK . "</p><hr />" . CRLF
);

define("_TEMPLATE_ARTICLE_LINK_DEMO_OPTION_BROKEN_LINK",
"<a class=\"a01s\" href=\"" . __INDEX . "?action=broken_link&id=~ARTICLE_R~&url=~URL~\">" . WORD_HERE . "</a>"
);

define("_TEMPLATE_ARTICLE_LINK_ARTICLE_MEMBER",
"<a href=\"" . __INDEX . "?site=article&id=~ARTICLE_R~\">~TITEL~</a><br />" . CRLF
);

define("_TEMPLATE_ARTICLE_LINK_PROMO_PAKETS",
"<p class=\"text\">" . 
"<a href=\"" . __INDEX . "?action=search_members&site=search&sid=~OPTION_SID~&id=~ARTICLE_R~\">" . 
"<div class=\"promo_paket_image\">~OPTION_THUMB~&nbsp;</div>" . 
"~TITLE_BREAK_COLON~" . 
"<div class=\"clear\"></div>" . 
"</a>" .
"</p>" . CRLF
);

define("_TEMPLATE_ARTICLE_LINK_PROMO_PAKETS_OPTION_THUMB",
"<img src=\"~THUMB~\" />" . CRLF
);

define("_TEMPLATE_ORDER_ORDER_OVERVIEW_OPTION_DATE",
"<p class=\"subtitle\">" . WORD_DATE_OF_DELIVERY . "</p><p>~DATE~</p><hr />"
);

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

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW",
"<p>
<input type=\"radio\" class=\"radio\" id=\"pradio_~TYPE~_~RID~\" name=\"f_payment\" value=\"~RID~\" ~OPTION_CHECKED~ />
<label for=\"pradio_~TYPE~_~RID~\"><b>" . SENTENCE_NEW_BANKINFO . ":</b></label>
<input type=\"hidden\" name=\"type\" value=\"~TYPE~\">
</p>" . CRLF .
"<div style=\"margin-left:35px; margin-bottom:20px;\">" . CRLF . 
"~OPTION_DEPOSITOR~" . CRLF . 
"~OPTION_BANK~" . CRLF . 
"~OPTION_BAN~" . CRLF .
"~OPTION_BIC~" . CRLF . 
"</div>" . CRLF
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_PREVIOUS",
"<p>
<input type=\"radio\" class=\"radio\" id=\"pradio_~TYPE~_~RID~\" name=\"f_payment\" value=\"~RID~\" ~OPTION_CHECKED~ />
<label for=\"pradio_~TYPE~_~RID~\"><b>~DEPOSITOR~, ~BANK~, ~BAN_MASKED~, ~BIC~</b></label>
<input type=\"hidden\" name=\"type\" value=\"~TYPE~\">
</p>" . CRLF 
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_DEPOSITOR",
"<p class=\"fieldtitle\">" . WORD_DEPOSITOR . "</p><input type=\"text\" class=\"short\" name=\"f_depositor\" value=\"~DEPOSITOR~\" size=\"50\" maxlength=\"45\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BAN",
"<p class=\"fieldtitle\">" . WORD_BANK_ACCOUNT_NUMBER . "</p><input type=\"text\" class=\"short\" name=\"f_ban\" value=\"~BAN~\" size=\"45\" maxlength=\"45\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BANK",
"<p class=\"fieldtitle\">" . WORD_BANK . "</p><input type=\"text\" class=\"short\" name=\"f_bank\" value=\"~BANK~\" size=\"45\" maxlength=\"45\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BIC",
"<p class=\"fieldtitle\">" . WORD_BANK_IDENTIFICATION_CODE . "</p><input type=\"text\" class=\"short\" name=\"f_bic\" value=\"~BIC~\" size=\"35\" maxlength=\"35\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_OVERVIEW",
"<p class=\"subtitle\">" . WORD_BANKINFO . "</p>
<p>~DEPOSITOR~</p>
<p>~BANK~</p>
<p>~BAN_MASKED~</p>
<p>~BIC~</p>
<hr />"
);

define("_TEMPLATE_PERSON_SIGNON",
"<table class=\"form\" cellspacing=\"0\">
  <tr>
    <td id=\"first_col\">~OPTION_FIRSTNAME~</td>
    <td>~OPTION_SURNAME~</td>
  </tr>
  <tr>
    <td id=\"first_col\">~OPTION_USER~</td>
    <td><!-- <p class=\"fieldtitle\">eMail wiederholen</p><input type=\"text\"> --></td>
  </tr>
  <tr>
    <td id=\"first_col\">~OPTION_PHONE~</td>
    <td><p class=\"fieldtitle\">~OPTION_FAX~</td>
  </tr>
</table>" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_FIRSTNAME",
"<p class=\"fieldtitle\">" . WORD_FIRSTNAME . "</p><input type=\"text\" name=\"f_firstname\" maxlength=\"50\" value=\"~VORNAME~\" />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_SURNAME",
"<p class=\"fieldtitle\">" . WORD_SURNAME . "</p><input type=\"text\" name=\"f_surname\" maxlength=\"50\" value=\"~NACHNAME~\" />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_USER",
"<p class=\"fieldtitle\">" . WORD_EMAIL . "</p><input type=\"text\" name=\"f_user\" maxlength=\"50\" value=\"~USER_ID~\" />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_PHONE",
"<p class=\"fieldtitle\">" . WORD_PHONE . "&nbsp;*</p><input type=\"text\" name=\"f_phone\" maxlength=\"25\" value=\"~PRIV_TEL~\" />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_OPTION_FAX",
"<p class=\"fieldtitle\">" . WORD_FAX . "&nbsp;*</p><input type=\"text\" name=\"f_fax\" maxlength=\"25\" value=\"~PRIV_FAX~\" />" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_VALIDATE",
"<p class=\"text\" id=\"left\">
  ~VORNAME~&nbsp;~NACHNAME~<br />
  ~ADDRESS~
</p>
<p class=\"text\" id=\"left\">
  ~USER_ID~<br />
  ~OPTION_PHONE~<br />
  ~OPTION_FAX~
</p>" . CRLF
);

define("_TEMPLATE_PERSON_SIGNON_VALIDATE_OPTION_PHONE",
WORD_PHONE . "&nbsp;~PRIV_TEL~"
);

define("_TEMPLATE_PERSON_SIGNON_VALIDATE_OPTION_FAX",
WORD_FAX . "&nbsp;~PRIV_FAX~"
);

define("_TEMPLATE_PERSON_ORDER_ADDRESSES_DELIVERY",
"<p><input type=\"radio\" class=\"radio\" id=\"dradio~RID~\" name=\"f_dcontact_r\" value=\"~RID~\" ~OPTION_CHECKED~ onclick=\"checkIfBillAndDeliveryAddressEqual()\" />&nbsp;<label for=\"dradio~RID~\">~VORNAME~&nbsp;~NACHNAME~&nbsp;" . CRLF .
"~ADDRESS~</label></p>" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_ADDRESSES_BILL",
"<p><input type=\"radio\" class=\"radio\" id=\"bradio~RID~\" name=\"f_bcontact_r\" value=\"~RID~\" ~OPTION_CHECKED~ onclick=\"checkIfBillAndDeliveryAddressEqual()\" />&nbsp;<label for=\"bradio~RID~\">~VORNAME~&nbsp;~NACHNAME~&nbsp;" . CRLF .
"~ADDRESS~</label></p>" . CRLF
);

define("_TEMPLATE_PERSON_ORDER_OVERVIEW",
"~VORNAME~&nbsp;~NACHNAME~" . CRLF .
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
"<div class=\"myshop\">" . CRLF .
"<p class=\"fieldtitle\">" . WORD_CUSTOMER_NO . "</p><p class=\"line\"><b>~NUMMER~</b></p>" . CRLF .
"<p class=\"fieldtitle\">" . WORD_NAME . "</p><p class=\"line\"><b>~VORNAME~&nbsp;~NACHNAME~</b></p></div>" . CRLF .
"<p class=\"steptitle\">" . WORD_ADDRESS . "</p>" . CRLF .
"<div class=\"myshop\">" . CRLF .
"~ADDRESS~</div>" . CRLF .
"<!-- ~EMAIL~<br /> -->" . CRLF .
"<p class=\"steptitle\">" . WORD_EMAIL . "</p>" . CRLF . 
"<div class=\"myshop\">" . CRLF .
"<form action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"<p class=\"fieldtitle\">" . WORD_ACTUAL . "</p>" . CRLF . 
"<input type=\"text\" name=\"f_user\" maxlength=\"50\" size=\"35\" value=\"~USER_ID~\" /><br />" . CRLF .
"<p class=\"hint\">~EMAILS~</p>" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_user_id\">" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF .
"<input type=\"submit\" class=\"button\" value=\"" . WORD_SAVE . "\">" . CRLF .
"</form>" . CRLF . 
"</div>" . CRLF
);

define("_TEMPLATE_PERSON_MYSHOP_ACCOUNT_BILLS",
"<table style=\"padding:0px; border:0px; margin:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr>" .
"<td style=\"background:#ADCBE7; padding-left:5px;\">" . WORD_BILL . "</td>" . CRLF . 
"<td style=\"background:#ADCBE7; padding-left:5px;\">" . WORD_MISSION . "</td>" . CRLF . 
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
"<div class=\"myshop\">" . CRLF .
"<form action=\"" . __INDEX . "\" method=\"post\">" . CRLF . 
"<b>" . SENTENCE_SHOW_DISCOUNT . ":</b>" . CRLF . 
"<input type=\"radio\" class=\"radio\" name=\"f_choice\" value=\"Y\"  style=\"vertical-align:middle;\" ~OPTION_USER_RABATT_Y~ />&nbsp;" . WORD_YES . CRLF . 
"<input type=\"radio\" class=\"radio\" name=\"f_choice\" value=\"N\"  style=\"vertical-align:middle;\" ~OPTION_USER_RABATT_N~ />&nbsp;" . WORD_NO . CRLF . 
"<br /><br />" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_show_discount\" />" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .
"<input type=\"submit\" class=\"button\" value=\"" . WORD_SAVE . "\" />" . CRLF .
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

define("__TEMPLATE_PRICE_CART",
"~STRING~<b>~SUM_NETTO~</b><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART",
"~STRING~<b>~FLAT_NETTO~</b>"
);

define("_TEMPLATE_PRICE_CART_DISCOUNT",
"~STRING~<b>~SUM_BRUTTO~</b><br /><span class=\"smallred\">~PERCENT~</span><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DELIVERY",
"~STRING~<b>~SUM_NETTO~</b><!-- ~VALUE~ -->"
);

define("_TEMPLATE_PRICE_ARTICLE",
"<b>~FLAT_NETTO~~STRING~</b>"
);

define("_TEMPLATE_PRICE_ARTICLE_DISCOUNT",
"<p><b>~SUM_BRUTTO~~STRING~</b></p><p><span class=\"hint\">~PERCENT~<br />~SUM_NETTO~</span></p>"
);

define("_TEMPLATE_PRICE_ORDER",
"~STRING~~SUM_BRUTTO~"
);

define("_TEMPLATE_PRICE_ORDER_DISCOUNT",
"~STRING~~SUM_BRUTTO~ <p class=\"hint\">(~SUM_NETTO~ - ~PERCENT~)</p>"
);

define("_TEMPLATE_PRICE_ORDER_DELIVERY",
"~STRING~~SUM_NETTO~"
);

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

define("_TEMPLATE_OPTION_LOGIN",
"<div class=\"mainmenuitem\" id=\"mainmenutitle\"><b>" . WORD_LOGIN . "</b></div>" . CRLF .
"<a id=\"mainmenuitem\" href=\"" . __INDEX . "?action=prepare_login&site=~SITE~\">" . SENTENCE_CUSTOMER_LOGIN . "</a>" . CRLF . 
"<a id=\"mainmenuitem\" href=\"" . __INDEX . "?site=signon\">" . SENTENCE_BECOME_CUSTOMER . "</a>" . CRLF
);

define("_TEMPLATE_OPTION_LOGOUT",
"<div class=\"mainmenuitem\" id=\"mainmenutitle\"><a style=\"color:#FFF; font-style:normal;\" href=\"" . __INDEX . "?action=logout&site=~SITE~\"><b>" . WORD_LOGOUT . "</b></a></div>"
);

define("_TEMPLATE_OPTION_NEWSLETTER",
"<a id=\"mainmenuitem\" href=\"" . __INDEX . "?site=~SITE~\">" . WORD_NEWSLETTER . "</a>"
);

$_TAGS = array(
"ARTICLES" => array(
  "NAME" => "Artikel",
  "CODE" => "[ARTICLES]1,2,3[/ARTICLES]",
  "TEMPLATE" => "",
  "FUNCTION" => "get_articles",
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 0
),
"ARTICLES_DETAIL" => array(
  "NAME" => "Detailansicht Artikel",
  "CODE" => "[ARTICLES_DETAIL]1,2,3[/ARTICLES_DETAIL]",
  "TEMPLATE" => "",
  "FUNCTION" => "get_articles_detail",
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 0
));


/*

"HEAD" => array(
  "NAME" => "Überschrift",
  "CODE" => "[HEAD]Überschrift[/HEAD]",
  "TEMPLATE" => "<p id=\"title\">~VALUE0~</p>",
  "FUNCTION" => false,
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 0
),
"IMG" => array(
  "NAME" => "Bild",
  "CODE" => "[IMG]bild.jpg;Alternativ-Text;Style-Angaben[/IMG]",
  "TEMPLATE" => "<img src=\"~VALUE0~\" border=\"0\" alt=\"~VALUE1~\" style=\"border:1px solid #000:semi: margin:0px:semi: margin-top:5px:semi: margin-bottom:5px:semi: ~VALUE2~\">",
  "FUNCTION" => false,
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 0
),
"LINK" => array(
  "NAME" => "Link",
  "CODE" => "[LINK]http://www.abc.xyz;Anklicktext[/LINK]",
  "TEMPLATE" => "<a href=\"~VALUE0~\" target=\"_blank\">~VALUE1~</a>",
  "FUNCTION" => false,
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 1
),
"TEXT" => array(
  "NAME" => "Text",
  "CODE" => "[TEXT]Text[/TEXT]",
  "TEMPLATE" => "<p class=\"text\" id=\"justify\">~VALUE0~</p>",
  "FUNCTION" => false,
  "VALUE_REPLACED_BY_SELECTED_TEXT" => 0
)

*/
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
"<select id=\"version\" name=\"f_version_r\" onchange=\"javascript:checkDetail('~ID~',true);\" />
~VERSIONS~
</select>
<input id=\"detail\" type=\"text\" name=\"f_detail\" value=\"~DETAIL~\" onblur=\"submit();\" />"
);

define("_TEMPLATE_VERSION",
"<option value=\"~RID~\" ~PRESELECT~>~NAME~</option>" . CRLF
);

define("_TEMPLATE_VERSIONS_ORDER",
"~NAME~&nbsp;~DETAIL~"
);

define("_TEMPLATE_AVAILABILITY",
"~STRING~"
);
define("_TEMPLATE_BILL_MYSHOP_ACCOUNT",
"<tr><td style=\"padding-left:5px;\"><a href=\"./viewer.php?file=~ENCRYPTED_DOCUMENT~\" target=\"_blank\">~RECHNUNGSNUMMER~</a></td><td style=\"text-align:right;\">~NUMBER~</td><td style=\"text-align:right;\">~TOPAY~</td><td style=\"text-align:right;\">~DATE~</td><td style=\"text-align:right; padding-right:5px;\">~TIME~</td></tr>" . CRLF
);

/**
 * define("_TEMPLATE_BILL_MYSHOP_ACCOUNT_OPTION_HTML",
 * "<a href=\"./viewer.php?file=~OPTION_ENCRYPTED_DOCUMENT~\" target=\"_blank\">~NUMBER~</a>"
 * );

 */
 define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW",
"~OPTION_STRING~"
);

//TS 04-01-2012: type = -1: Rechnung wird der Lieferung beigelegt
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_NOT_DEFINED",
"");

//TS 04-01-2012: type = 0: Rechnung wird der Lieferung beigelegt
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_WITH_SHIPPING",
"<p class=\"subtitle\">" . WORD_BILL_DELIVERY . "</p><p>" . SENTENCE_BILL_WILL_BE_DELIVERED_WITH_SHIPPING . "</p><hr />"
);

//TS 04-01-2012: type = 1: Rechnung soll separat verschickt werden
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_SEND_SEPARATELY",
"<p class=\"subtitle\">" . WORD_BILL_DELIVERY . "</p><p>" . SENTENCE_BILL_WILL_BE_SENT_SEPARATELY . "</p><hr />"
);

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

define("_TEMPLATE_COUNTRIES_SIGNON",
"<select id=\"country\" name=\"f_country_r\">" . CRLF .
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

define("_TEMPLATE_MAILINGS",
"<div class=\"myshop\">" . CRLF . 
"<form action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"~ITEMS~" . CRLF .
"<input type=\"hidden\" name=\"action\" value=\"set_mailings\" />" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .  
"<input type=\"submit\" class=\"button\" value=\"" . WORD_SAVE . "\" />" . CRLF .
"</form>" . CRLF . 
"</div>"
);

define("_TEMPLATE_MAILING",
"<div><input type=\"checkbox\" class=\"check\" id=\"chkbox~RID~\" name=\"f_mailings[]\" value=\"~RID~\" ~CHECKED~ />&nbsp;<label for=\"chkbox~RID~\">~NAME~</label></div>" . CRLF
);

define("_TEMPLATE_ACCOUNT_MYSHOP_ACCOUNT",
"<span style=\"color:#0C0;\">~POSITIVE~</span><span style=\"color:#C00;\">~NEGATIVE~</span>~BALANCED~~STRING~"
);
define("_TEMPLATE_ADDRESS_SIGNON",
"<table class=\"form\" cellspacing=\"0\">
  <tr>
    <td id=\"first_col\">~OPTION_NAME~</td>
    <td>~OPTION_STREET~</td>
  </tr>
  <tr>
    <td id=\"first_col\">~OPTION_ZIP~</td>
    <td>~OPTION_CITY~</td>
  </tr>
</table>" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_STREET",
"<p class=\"fieldtitle\">" . WORD_STREET . "</p><input type=\"text\" name=\"f_street\"  maxlength=\"50\" value=\"~STREET~\" />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_ZIP",
"<p class=\"fieldtitle\">" . WORD_ZIP_CODE . "</p><input type=\"text\" name=\"f_zip_code\" maxlength=\"10\" value=\"~ZIP~\" />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_CITY",
"<p class=\"fieldtitle\">" . WORD_CITY . "</p><input type=\"text\" name=\"f_city\" maxlength=\"50\" value=\"~CITY~\" />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_STATE",
"" . WORD_STATE . "<br />" . CRLF .
"<input type=\"text\" name=\"f_state\" maxlength=\"5\" size=\"5\" value=\"~STATE~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_OPTION_NAME",
"<p class=\"fieldtitle\">" . WORD_COMPANY . "/" . WORD_CLUB . "&nbsp;*</p><input type=\"text\" name=\"f_name\" maxlength=\"50\" value=\"~NAME1~\" />" . CRLF
);

define("_TEMPLATE_ADDRESS_SIGNON_VALIDATE",
"~NAME1~<br />~STREET~<br />" . CRLF . "~OPTION_ORT_FORMAT~" . CRLF
);


define("_TEMPLATE_ADDRESS_MYSHOP",
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF . 
"~OPTION_STREET~" . CRLF . "~OPTION_ORT_FORMAT~<br />" . CRLF . "~OPTION_NAME~" . CRLF . 
"<input type=\"hidden\" name=\"action\" value=\"set_user_address\" />" . CRLF .
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\"/>" . CRLF .
"<input type=\"submit\" class=\"button\" value=\"" . WORD_SAVE . "\" />" . CRLF . 
"</form>" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_STREET",
"<p class=\"fieldtitle\">" . WORD_STREET . "</p>" . CRLF .
"<input type=\"text\" name=\"f_street\" maxlength=\"50\" size=\"35\" value=\"~STREET~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_ZIP",
"<p class=\"fieldtitle\">" . WORD_ZIP_CODE . "</p>" . CRLF .
"<input type=\"text\" name=\"f_zip_code\" maxlength=\"10\" size=\"5\" value=\"~ZIP~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_CITY",
"<p class=\"fieldtitle\">" . WORD_CITY  . "</p>" . CRLF .
"<input type=\"text\" name=\"f_city\" maxlength=\"50\" size=\"25\" value=\"~CITY~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_STATE",
"<p class=\"fieldtitle\">" . WORD_STATE . "</p>" . CRLF .
"<input type=\"text\" name=\"f_state\" maxlength=\"5\" size=\"5\" value=\"~STATE~\" /><br />" . CRLF
);

define("_TEMPLATE_ADDRESS_MYSHOP_OPTION_NAME",
"<p class=\"fieldtitle\">" .SENTENCE_CLUB_NAME . " / " . SENTENCE_COMPANY_NAME . "*</p>" . CRLF .
"<input type=\"text\" name=\"f_name\" maxlength=\"50\" size=\"30\" value=\"~NAME1~\" /><br />" . CRLF
);

// ARTIKEL-TEMPLATE FÜR DIE SUCHTREFFER
define("_TEMPLATE_ARTICLE_SEARCH",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"<div class=\"left\"><a name=\"~NUMERO~\" href=\"~LINK~\">~TITEL~</a>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"<div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"search_body_left\"><p><b>" .
WORD_COMPOSER . ":</b>&nbsp;~COMPOSER_LINK~</p><p><b>" .
WORD_ARRANGER . ":</b>&nbsp;~ARRANGER_LINK~</p><p><b>" .
WORD_DURATION . ":</b>&nbsp;~DAUER~</p></div>" . CRLF .
"<div class=\"search_body_middle\"><p><b>" .
WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p><p><b>" .
WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p><p><b>" .
WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p></div>" . CRLF .
"<div class=\"search_body_right\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"article_options\">~OPTION_DETAILS~~OPTION_MINISCORE~~OPTION_PLAY~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~~OPTION_WISHLIST~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF . 
"</div><div class=\"clear\"></div>" . CRLF
);

// TEMPLATE FÜR OPTION INFO IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS",
"<a href=\"~LINK~\">" . WORD_DETAILS . image_tag(__TEMPLATE_IMAGES_PATH."option_details.png",WORD_DETAILS) . "</a>"
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_CART",
"<a href=\"" . __INDEX . "?site=~SITE~&action=add_to_cart&aid=~AID~&id=~RID~#~NUMERO~\">" . nbsp(SENTENCE_INTO_CART) . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_cart.png",SENTENCE_ADD_TO_CART) . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO",
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . WORD_DEMOS . image_tag(__TEMPLATE_IMAGES_PATH."option_demo.png",WORD_DEMO) . "</a>"
);

// TEMPLATE FÜR OPTION PLAY IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_PLAY",
"<a href=\"javascript:PlayTitle_~NUMERO~()\">" . WORD_PLAY . image_tag(__TEMPLATE_IMAGES_PATH . "option_play.png", WORD_PLAY) . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&aid=~AID~&id=~RID~#~NUMERO~\">" . WORD_MINISCORE . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore.png",SENTENCE_SEND_MINISCORE) . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . WORD_RECORDS . image_tag(__TEMPLATE_IMAGES_PATH."option_record.png",SENTENCE_SEARCH_RECORDS) . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_MP3",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&aid=~AID~&vid=~VERSION_MP3~&id=~RID~#~NUMERO~\">" . nbsp(SENTENCE_BUY_MP3_DOWNLOAD) . image_tag(__TEMPLATE_IMAGES_PATH."option_buy_mp3.png",SENTENCE_BUY_MP3_DOWNLOAD) . "</a>"
);

// TEMPLATE FÜR OPTION MERKLISTE IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_WISHLIST",
"<a href=\"" . __INDEX . "?site=~SITE~&action=add_to_wishlist&aid=~AID~&id=~RID~#~NUMERO~\">" . nbsp(SENTENCE_INTO_WISHLIST) . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_wishlist.png",SENTENCE_ADD_TO_WISHLIST) . "</a>"
);


// ARTIKEL-TEMPLATE FÜR DIE ARTIKEL-EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><p>~TITEL~</p>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"  <p><b>" . WORD_COMPOSER . ":</b>&nbsp;~COMPOSER_LINK~</p>" . CRLF .
"  <p><b>" . WORD_ARRANGER . ":</b>&nbsp;~ARRANGER_LINK~</p>" . CRLF .
"  <p><b>" . WORD_DURATION . ":</b>&nbsp;~DAUER~</p><hr>" . CRLF .
"  <p><b>" . WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p>" . CRLF .
"  <p><b>" . WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p>" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p><hr>" . CRLF .
"  <p>~BEM~</p><!--~PUBLISHER~--><hr>" . CRLF .
"  <p>~MEMBERS~</p>~YOUTUBE_FRAME~<hr>" . CRLF .
"  <p id=\"article_options\">~OPTION_MINISCORE~~OPTION_PLAY~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~~OPTION_WISHLIST~</p>" . CRLF .
"  ~PARTS_LIST~" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_CART",
_TEMPLATE_ARTICLE_SEARCH_OPTION_CART
);

// TEMPLATE FÜR OPTION DEMO IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_DEMO",
_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO
);

// TEMPLATE FÜR OPTION PLAY IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_PLAY",
_TEMPLATE_ARTICLE_SEARCH_OPTION_PLAY
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
_TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_MP3",
_TEMPLATE_ARTICLE_SEARCH_OPTION_MP3
);

//TEMPLTATE FÜR OPTION DOWNLOADBARE STIMMEN
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_PARTS_ITEM",
"<a href=\"" . __INDEX . "?site=article&action=download_part&part=~PART_KIND~&nr=~NUMERO~&id=~RID~\">~PART_NAME~</a>"
);

// TEMPLATE FÜR OPTION MERKLISTE IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_WISHLIST",
_TEMPLATE_ARTICLE_SEARCH_OPTION_WISHLIST
);

// ARTIKEL-TEMPLATE FÜR DEN EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART",
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><p>~POSITION~.</p>&nbsp;~OPTION_DETAILS~&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>Stück:&nbsp;~QUANTITY~x</b>&nbsp;&nbsp;<b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"<form id=\"~UID~\" action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"  <input type=\"hidden\" name=\"site\" value=\"cart\" />" . CRLF .
"  <input type=\"hidden\" name=\"action\" value=\"update_cart\" />" . CRLF .
"  <input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"uid\" value=\"~UID~\" />" . CRLF .
"  <!-- <p class=\"hint\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~ --><!-- &nbsp;|&nbsp;~PUBLISHER~ --><!-- </p> -->" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p>" . CRLF .
"  <p id=\"article_options\">" . SENTENCE_CHANGE_QUANTITY . CRLF .
"    <input id=\"quantity\" type=\"text\" class=\"minimal\" name=\"f_quantity\" value=\"~QUANTITY~\" size=\"1\" maxlength=\"2\" style=\"vertical-align:baseline; text-align:center; margin-bottom:5px;\" onblur=\"submit();\" />~OPTION_REFRESH~" . CRLF .
"    ~OPTION_DELETE~" . CRLF .
"  </p>" . CRLF .
"  <p>~OPTION_VERSION~&nbsp;~OPTION_COPY~</p>" . CRLF .
"</form>" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<script type=\"text/javascript\"> checkDetail('~UID~'); </script>" . CRLF
);

// TEMPLATE FÜR OPTION DETAILS ANZEIGEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DETAILS",
"<a href=\"~LINK~\">~TITEL~</a>"
);

// TEMPLATE FÜR OPTION AKTUALISIEREN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_REFRESH",
"<input type=\"image\" class=\"imageasbutton\" src=\"" . __TEMPLATE_IMAGES_PATH . "option_refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:middle; height:auto; margin-right:10px; background:none;\">"
);

// TEMPLATE FÜR OPTION LÖSCHEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DELETE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=delete_from_cart&aid=~AID~&uid=~UID~\">" . SENTENCE_DELETE_FROM_CART . image_tag(__TEMPLATE_IMAGES_PATH."option_delete.png",SENTENCE_DELETE_FROM_CART,"vertical-align:middle; margin-right:10px;") . "</a>"
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
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&id=~RID~&vid=~VERSION_R~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_copy.png",SENTENCE_COPY_ARTICLE_VERSION,"vertical-align:middle; margin-right:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

// TEMPLATE FÜR OPTION AUSGABEART IM EINKAUFSWAGEN - AUSGABEART ÖFFENTLICH
define("_TEMPLATE_ARTICLE_CART_OPTION_VERSION_PUBLIC",
"~VERSION~"
);

// TEMPLATE FÜR OPTION AUSGABEART IM EINKAUFSWAGEN - AUSGABEART NICHT ÖFFENTLICH / NICHT VERÄNDERBAR
define("_TEMPLATE_ARTICLE_CART_OPTION_VERSION_NOT_PUBLIC",
"<b>~VERSION~</b>" . CRLF . "<input type=\"hidden\" name=\"f_version_r\" value=\"~VERSION_R~\">" . CRLF
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



// TEMPLATE FÜR EMAIL MELDUNG BROKEN LINK
define("_TEMPLATE_ARTICLE_BROKEN_LINK_EMAIL",
SYS_WORD_ARTICLE_ID . ": ~RID_INT~" . CRLF . WORD_TITLE . ": ~TITEL~"
);


// ARTIKEL-TEMPLATE FÜR DEN NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"<div class=\"left\"><a name=\"~RID~\" href=\"" . __INDEX_EXT . "?site=article&id=~RID~\">~TITEL~</a>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"<div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"search_body_left\"><p><b>" .
WORD_COMPOSER . ":</b>&nbsp;~COMPOSER~</p><p><b>" .
WORD_ARRANGER . ":</b>&nbsp;~ARRANGER~</p><p><b>" .
WORD_DURATION . ":</b>&nbsp;~DAUER~</p></div>" . CRLF .
"<div class=\"search_body_middle\"><p><b>" .
WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p><p><b>" .
WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p><p><b>" .
WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p></div>" . CRLF .
"<div class=\"search_body_right\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"article_options\">~OPTION_DETAILS~~OPTION_MINISCORE~~OPTION_PLAY~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF . 
"</div><div class=\"clear\"></div>" . CRLF
);

// ARTIKEL-DETAIL-TEMPLATE FÜR DEN NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_DETAIL",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><p>~TITEL~</p>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"  <p><b>" . WORD_COMPOSER . ":</b>&nbsp;~COMPOSER_LINK~</p>" . CRLF .
"  <p><b>" . WORD_ARRANGER . ":</b>&nbsp;~ARRANGER_LINK~</p>" . CRLF .
"  <p><b>" . WORD_DURATION . ":</b>&nbsp;~DAUER~</p><hr>" . CRLF .
"  <p><b>" . WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p>" . CRLF .
"  <p><b>" . WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p>" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p><hr>" . CRLF .
"  <p>~BEM~</p><!--~PUBLISHER~--><hr>" . CRLF .
"  <p>~MEMBERS~</p><p>~YOUTUBE_LINK~</p><hr>" . CRLF .
"  <p id=\"article_options\">~OPTION_MINISCORE~~OPTION_PLAY~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~</p>" . CRLF .
"  ~PARTS_LIST~" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF
);

// TEMPLATE FÜR OPTION INFO IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DETAILS",
"<a href=\"" . __INDEX_EXT . "?site=article&id=~RID~\">" . WORD_DETAILS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_details.png\" alt=\"" . WORD_DETAILS . "\" /></a>"
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_CART",
"<a href=\"" . __INDEX_EXT . "?site=cart&action=add_to_cart&id=~RID~\">" . nbsp(SENTENCE_INTO_CART) . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_add_to_cart.png\" alt=\"" . SENTENCE_ADD_TO_CART . "\" /></a>"
);

// TEMPLATE FÜR OPTION PLAY IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_PLAY",
"<a href=\"" . __INDEX_EXT . "?site=article&action=play&id=~RID~\">" . WORD_PLAY . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_play.png\" alt=\"" . WORD_PLAY . "\" /></a>"
);

// TEMPLATE FÜR OPTION DEMO IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DEMO",
"<a href=\"" . __INDEX_EXT . "?site=demo&id=~RID~\">" . WORD_DEMOS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_demo.png\" alt=\"" . WORD_DEMO . "\" /></a>"
);

// TEMPLATE FÜR OPTION MINISCORE IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MINISCORE",
"<a href=\"" . __INDEX_EXT . "?action=miniscore&id=~RID~\">" . WORD_MINISCORE . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_miniscore.png\" alt=\"" . SENTENCE_SEND_MINISCORE . "\" /></a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_RECORDS",
"<a href=\"" . __INDEX_EXT . "?site=search&action=search_records&id=~RID~\">" . WORD_RECORDS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_record.png\" alt=\"" . SENTENCE_SEARCH_RECORDS . "\" /></a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MP3",
"<a href=\"" . __INDEX_EXT . "?site=cart&action=add_to_cart&vid=~VERSION_MP3~&id=~RID~\">" . nbsp(SENTENCE_BUY_MP3_DOWNLOAD) . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_buy_mp3.png\" alt=\"" . SENTENCE_BUY_MP3_DOWNLOAD. "\" /></a>"
);


define("_TEMPLATE_ARTICLE_MYSHOP_MYMUSIC",
"<!--<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~NUMERO~</td>-->" . CRLF . 
"<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\"><a href=\"" . __INDEX . "?site=article&id=~ARTIKEL_R~\">~TITEL~</a></td>" . CRLF . 
"<td style=\"text-align:center;  padding-left:20px; padding-right:20px; border-bottom:1px dashed #DDDDDD;\">~MP3_FILE_SIZE~ MB</td>" . CRLF
);


// ARTIKEL-TEMPLATE FÜR DIE MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST",
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\">~OPTION_DETAILS~&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"<form id=\"~UID~\" action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"  <input type=\"hidden\" name=\"site\" value=\"myshop\" />" . CRLF .
"  <input type=\"hidden\" name=\"subsite\" value=\"wishlists\" />" . CRLF .
"  <input type=\"hidden\" name=\"action\" value=\"update_wishlist\" />" . CRLF .
"  <input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"uid\" value=\"~UID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"id\" value=\"~WID~\" />" . CRLF .
"  <!-- <p class=\"hint\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~ --><!-- &nbsp;|&nbsp;~PUBLISHER~ --><!-- </p> -->" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p>" . CRLF .
"  <br>" . CRLF .
"  <p id=\"article_options\">" .
"    ~OPTION_DELETE~" . CRLF .
"    ~OPTION_MOVE_TO_CART~" . CRLF .
"  </p>" . CRLF .
"</form>" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~<br><br></div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<script type=\"text/javascript\"> checkDetail('~UID~'); </script>" . CRLF
);

// TEMPLATE FÜR OPTION DETAILS ANZEIGEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DETAILS",
"<a href=\"" . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>"
);

// TEMPLATE FÜR OPTION AKTUALISIEREN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_REFRESH",
"<input type=\"image\" class=\"imageasbutton\" src=\"" . __TEMPLATE_IMAGES_PATH . "option_refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:middle; height:auto; margin-right:10px; background:none;\">"
);

// TEMPLATE FÜR OPTION LÖSCHEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DELETE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=delete_from_wishlist&aid=~AID~&uid=~UID~&wid=~WID~\">" . SENTENCE_DELETE_FROM_CART . image_tag(__TEMPLATE_IMAGES_PATH."option_delete.png",SENTENCE_DELETE_FROM_CART,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DEMO",
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_demo_blue.png",WORD_DEMO,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore_blue.png",SENTENCE_SEND_MINISCORE,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_record_blue.png",SENTENCE_SEARCH_RECORDS,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION KOPIEREN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_COPY",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&id=~RID~&vid=~VERSION_R~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_copy.png",SENTENCE_COPY_ARTICLE_VERSION,"vertical-align:middle; margin-right:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

// TEMPLATE FÜR OPTION AUSGABEART IN DER MERKLISTE - AUSGABEART ÖFFENTLICH
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_VERSION_PUBLIC",
"~VERSION~"
);

// TEMPLATE FÜR OPTION AUSGABEART IN DER MERKLISTE - AUSGABEART NICHT ÖFFENTLICH / NICHT VERÄNDERBAR
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_VERSION_NOT_PUBLIC",
"<b>~VERSION~</b>" . CRLF . "<input type=\"hidden\" name=\"f_version_r\" value=\"~VERSION_R~\">" . CRLF
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_MOVE_TO_CART",
"<a href=\"" . __INDEX . "?site=~SITE~&action=move_to_cart&aid=~AID~&wid=~WID~&uid=~UID~\">" . nbsp(SENTENCE_INTO_CART) . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_cart.png",SENTENCE_ADD_TO_CART) . "</a>"
);

// TEMPLATE FÜR YOUTUBE FRAME
define("_TEMPLATE_ARTICLE_YOUTUBE_FRAME",
    "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/~YOUTUBEID~\" frameborder=\"0\" allowfullscreen></iframe>"
);

// TEMPLATE FÜR YOUTUBE LINK
define("_TEMPLATE_ARTICLE_YOUTUBE_LINK",
    "<a href=\"https://www.youtube.com/watch?v=~YOUTUBEID~\">https://www.youtube.com/watch?v=~YOUTUBEID~</a>"
);

?>
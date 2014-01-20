<?php

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
"<div style=\"width:630px; padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
WORD_CUSTOMER_NO . ": <b>~NUMMER~</b><br />" . CRLF .
WORD_NAME . ": <b>~VORNAME~&nbsp;~NACHNAME~</b></div><br /><br />" . CRLF .
"<b>" . WORD_ADDRESS . "</b><br />" . CRLF .
"<div style=\"width:630px; padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
"~ADDRESS~</div><br /><br />" . CRLF .
"<!-- ~EMAIL~<br /> -->" . CRLF .
"<b>" . WORD_EMAIL . "</b><br />" . CRLF . 
"<div style=\"width:630px; padding:5px; border:1px dashed #AAAAAA;\">" . CRLF .
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
"<div style=\"width:630px; padding:5px; border:1px dashed #AAAAAA; margin-top:15px;\">" . CRLF .
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

?>
<?php

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

?>
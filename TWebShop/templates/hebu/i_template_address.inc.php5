<?php

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


?>
<?php

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


?>
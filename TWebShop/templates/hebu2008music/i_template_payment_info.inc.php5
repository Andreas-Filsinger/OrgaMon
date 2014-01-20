<?php

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW",
"<p>
<input type=\"radio\" class=\"radio\" id=\"pradio_~TYPE~_~RID~\" name=\"f_payment\" value=\"~RID~\" ~OPTION_CHECKED~ />
<label for=\"pradio_~TYPE~_~RID~\"><b>" . SENTENCE_NEW_BANKINFO . ":</b></label>
<input type=\"hidden\" name=\"type\" value=\"~TYPE~\">
</p>" . CRLF .
"<div style=\"margin-left:35px; margin-bottom:20px;\">" . CRLF . 
"~OPTION_DEPOSITOR~" . CRLF . 
"~OPTION_BAN~" . CRLF . 
"~OPTION_BANK~" . CRLF . 
"~OPTION_BIC~" . CRLF . 
"</div>" . CRLF
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_PREVIOUS",
"<p>
<input type=\"radio\" class=\"radio\" id=\"pradio_~TYPE~_~RID~\" name=\"f_payment\" value=\"~RID~\" ~OPTION_CHECKED~ />
<label for=\"pradio_~TYPE~_~RID~\"><b>~DEPOSITOR~, ~BAN_MASKED~, ~BANK~, ~BIC~</b></label>
<input type=\"hidden\" name=\"type\" value=\"~TYPE~\">
</p>" . CRLF 
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_DEPOSITOR",
"<p class=\"fieldtitle\">" . WORD_DEPOSITOR . "</p><input type=\"text\" class=\"short\" name=\"f_depositor\" value=\"~DEPOSITOR~\" size=\"50\" maxlength=\"50\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BAN",
"<p class=\"fieldtitle\">" . WORD_BANK_ACCOUNT_NUMBER . "</p><input type=\"text\" class=\"short\" name=\"f_ban\" value=\"~BAN~\" size=\"10\" maxlength=\"10\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BANK",
"<p class=\"fieldtitle\">" . WORD_BANK . "</p><input type=\"text\" class=\"short\" name=\"f_bank\" value=\"~BANK~\" size=\"50\" maxlength=\"100\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_PAYMENT_NEW_OPTION_BIC",
"<p class=\"fieldtitle\">" . WORD_BANK_IDENTIFICATION_CODE . "</p><input type=\"text\" class=\"short\" name=\"f_bic\" value=\"~BIC~\" size=\"10\" maxlength=\"10\" onfocus=\"checkRadioButtonById('pradio_~TYPE~_~RID~')\" />"
);

define("_TEMPLATE_PAYMENT_INFO_ORDER_OVERVIEW",
"<p class=\"subtitle\">" . WORD_BANKINFO . "</p>
<p>~DEPOSITOR~</p>
<p>~BAN_MASKED~</p>
<p>~BANK~</p>
<p>~BIC~</p>
<hr />"
);

?>
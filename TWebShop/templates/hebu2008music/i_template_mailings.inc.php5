<?php

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

?>
<?php

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

?>

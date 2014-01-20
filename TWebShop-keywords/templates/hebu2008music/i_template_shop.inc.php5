<?php

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

?>

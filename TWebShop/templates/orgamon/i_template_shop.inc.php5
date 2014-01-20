<?php

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

define("_TEMPLATE_OPTION_NEWSLETTER",
""
);

?>
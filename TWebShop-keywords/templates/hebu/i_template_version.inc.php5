<?php

define("_TEMPLATE_VERSIONS",
"<select id=\"version\" class=\"select01\" name=\"f_version_r\" onchange=\"javascript:checkDetail('~ID~',true);\">
~VERSIONS~
</select>
<input id=\"detail\" class=\"char05\" type=\"text\" name=\"f_detail\" value=\"~DETAIL~\" onblur=\"submit();\">"
);

define("_TEMPLATE_VERSION",
"<option value=\"~RID~\" ~PRESELECT~>~NAME~</option>" . CRLF
);

define("_TEMPLATE_VERSIONS_ORDER",
"~NAME~&nbsp;~DETAIL~"
);

?>

<?php

define("_TEMPLATE_VERSIONS",
"<select id=\"version\" name=\"f_version_r\" onchange=\"javascript:checkDetail('~ID~',true);\" />
~VERSIONS~
</select>
<input id=\"detail\" type=\"text\" name=\"f_detail\" value=\"~DETAIL~\" onblur=\"submit();\" />"
);

define("_TEMPLATE_VERSION",
"<option value=\"~RID~\" ~PRESELECT~>~NAME~</option>" . CRLF
);

define("_TEMPLATE_VERSIONS_ORDER",
"~NAME~&nbsp;~DETAIL~"
);

?>
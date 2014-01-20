<?php

define("_TEMPLATE_COUNTRIES_SIGNON",
"<select id=\"country\" name=\"f_country_r\">" . CRLF .
"~LIST~" . CRLF .
"</select>" . CRLF
);

define("_TEMPLATE_COUNTRY_SIGNON",
"~OPTION_SELECT~" . CRLF
);

define("_TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_UNSELECTED",
"<option value=\"~RID~\">~NAME~</option>"
);

define("_TEMPLATE_COUNTRY_SIGNON_OPTION_SELECT_SELECTED",
"<option value=\"~RID~\" selected>~NAME~</option>"
);

?>

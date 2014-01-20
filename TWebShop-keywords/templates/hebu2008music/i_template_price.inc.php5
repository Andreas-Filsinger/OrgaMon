<?php

define("_TEMPLATE_PRICE_SEARCH",
"<b>~STRING~~SUM_NETTO~</b>"
);

define("_TEMPLATE_PRICE_SEARCH_DISCOUNT",
"<b>~STRING~~SUM_BRUTTO~</b> <span class=\"grey\">(~SUM_NETTO~ - ~PERCENT~)</span>"
);

define("__TEMPLATE_PRICE_CART",
"~STRING~<b>~SUM_NETTO~</b><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART",
"~STRING~<b>~FLAT_NETTO~</b>"
);

define("_TEMPLATE_PRICE_CART_DISCOUNT",
"~STRING~<b>~SUM_BRUTTO~</b><br /><span class=\"smallred\">~PERCENT~</span><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DELIVERY",
"~STRING~<b>~SUM_NETTO~</b><!-- ~VALUE~ -->"
);

define("_TEMPLATE_PRICE_ARTICLE",
"<b>~FLAT_NETTO~~STRING~</b>"
);

define("_TEMPLATE_PRICE_ARTICLE_DISCOUNT",
"<p><b>~SUM_BRUTTO~~STRING~</b></p><p><span class=\"hint\">~PERCENT~<br />~SUM_NETTO~</span></p>"
);

define("_TEMPLATE_PRICE_ORDER",
"~STRING~~SUM_BRUTTO~"
);

define("_TEMPLATE_PRICE_ORDER_DELIVERY",
"~STRING~~SUM_NETTO~"
);

?>

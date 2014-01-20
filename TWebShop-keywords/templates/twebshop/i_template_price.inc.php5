<?php

define("_TEMPLATE_PRICE_SEARCH",
"<b>~STRING~~SUM_NETTO~</b>"
);

define("_TEMPLATE_PRICE_SEARCH_DISCOUNT",
"<b>~STRING~~SUM_BRUTTO~</b> <span class=\"grey\">(~SUM_NETTO~ - ~PERCENT~)</span>"
);

define("_TEMPLATE_PRICE_CART",
"~STRING~<b>~SUM_NETTO~</b><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DISCOUNT",
"~STRING~<b>~SUM_BRUTTO~</b><br /><span class=\"smallred\">~PERCENT~</span><br /><span class=\"smallgrey\">~QUANTITY~x&nbsp;~FLAT_NETTO~</span>"
);

define("_TEMPLATE_PRICE_CART_DELIVERY",
"~STRING~<b>~SUM_NETTO~</b>"
);

define("_TEMPLATE_PRICE_ARTICLE",
"<span style=\"font-size:22px;\"><b>~FLAT_NETTO~~STRING~</b></span>"
);

define("_TEMPLATE_PRICE_ARTICLE_DISCOUNT",
"<span style=\"font-size:22px;\"><b>~SUM_BRUTTO~~STRING~</b></span><br /><span class=\"smallgrey\">~PERCENT~<br />~SUM_NETTO~</span>"
);

define("_TEMPLATE_PRICE_ORDER",
"~STRING~~SUM_BRUTTO~"
);

define("_TEMPLATE_PRICE_ORDER_DELIVERY",
"~STRING~~SUM_NETTO~"
);

?>

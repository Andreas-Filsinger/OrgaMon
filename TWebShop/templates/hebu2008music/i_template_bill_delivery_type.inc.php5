<?php

define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW",
"~OPTION_STRING~"
);

//TS 04-01-2012: type = -1: Rechnung wird der Lieferung beigelegt
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_NOT_DEFINED",
"");

//TS 04-01-2012: type = 0: Rechnung wird der Lieferung beigelegt
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_WITH_SHIPPING",
"<p class=\"subtitle\">" . WORD_BILL_DELIVERY . "</p><p>" . SENTENCE_BILL_WILL_BE_DELIVERED_WITH_SHIPPING . "</p><hr />"
);

//TS 04-01-2012: type = 1: Rechnung soll separat verschickt werden
define("_TEMPLATE_BILL_DELIVERY_TYPE_ORDER_OVERVIEW_OPTION_STRING_TYPE_SEND_SEPARATELY",
"<p class=\"subtitle\">" . WORD_BILL_DELIVERY . "</p><p>" . SENTENCE_BILL_WILL_BE_SENT_SEPARATELY . "</p><hr />"
);

?>
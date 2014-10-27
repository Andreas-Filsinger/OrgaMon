<?php

define("_TEMPLATE_TREE_NODE_INDENT",
image_tag(__TEMPLATE_IMAGES_PATH."tree_space.png","","text-align:center; vertical-align:middle;") . "&nbsp;"
);

define("_TEMPLATE_TREE_NODE_OPEN",
"<a href=\"" . __INDEX . "?action=open_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_plus.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_CLOSE",
"<a href=\"" . __INDEX . "?action=close_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_minus.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_EMPTY", 
image_tag(__TEMPLATE_IMAGES_PATH."tree_empty.png","","text-align:center; vertical-align:middle;")
);

define("_TEMPLATE_TREE_NODE_SELECT",
"<a href=\"" . __INDEX . "?action=select_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_unselected.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_UNSELECT",
"<a href=\"" . __INDEX . "?action=unselect_node&id=~CODE~\">" .
image_tag(__TEMPLATE_IMAGES_PATH."tree_selected.png","","text-align:center; vertical-align:middle;") . "</a>"
);

define("_TEMPLATE_TREE_NODE_NAME",
"<a name=\"~CODE~\" href=\"" . __INDEX . "?action=search_tree_node&site=search&sid=~NEXT_SID~&id=~CODE~\" style=\"vertical-align:middle;\">~NAME~</a>"
);

?>
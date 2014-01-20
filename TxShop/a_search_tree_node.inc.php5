<?php
// FLAGS
// $flag_search_input = false;        // ob die Such-Eingabezeile angezeigt wird.
// $flag_categories = false;          // ob Sortimente relevant sind
// $flag_output_selectable = false;   // ob Ausgabeart wählbar ist
// $flag_show_attention = false;      // ob TrefferHinweise angezeigt werden
// $flag_quantity = false;            // ob die Spalte "Menge" angezeigt wird
// $flag_options = false;             // ob Optionen angeboten/angezeigt werden
// $flag_user_exists = false;         // ob der User relevant ist

$_SESSION["s_search_tree_node_id"] = $id;

$id = $tree->getNodeId($id);
$search->searchTreeNode($id);
$messagelist->add($search->hits . " " . WORD_HITS);

?>
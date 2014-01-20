<?php

// erste Änderungen 20.07. :  * twebshop_article_tree::create() liefert jetzt ein Objekt eingenen Typs
//                            * __invoke gibt den tree zurück!
// bisher:
// AF: twebshop_article_tree::create() lieferte ein Objekt vom Typ "twebshop_tree"
    //     Erzeugung+Speicherung in die Session will ich erst dann machen, wenn 
    //     die entsprechende Seite das $tree Objekt WIRKLICH benötigt, dann soll die
    // Erzeugung erst anspringen



// AF: eigentlich müsste die Struktur so sein:
//
// class node { }
//   hier sind unimplementierte functionen für das Ausbelichten eines node usw.
// class tree extends node { }
//   hier sind unimplementierte functionen für das Ermitteln der Grunddaten
// class article_tree extends tree { }
//   hier sind die Implementierungen für ibase-Daten holen und Anzeigen einer Node...
// 



//**** KLASSE ZUR ABBILDUNG DES ARTIKELBAUMES **************************************************************************************************
class twebshop_article_tree {

    var $plain = array();
    var $tree = NULL;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE_TREE";
    
    public function __invoke() {
         
        if ($this->tree==NULL) {
            $this->tree = $this->makeTree();
        }
        return $this->tree;
    }

    private function readFromDataBase() {

        global $ibase;

        $result = $ibase->query("SELECT RID, CODE, BEZEICHNUNG FROM GATTUNG WHERE BEZEICHNUNG <> '' ORDER BY CODE");
        while ($data = $ibase->fetch_object($result)) {
            $this->plain[] = $data->CODE . ";" . $data->BEZEICHNUNG . ";" . $data->RID;
        }
        $ibase->free_result($result);
    }

    private function makeTree($mount = 0, $index = 0) {
        
        // 
        if (count($this->plain) == 0) {
            $this->readFromDataBase();
        }
        $i = $index;
        $tree = new twebshop_tree($mount);
        $break = false;
        do {
            if (count($this->plain) == 0)
                break;
            list($code, $name, $rid) = explode(";", $this->plain[$i]);
            $node = new twebshop_tree_node($rid, $name, $code);
            if ($i == $index) {
                $lastcode = $code;
            }
            switch (true) {
                case(strlen($code) == strlen($lastcode)): {
                        $tree->addNode($node);
                        break;
                    }
                case(strlen($code) > strlen($lastcode)): {
                        $tree->nodes[$lastcode]->addTree($this->makeTree($lastcode, $i, $this->plain));
                        $tree->subnodes += $tree->nodes[$lastcode]->tree->subnodes;
                        $i += $tree->nodes[$lastcode]->tree->subnodes - 1;
                        $code = $lastcode;
                        break;
                    }
                case(strlen($code) < strlen($lastcode)): {
                        $break = true;
                        break;
                    }
            }
            $lastcode = $code;
            $i++;
            if ($i >= count($this->plain)) {
                $break = true;
            }
        } while (!$break);
        return $tree;
    }

    // AF: wer braucht das?
    public function __toString() {
        return $this->CLASS_NAME;
    }

    static public function getCodeByArticle($article_r) {

        global $ibase;
        $code = $ibase->get_field("SELECT CODE FROM GATTUNG WHERE RID IN (SELECT GATTUNG_R FROM ARTIKEL_GATTUNG WHERE (ARTIKEL_R=$article_r)) ORDER BY CODE DESC", "CODE");
        //var_dump($code);

        return $code;
    }

}

//**** KLASSE ZUR ABBILDUNG EINES BAUMES *******************************************************************************************************
class twebshop_tree {

    public $nodes = array();
    public $codes = array();
    public $mountcode = 0;
    public $subnodes = 0;
    public $selected_nodes = array();

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_TREE";

    //otected $CLASS_NAME = self::CLASS_NAME;

    public function __construct($mountcode = 0, $node = 0) {
        $this->mountcode = $mountcode;
        $this->subnodes = 0;
        $this->codes = array();
        $this->nodes = array();
        if ($node != 0) {
            $this->addNode($node);
        }
    }

    public function addNode($node) {
        $this->nodes[$node->code] = $node;
        $this->subnodes++;
        $this->codes[] = $node->code;
    }

    public function openNode($code) {
        if (array_key_exists($code, $this->nodes)) {
            $this->nodes[$code]->setOpen(true);
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $this->nodes[$key]->tree->openNode($code);
            }
        }
    }

    public function openNodes($codes) {
        foreach ($codes as $code)
            $this->openNode($code);
    }

    public function openAllNodes() {
        foreach ($this->codes as $code) {
            $this->openNode($code);
            if ($this->nodes[$code]->tree != null) {
                $this->nodes[$code]->tree->openAllNodes();
            }
        }
    }

    public function closeNode($code) {
        if (array_key_exists($code, $this->nodes)) {
            $this->nodes[$code]->setOpen(false);
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $this->nodes[$key]->tree->closeNode($code);
            }
        }
    }

    public function selectNode($code) {
        if (array_key_exists($code, $this->nodes)) {
            $this->nodes[$code]->setSelected(true);
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $this->nodes[$key]->tree->selectNode($code);
            }
        }
        $this->selected_nodes[] = $code;
    }

    public function selectNodes($codes) {
        foreach ($codes as $code)
            $this->selectNode($code);
    }

    public function unselectNode($code) {
        if (array_key_exists($code, $this->nodes)) {
            $this->nodes[$code]->setSelected(false);
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $this->nodes[$key]->tree->unselectNode($code);
            }
        }
        $this->selected_nodes = array_diff($this->selected_nodes, array($code));
    }

    public function unselectNodes($codes) {
        foreach ($codes as $code)
            $this->unselectNode($code);
    }

    public function getNodeName($code) {
        $name = "";
        if (array_key_exists($code, $this->nodes)) {
            $name = $this->nodes[$code]->name;
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $name = $this->nodes[$key]->tree->getNodeName($code);
                if ($name != "") {
                    break;
                }
            }
        }
        return $name;
    }

    public function getNodeId($code) {
        $rid = 0;
        if (array_key_exists($code, $this->nodes)) {
            $rid = $this->nodes[$code]->rid;
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $rid = $this->nodes[$key]->tree->getNodeId($code);
                if ($rid != 0) {
                    break;
                }
            }
        }
        return $rid;
    }

    public function getPath($code) {
        $path = "";
        if (array_key_exists($code, $this->nodes)) {
            $path = "/" . $this->nodes[$code]->name;
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $path = $this->nodes[$key]->tree->getPath($code);
                if ($path != "") {
                    $path = "/" . $this->nodes[$key]->name . $path;
                    break;
                }
            }
        }
        return $path;
    }

    public function getLinkedPath($code) {
        $path = "";
        if (array_key_exists($code, $this->nodes)) {
            $path = "/" . $this->nodes[$code]->getNameAsHTML();
        } else {
            foreach ($this->codes as $key) {
                if ($this->nodes[$key]->tree != NULL)
                    $path = $this->nodes[$key]->tree->getLinkedPath($code);
                if ($path != "") {
                    $path = "/" . $this->nodes[$key]->getNameAsHTML() . $path;
                    break;
                }
            }
        }
        return $path;
    }

    public function getCode($rid) {
        $code = false;
        foreach ($this->codes as $key) {
            if ($this->nodes[$key]->rid == $rid) {
                $code = $key;
                break;
            }
            if ($this->nodes[$key]->tree != NULL) {
                $code = $this->nodes[$key]->tree->getCode($rid);
            }
            if ($code != false) {
                break;
            }
        }
        return $code;
    }

    public function getHTML($indent = 0) {
        $html = "";
        foreach ($this->codes as $key) {
            $html.= $this->nodes[$key]->getHTML($indent);
        }
        return $html;
    }

    public function __toString() {
        return $this->CLASS_NAME;
    }

}

//**** KLASSE ZUR ABBILDUNG DER KNOTEN EINES BAUMES *************************************************************************************************
class twebshop_tree_node {

    public $rid;
    public $name;
    public $code;
    public $selected;
    public $open;
    public $highlight;
    public $tree = null;

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_TREE_NODE";

    public function __construct($rid = 0, $name = "", $code = "") { // d_javaalert("construct");
        $this->setValues($rid, $name, $code);
        $this->selected = false;
        $this->open = false;
        $this->highlight = false;
        $this->tree = NULL;
    }

    public function setValues($rid, $name, $code) {
        $this->rid = $rid;
        $this->name = trim($name);
        $this->code = $code;
    }

    public function setOpen($b) {
        $this->open = $b;
        // $this->setHighlight(true);
    }

    public function setSelected($b) {
        $this->selected = $b;
        if ($this->tree != NULL) {
            if ($this->selected == true) {
                $this->tree->selectNodes($this->tree->codes);
            } else {
                $this->tree->unselectNodes($this->tree->codes);
            }
            $this->setOpen(true);
        }
        // $this->setHighlight(true);
    }

    private function setHighlight($b) {
        $this->highlight = $b;
    }

    public function addTree($tree) {
        $this->tree = $tree;
    }

    public function getHTML($indent = 0) {
        $html = $this->indent($indent, _TEMPLATE_TREE_NODE_INDENT);
        if (($this->tree != NULL) AND ($this->open)) {
            $html.= str_replace("~CODE~", $this->code, _TEMPLATE_TREE_NODE_CLOSE);
        }
        if (($this->tree != NULL) AND (!$this->open)) {
            $html.= str_replace("~CODE~", $this->code, _TEMPLATE_TREE_NODE_OPEN);
        }
        if ($this->tree == NULL) {
            $html.= _TEMPLATE_TREE_NODE_EMPTY;
        }
        $html.= "&nbsp;";
        if ($this->selected) {
            $html.= str_replace("~CODE~", $this->code, _TEMPLATE_TREE_NODE_UNSELECT);
        } else {
            $html.= str_replace("~CODE~", $this->code, _TEMPLATE_TREE_NODE_SELECT);
        }
        $html.= "&nbsp;";
        if ($this->highlight OR $this->selected)
            $html.= "<b>";
        $html.= $this->getNameAsHTML();
        if ($this->highlight OR $this->selected)
            $html.= "</b>";
        $html.= BR . CRLF;
        if (($this->tree != NULL) AND ($this->open)) {
            $html.= $this->tree->getHTML($indent + 1);
        }
        $this->highlight = false;
        return $html;
    }

    public function getNameAsHTML() {
        $html = _TEMPLATE_TREE_NODE_NAME;
        $html = str_replace("~RID~", $this->rid, $html);
        $html = str_replace("~CODE~", $this->code, $html);
        $html = str_replace("~NAME~", $this->name, $html);
        $html = str_replace("~NEXT_SID~", toption::$properties["NEXT_SID"], $html);
        return $html;
    }

    public function indent($n, $c = "&nbsp;") {
        $indent = "";
        for ($i = 0; $i < $n; $i++)
            $indent.= $c;
        return $indent;
    }

}
?>

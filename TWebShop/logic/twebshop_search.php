<?php

//**** KLASSE FÜR DIE SUCHE ***************************************************************************************************
class twebshop_search {

    static private $instance = NULL;
    private $has_run = false;
    private $is_cached = false;
    private $has_been_sorted = false;
    private $id = 0;
    private $result = NULL;
    private $article = array();
    private $cache_size = 0;
    private $cache = array();

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_SEARCH";

    static public function create() {
        if (!twebshop_search::$instance) {
            twebshop_search::$instance = new twebshop_search();
        }
        return twebshop_search::$instance;
    }

    public function getID() {
        return $this->id;
    }

    public function getNextID() {
        return $this->id + 1;
    }

    public function getResultID() {
        return ($this->result) ? $this->result->getID() : false;
    }

    public function checkID($id) {
        if ($id < $this->getID() AND $id < $this->getResultID()) {
            $this->loadFromCache($id);
        }
    }

    public function hasRun() {
        return $this->has_run;
    }

    public function isCached() {
        return $this->is_cached;
    }

    public function hasBeenSorted() {
        return $this->has_been_sorted;
    }

    public function doSearch($id, $method, $params) {
        if ($id >= $this->getNextID()) {
            $this->id = $id;
            $this->result = new twebshop_search_result($this->id, $method, $params);
            call_user_func(array(&$this, $method), $params);
            $this->writeToCache($this->result);
            $this->has_run = true;
        } else {
            $this->loadFromCache($id);
        }
        return ($this->result) ? $this->result->getIDs() : array();
    }

    public function searchUserExpression($params) {
        
        
        global $orgamon;
        $this->result->assignIDs((($result = $orgamon->searchArticle($params["expression"], $params["assortment"])) != NULL) ? $result : array());
        
        return $this->result->getIDs();
    }

    public function getUserExpression() {
        return ($this->result) ? $this->result->getUserExpression() : "";
    }

    public function searchUserExpressionExtended($params) {
        $ids = $params["tree_node_ids"];
        $result = array();
        foreach ($ids as $id) {
            $result = array_merge($result, $this->searchTreeNode(array("tree_node_id" => $id)));
        }
        $this->result->assignIDs(array_intersect($this->searchUserExpression($params), $result));
        unset($result);
        return $this->result->getIDs();
    }

    public function searchTreeNode($params) {

        global $ibase;
        $id = $params["tree_node_id"];
        $ids = $ibase->get_list_as_array("SELECT RID FROM GATTUNG WHERE CODE STARTS WITH '$id'");
        if (count($ids) > 0) {
            
            $this->result->assignIDs($ibase->get_list_as_array("SELECT G.ARTIKEL_R RID FROM ARTIKEL_GATTUNG G JOIN " . twebshop_article::TABLE . " A ON (G.ARTIKEL_R=A.RID) WHERE G.GATTUNG_R IN (" . implode(",", $ids) . ") ORDER BY A.TITEL"));
        } else {
            $this->result->assignIDs(array());
        }
        return $this->result->getIDs();
    }

    public function searchAction($id) {
        
    }

    /* --> 25.08.2014 michaelhacksoftware : Nach mehreren Feldern (OR) im Artikel suchen */
    public function searchArticleFields($params) {

        global $ibase;

        $Id     = $params['id'];
        $Fields = $params['fields'];

        $Where = "";
        foreach ($Fields as $Field) {
            $Where .= $Field . " = " . $Id . " OR ";
        }
        $Where = substr($Where, 0, -4);

        $this->result->assignIDs($ibase->get_list_as_array("SELECT RID FROM " . twebshop_article::TABLE . " WHERE " . $Where . " ORDER BY TITEL"));

        return $this->result->getIDs();

    }
    /* <-- */

    public function searchRecords($params) {

        global $ibase;
        $article = new twebshop_article($params["record_id"]);
        $ids = trim($article->getInfo()->getValueByName("CDRID"));
        $ids = ($ids != "") ? explode(";", $ids) : array();
        
        $this->result->assignIDs(array_unique(array_merge($ids, $ibase->get_list_as_array("SELECT M.MASTER_R RID FROM " . TABLE_ARTICLE_MEMBER . " M JOIN " . twebshop_article::TABLE . " A ON (M.ARTIKEL_R=A.RID) WHERE M.ARTIKEL_R=" . twebshop_article::decryptRID($params["record_id"]) . " ORDER BY A.TITEL"))));
        unset($ids);
        
    }

    public function searchContext($params) {
        $context = new twebshop_article_context($params["context_id"]);
        $ids = $context->getMasters($params["sql_order_string"]);
        $this->result->assignIDs($ids);
        unset($ids);
        unset($context);
    }

    public function searchMembers($params) {
        $article = new twebshop_article($params["article_r"]);
        $ids = array_diff(array_keys($article->getMembers()), array(0));
        $this->result->assignIDs($ids);
        unset($ids);
        unset($article);
    }

    private function writeToCache($result) {
        $this->cache[$result->getID()] = $result;
        $this->cache_size = count($this->cache);
    }

    private function isInCache($id) {
        return array_key_exists($id, $this->cache);
    }

    private function readFromCache($id) {
        return ($this->isInCache($id)) ? $this->cache[$id] : NULL;
    }

    public function loadFromCache($id) {
        $this->result = $this->readFromCache($id);
        $this->is_cached = true;
    }

    private function clearCache() {
        unset($this->cache);
        $this->cache = array();
        $this->cache_size = 0;
    }

    public function sortResult($id, $type) {
        if ($this->isInCache($id)) {
            $this->cache[$id]->doSort($type);
            $this->loadFromCache($id);
            $this->has_been_sorted = true;
        }
        else
            echo "not in cache";
    }

    public function getSortOrderType() { //TS 08.12.2011: aufgrund folgender Fehlermeldung (z.B. reproduzierbar, wenn zwischen dem Blättern in den Suchtreffern die Session gelöscht wird, oder wenn die Seite 
        //               ohne vorherige Suche aufgerufen wird (was praktisch nie vorkommen dürfte), es könnte aber auch noch andere Ursachen geben, exzessives Benutzen 
        //               der Browsernavigation in die Vergangenheit konnte aber in einem ersten Versuch ausgeschlossen werden)
        //               wird eine Überprüfung der eigenen ID und der Eigenschaft result (sollte ein Objekt sein) durchgeführt
        //[07-Dec-2011 23:01:33] PHP Fatal error:  Call to a member function getSortOrder() on a non-object in /srv/www/htdocs/hebu-music/classes/t_webshop_search.inc.php5 on line 179
        return ($this->getID() != 0 AND isset($this->result) AND is_a($this->result, "twebshop_search_result")) ? $this->result->getSortOrder()->getType() : twebshop_search_result_sort_order::DEFAULT_TYPE;
        //return $this->result->getSortOrder()->getType();
    }

    public function getHits() {
        return ($this->result) ? $this->result->getHits() : 0;
    }

    public function getResult() { //echo "unsorted:";
        //var_dump($this->result->unsorted);
        //echo "<br /><br /><br />";
        return ($this->result) ? $this->result->getIDs() : array();
    }

    public function fetchResult() {
        $this->article = array();
        if ($this->hits > 0) {
            foreach ($this->result as $article_r) {
                $this->article[] = new twebshop_article($article_r);
            }
        }
        return $this->article;
    }

    public function getArticles() {
        if (count($this->article) == 0) {
            $this->fetchResult();
        }
        return $this->article;
    }

    public function __wakeup() {
        self::$instance = $this;
        $this->has_run = false;
        $this->is_cached = false;
        $this->has_been_sorted = false;
    }

    public function __toString() {
        return self::CLASS_NAME . " (ID: {$this->getID()}, RESULT_ID: {$this->getResultID()}, NEXT_ID: {$this->getNextID()}, CACHE_SIZE: {$this->cache_size})";
    }

}

class twebshop_search_result {

    private $id = 0;
    private $method = "";
    private $params = "";
    private $sort_order = NULL;
    private $unsorted;
    private $sorted = array();
    private $hits = 0;
    private $ids = array();

    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_SEARCH_RESULT";

    public function __construct($id, $method, $params) {
        $this->id = $id;
        $this->method = $method;
        $this->params = $params;
        $this->sort_order = new twebshop_search_result_sort_order();
    }

    public function getID() {
        return $this->id;
    }

    public function getHits() {
        return $this->hits;
    }

    public function getUserExpression() {
        return (array_key_exists("expression", $this->params)) ? $this->params["expression"] : "";
    }

    public function getAssortment() {
        return $this->assortment;
    }

    public function getTreeNodeID() {
        return $this->tree_node_id;
    }

    public function assignIDs($ids) {
        $this->ids = (is_array($ids)) ? $ids : array();
        $this->hits = count($this->ids);
        return $this->hits;
    }

    public function getSortOrder() {
        return $this->sort_order;
    }

    public function doSort($type = 0) {
        if (count($this->unsorted) == 0) {
            $this->unsorted = $this->ids;
        }
        if ($this->sort_order->getType($type) != $type) {
            $this->sort_order->setType($type);
            if (!isset($this->sorted[$type])) {
                $this->sorted[$type] = call_user_func(array(&$this, $this->sort_order->getMethod()));
            }
        }
        $this->ids = $this->sorted[$type];
    }

    private function prepareData($criterion) {
        $data = array();
        $i = 0;
        foreach ($this->unsorted as $id) {
            $i++;
            $data["ids"][] = $id;
            $data["title"][] = twebshop_article::getArticleTitle($id);

            switch ($criterion) {
                case("title"): {
                        $data["criterion"] = $data["title"];
                        break;
                    }
                case("price"): {
                        $price = new twebshop_price($id);
                        $data["criterion"][] = $price->getFlatNetto();
                        unset($price);
                        break;
                    }
                case("difficulty"): {
                        $data["criterion"][] = intval(twebshop_article::getArticleDifficulty($id));
                        break;
                    }
            }
        }
        return $data;
    }

    public function sortAsFound() {
        return $this->unsorted;
    }

    public function sortByTitleASC() {
        $data = $this->prepareData("title");
        array_multisort($data["criterion"], SORT_ASC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function sortByTitleDSC() {
        $data = $this->prepareData("title");
        array_multisort($data["title"], SORT_DESC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function sortByPriceASC() {
        $data = $this->prepareData("price");
        array_multisort($data["criterion"], SORT_ASC, $data["title"], SORT_ASC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function sortByPriceDSC() {
        $data = $this->prepareData("price");
        array_multisort($data["criterion"], SORT_DESC, $data["title"], SORT_ASC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function sortByDifficultyASC() {
        $data = $this->prepareData("difficulty");
        array_multisort($data["criterion"], SORT_ASC, $data["title"], SORT_ASC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function sortByDifficultyDSC() {
        $data = $this->prepareData("difficulty");
        array_multisort($data["criterion"], SORT_DESC, $data["title"], SORT_ASC, SORT_STRING, $data["ids"]);
        return array_values($data["ids"]);
    }

    public function getIDs() {
        return $this->ids;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}

class twebshop_search_result_sort_order {

    static $methods = array(
        -1 => "sortAsFound",
        0 => "sortByTitleASC",
        1 => "sortByTitleDSC",
        2 => "sortByPriceASC",
        3 => "sortByPriceDSC",
        4 => "sortByDifficultyASC",
        5 => "sortByDifficultyDSC"
    );
    private $type = self::DEFAULT_TYPE;

    const DEFAULT_TYPE = -1;
    const CLASS_NAME = "PHP5CLASS T_WEBSHOP_SEARCH_RESULT_SORT_ORDER";

    public function __construct($type = self::DEFAULT_TYPE) {
        $this->setType($type);
    }

    public function setType($type) {
        $this->type = (in_array($type, array_keys(self::$methods))) ? $type : -1;
    }

    public function getType() {
        return $this->type;
    }

    public function getMethod() {
        return self::$methods[$this->getType()];
    }

}
?>
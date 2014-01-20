<?php

//**** KLASSE FÜR DIE SUCHE ***************************************************************************************************
class twebshop_search
{ static private $instance = NULL;

  private $result = array();
  private $assortment = 0;
  private $expression = "";
  private $tree_node_id = 0;
  
  public $hits = 0;

  static public $name = "PHP5CLASS T_WEBSHOP_SEARCH";
  
  private function __construct()
  { 
  }
  
  static public function create()
  { if (!twebshop_search::$instance) 
    { twebshop_search::$instance = new twebshop_search(); }
	return twebshop_search::$instance;
  }
  
  public function searchUserExpression($expression, $assortment = 0)
  { $this->assortment = $assortment;
    $this->expression = $expression;
    $orgamon = torgamon::create();
    $this->result = $orgamon->searchArticle($this->expression, $this->assortment);
	unset($orgamon);
	$this->hits = count($this->result);
	return $this->result;
  }
  
  public function searchTreeNode($id)
  { $this->tree_node_id = $id;
    $dbase = tdbase::create();
	$dbase->sql = "SELECT G.ARTIKEL_R RID FROM ARTIKEL_GATTUNG G JOIN ARTIKEL A ON (G.ARTIKEL_R=A.RID) WHERE G.GATTUNG_R=$id ORDER BY A.TITEL";
    $this->result = $dbase->get_list_as_array();
	unset($dbase);
	$this->hits = count($this->result);
	return $this->result;
  }
  
  public function searchAction($id)
  {
  
  }
  
  public function searchRecord($id)
  {
  
  }
  
  public function getResult()
  { return $this->result; 
  }

}

?>
<?php

class twebshop_article_link extends tvisual
{ private $article_r = "";
  private $title = "";
  public  $url = "";
  private $parsed_url = array();
  
  const CLASS_NAME = "PHP5CLASS T_WEBSHOP_ARTICLE_LINK";
  

  public function __construct($article_r,$title,$url)
  { $this->article_r = $article_r;
    $this->title = $title;
    $this->url = $url;
	$this->parsed_url = parse_url($this->url);
  }
  
  public function getURLComponent($component)
  { return (isset($this->parsed_url[$component])) ? $this->parsed_url[$component] : "";
  }
  
  public function getFromHTMLTemplate($template = NULL)
  { $template = parent::getFromHTMLTemplate($template);
	
	$template = str_replace("~ARTICLE_R~",urlencode($this->article_r),$template);
	$template = str_replace("~ARTICLE_R_RAW",$this->article_r,$template);
	$template = str_replace("~FRAGMENT~",$this->getURLComponent("fragment"),$template);
	$template = str_replace("~HOST~",$this->getURLComponent("host"),$template);
	$template = str_replace("~PASS~",$this->getURLComponent("pass"),$template);
	$template = str_replace("~PATH~",$this->getURLComponent("path"),$template);
	$template = str_replace("~PORT~",$this->getURLComponent("port"),$template);
	$template = str_replace("~QUERY~",$this->getURLComponent("query"),$template);
	$template = str_replace("~SCHEME~",$this->getURLComponent("scheme"),$template);
	$template = str_replace("~TITEL~",$this->title,$template);
	$template = str_replace("~TITLE_BREAK_COLON~",str_replace(":",":<br />",$this->title),$template);
	$template = str_replace("~URL~",urlencode($this->url),$template);
	$template = str_replace("~URL_RAW~",$this->url,$template);
	$template = str_replace("~USER~",$this->getURLComponent("user"),$template);
		
	return $template;
  }

}

?>
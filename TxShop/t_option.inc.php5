<?php

class t_option
{ private $link_href = "";
  private $link_target = "";
  private $link_text = "";
  private $link_class = "";
  private $link_style = "";
  private $icon_url = "";
  private $icon_text = "";
  private $icon_style = "";
  
  private $html = "";
  
  private $template = "";
    
  static public $name = "PHP5CLASS T_OPTION";
  
  public function __construct($template = "")
  { $this->template = $template;
    /*
    $this->link_href = $link_href;
    $this->link_target = $link_target;
	$this->link_text = $link_text;
	$this->link_class = $link_class;
	$this->link_style = $link_style;
	$this->icon_url = $icon_url;
	$this->icon_text = $icon_text;
	$this->icon_style = $icon_style;
	$this->html = "";
	$this->generateHTML();
	*/
  }
  
  public function setLinkHREF($link_href)
  { $this->link_href = $link_href;
  }
  
  public function setLinkTarget($link_target)
  { $this->link_target = $link_target;
  }
  
  public function setLinkText($link_text)
  { $this->link_text = $link_text;
  }
  
  public function setLinkClass($link_class)
  { $this->link_class = $link_class;
  }
  
  public function setLinkStyle($link_style)
  { $this->link_style = $link_style;
  }
  
  public function setIconURL($icon_url)
  { $this->icon_url = $icon_url;
  }
  
  public function setIconText($icon_text)
  { $this->icon_url = $icon_url;
  }
  
  public function setIconStyle($icon_style)
  { $this->icon_style = $icon_style;
  }
  
  public function setHTMLTemplate($template)
  { if (is_object($template) AND is_a($template,"ttemplate")) 
	{ $this->template = ($template->getTemplate(self::$name) != NULL) ? $template->getTemplate(self::$name) : $this->template;
	} 
	else $this->template = $template;
	return $this->template;
  }
  
  public function generateHTML()
  { if ($this_>link_href != "" AND ($this->link_text != "" OR $this->icon_url != "")) 
    { $html = "<a ";
	  $html.= ($this->link_class != "") ? "class=\"{$this->link_class}\" " : "";
	  $html.= "href=\"{$this->link_href}\" ";
	  $html.= ($this->link_target != "") ? "target=\"{$this->link_target}\" " : "";
	  $html.= ($this->link_style != "") ? "style=\"{$this->link_style}\"" : "";
	  $html.= ">";
	  $html.= ($this->icon_url != "") ? image_tag($this->icon_url,($this->icon_text != "") ? $this->icon_text : "",($this->icon_style != "") ? $this->icon_style : "") : $this->link_text;
	  $html.= "</a>";
	  $this->html = $html;
	}
	else $this->html = "Option konnte nicht erzeugt werden !";
	return $this->html;
  }
  
  public function getFromHTMLTemplate($template = NULL)
  { $template = ($template == NULL) ? $this->template : $this->setHTMLTemplate($template);
    
	$template = str_replace("~LINK_HREF~",$this->link_href,$template);
	$template = str_replace("~LINK_TARGET~",$this->link_target,$template);
	$template = str_replace("~LINK_TEXT~",$this->link_text,$template);
	$template = str_replace("~LINK_CLASS~",$this->link_class,$template);
	$template = str_replace("~LINK_STYLE~",$this->link_style,$template);
	$template = str_replace("~ICON_URL~",$this->icon_url,$template);
	$template = str_replace("~ICON_TEXT~",$this->icon_text,$template);
	$template = str_replace("~ICON_STYLE~",$this->icon_style,$template);
	return $template;
  }
    
  public function getFromProperties()
  { if ($this->html = "") $this->html = $this->generateHTML();
    return $this->html;
  }
  
  public function __toString()
  { return t_option::$name;
  }
}

?>
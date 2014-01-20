<?php

define("MESSAGETITLE","<b>Meldung:</b>");

class tmessagelist
{ static private $instance = NULL;
  private $message_txt = array();
  private $title = "";
  private $color = "#000000";
  private $icon = false;
  private $template = "";
  
  public $message = false;
  
  private function __construct($title = MESSAGETITLE, $color = "#000000", $icon = false, $template = "")
  { $this->title = $title;
    if ($color != "") { $this->color = $color; }
    $this->icon = $icon;
	$this->template = $template;
  }
  
  static public function create($title = MESSAGETITLE, $color = "#000000", $icon = false, $template = "")
  { if (!tmessagelist::$instance) 
    { tmessagelist::$instance = new tmessagelist($title, $color,$icon,$template); }
	return tmessagelist::$instance;
  }
  
  public function add($msg)
  { $this->message = true;
    $this->message_txt[] = $msg;
  }
  
  public function clear()
  { $this->message = false;
    $this->message_txt = array();
  }
  
  public function setTitle($title)
  { $this->title = $title;
  }
  
  public function setColor($color)
  { $this->color = $color;
  }
  
  public function setIcon($icon)
  { $this->icon = $icon;
  }
  
  public function setHTMLTemplate($template)
  { $this->template = $template;
  }
  
  public function getHTMLTemplate()
  { return $this->template;
  }
  
  public function getFromHTMLTemplate($list = "")
  { if ($this->message AND $this->template != "") 
    { $html = $this->template;
	  if ($this->icon != false) { $html = str_replace("~ICON~",image_tag($this->icon,"Fehler"),$html); }
	  if ($list == "") { $list = $this->getAsHTML(); }
	  $html = str_replace("~LIST~",$list,$html);
	  return $html;
	}
	else return "<!-- no message //-->";
  }
  
  public function getAsHTML()
  { if ($this->message) 
    { $html = "";
	  if ($this->title != "") { $html.= $this->title . CRLF; }
	  $html.= "<ul style=\"color:{$this->color};\">" . CRLF;
      foreach($this->message_txt as $msg)
	  { $html.= "<li>$msg</li>" . CRLF; }
	  $html.= "</ul>"; 
	  return $html;
	} 
	else return "<!-- no message //-->";
  }
  
  public function getAsCustomHTML($pre = "-", $post = "<br />")
  { if ($this->message) 
    { $html = "";
	  foreach($this->message_txt as $txt)
	  { $html.= "<span style=\"color:{$this->color};\">" . $pre . $txt . $post . "</span>" . CRLF; }
	  return $html; 
	}
	else return "<!-- no error //-->";
  }
  
  public function getAsArray()
  { if ($this->message) { return $this->message_txt; }
    else return false;
  }
  
  public function getAsString($separator = ",")
  { if ($this->message) { return implode($separator,$this->message_txt); }
    else return false;
  }
  
}

?>
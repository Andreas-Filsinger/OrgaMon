<?php

define("DEFAULT_CONFIG_XML","config.xml");
define("DEFAULT_CONFIG_XML_TEMPLATE","template.config.xml");
define("DEFAULT_SWF_PATH","./");
define("DEFAULT_MP3_PATH","./mp3/");
define("DEFAULT_TMP_PATH","./tmp/");

class tmp3player
{ static private $instance = NULL;

  private $template = "";
  private $configxml = "";
  private $configxml_template = "";
  private $swfpath = "";
  private $mp3path = "";
  private $tmppath = "";
  private $info = "";
  
  private $user_id = "";
  
  private $playlist = array();
  public $count = 0;
    
  static public $name = "PHP5CLASS T_WEBSHOP_SEARCH";
  
  private function __construct($template)
  { $this->template = $template;
    $this->setConfigXML();
	$this->setConfigXMLTemplate();
	$this->setSWFPath();
	$this->setMP3Path();
	$this->setTMPPath();
    $this->setUserID();
  }
  
  static public function create($template = "")
  { if (!tmp3player::$instance) 
    { tmp3player::$instance = new tmp3player($template); }
	return tmp3player::$instance;
  }
  
  public function setConfigXML($configxml = DEFAULT_CONFIG_XML)
  { $this->configxml = $configxml;
  }
  
  public function setConfigXMLTemplate($configxml_template = DEFAULT_CONFIG_XML_TEMPLATE)
  { $this->configxml_template = $configxml_template;
  }
  
  public function setSWFPath($path = DEFAULT_SWF_PATH)
  { $this->swfpath = path_format($path,true,true);
  }
  
  public function setMP3Path($path = DEFAULT_MP3_PATH)
  { $this->mp3path = path_format($path,true,true);
  }
  
  public function getMP3Path()
  { return $this->mp3path;
  }
  
  public function setTMPPath($path = DEFAULT_TMP_PATH)
  { $this->tmppath = path_format($path,true,true);
  }
  
  public function getTMPPath()
  { return $this->tmppath;
  }
  
  public function setUserID($id = "")
  { $this->user_id = $id; 
    return $this->user_id;
  }
  
  public function setInfo($info = "")
  { $this->info = htmlentities($info);
  }
  
  private function createTMPFiles()
  { $this->clearTMPFiles();
    $playlist = array();
    $i = 0;
	$time = time();
    foreach($this->playlist as $entry)
	{ $i++;
	  $tmpfile = (($this->user_id != "") ? ($this->user_id . $time) : md5($time)) . $i;
	  $playlist[$entry] = $tmpfile;
	  copy($this->mp3path.$entry, $this->tmppath.$tmpfile);
	}
	$this->playlist = $playlist;
  }
  
  public function clearTMPFiles()
  { $tmpfiles = file_search($this->tmppath,"[a-zA-Z0-9]");
    foreach($tmpfiles as $tmpfile)
	{ if (time() - filemtime($tmpfile = $this->tmppath . $tmpfile) > 3600) unlink($tmpfile);
    }
  }
  
  public function setPlaylist($playlist, $sorted = true)
  { if (is_array($playlist)) 
    { if ($sorted) asort($playlist);
	  $this->playlist = $playlist;
      $this->count = count($this->playlist);
	  return $this->count;
	}
	else return false;
  }
  
  public function makeConfigXML($playlist = "")
  { if (is_array($playlist)) $this->setPlaylist($playlist);
    if ($this->tmppath != "") { $this->createTMPFiles(); } 
    if ($this->count > 0) 
	{ $playlist = "";
	  $i = 1 ;
	  foreach($this->playlist as $entry) 
      { $playlist .= "<song name=\"$i. " . $this->info . "\" file=\"" . $entry . "\" />\r\n";
        $i++;
	  }
	  //Bei nur einem Playlisteneintrag läuft der Player nicht, also wird der eine Eintrag gedoppelt
	  if ($this->count == 1) { $playlist .= "<song name=\"1. " . $this->info . "\" file=\"" . $entry . "\" />\r\n"; }
	
	  $xml = file_get_contents($this->configxml_template);
      $xml = str_replace("~MP3DIR~",($this->tmppath == "") ? $this->mp3path : $this->tmppath,$xml);
      $xml = str_replace("~PLAYLIST~",$playlist,$xml);
      file_put_contents($this->configxml,$xml);
	  return true;
	}
	else return false;
  }
  
  public function setHTMLTemplate($template = "")
  { $this->template = $template;
  }
  
  public function getHTMLTemplate()
  { return $this->template;
  }
  
  private function getConfigXMLParam()
  { if ($this->configxml != "" AND $this->configxml != DEFAULT_CONFIG_XML) 
    { return "?playlist=" . urlencode($this->configxml); }
	else return "";
  }
  
  public function getFromHTMLTemplate($template = "")
  { if ($template == "") { $template = $this->template; }
    $template = str_replace("~SWFPATH~",$this->swfpath,$template);
    $template = str_replace("~CONFIGXML~",$this->getConfigXMLParam(),$template);
    return $template;  
  }
  
  public function publish()
  { $this->makeConfigXML();
    echo $this->getFromHTMLTemplate();
  }
   
  function __toString()
  { return tmp3player::$name;
  }
     
}
?>
<?php
// PROJECT-SPEZIFISCH
function get_revision($infohtml = "")
{ if ($infohtml == "") {  $infohtml = _PROJECTNAME . "_Info.html";  }
  if (file_exists($infohtml)) 
  { $data = strip_tags(file_read($infohtml));
    $lines = preg_split("/\r?\n/",$data);
    foreach($lines as $key => $line)
	{ $p = strpos(strtoupper($line),"REV.",0);
	  if ($p !== false) { $line = trim($line); break; }
	}		
	$rev = substr($line,$p+4+1,strlen($line)-$p-4);
  }
  else $rev = 0;
  return $rev;
}

function index()
{ return path_format(basename($_SERVER["PHP_SELF"]),true);
}

$_INDEX = index();

// HTML-FORMATIERUNGEN
function image_size($filename)
{ if (file_exists($filename)) 
  { $size = getimagesize($filename); 
    return $size[3];
  }
  else { return ""; }
}

function image_tag($filename, $alt = "", $style = "")
{ if (file_exists($filename)) 
  { if ($style != "") { $style = " style=\"$style\"";  }
    $tag = "<img src=\"$filename\" border=\"0\" " . image_size($filename) .  " alt=\"" . $alt . "\"" . $style . ">";
  }
  else $tag = "<p>Bilddatei $filename nicht gefunden !</p>";
  return $tag;
}

function image_show($filename, $alt = "", $style = "")
{ echo image_tag($filename, $alt, $style); 
}

function anchor_tag($href, $innerHTML, $class = "")
{ if ($class == "") { $class = "standard"; }
  if (strpos($href,"@") !== false) { $href = "mailto:" . $href;  }
  $tag = "<a class=\"$class\" href=\"$href\">$innerHTML</a>";
  return $tag;
}

function br_tag()
{ return "<br />"; }

function bold_tag($innerHTML)
{ return "<b>" . $innerHTML . "</b>"; }

function span_tag($innerHTML, $class="")
{ if ($class != "") { $class = "class=\"$class\""; }
  return "<span $class>$innerHTML</span>";
}

function select_tag($name, $options, $selected = 0, $assoc = false)
{ $html = "<select name=\"$name\">\r\n";
  foreach($options as $value => $option) 
  { if ($assoc) { $html.="<option value=\"" . $option . "\">" . $option . "</option>\r\n"; }
    else { $html.="<option value=\"" . $value . "\">" . $option . "</option>\r\n"; }
  }
  $html.= "</select>\r\n";
  return $html;
}




// STRING-FORMATIERUNGEN
// Text
function quote($str)
{ return (strip_tags($str) != "") ? ("\"" . $str . "\"") : ($str); }

function ltrim_char($str, $char = " ")
{ if ($char == " ") { return ltrim($str); }
  else
  { while(substr($str,0,1) == $char) { $str = substr($str,1); }
    return $str;
  }
}

function rtrim_char($str, $char = " ")
{ if ($char == " ") { return rtrim($str); }
  else
  { while(substr($str,-1) == $char) { $str = substr($str,0,strlen($str)-1); }
    return $str;
  }
}

function trim_char($str, $char = " ")
{ if ($char == " ") { return trim($str); }
  else { return rtrim(ltrim($str,$char),$char); }
}

// Pfade, Verzeichnisse
function path_format($path, $leading_dots = false, $final_slash = false, $dot = ".", $slash = "/")
{ if ($slash == "/") { $path = str_replace("\\",$slash,$path); }
  else { $path = str_replace("/",$slash,$path); }
    
  $path = ltrim_char($path,".");
  $path = ltrim_char($path,$slash);
  $path = rtrim_char($path,$slash);
  
  $result = $path; 
  if ($leading_dots) { $result = $dot . $slash . $path; }
  if ($final_slash AND $path != "")  { $result .= $slash; }
  return $result;
}

// DATEIEN
function file_extension($filename, $case = 1)
{ $dot = strrpos($filename,".");
  if ($dot !== false) $extension = substr($filename,$dot);
  else $extension = "";
  if ($case == 1) return strtoupper($extension);
  else return strtolower($extension);
}

function file_search($path, $regular_expression)
{ $files = array();
  $dir = opendir(path_format($path,true,true)); 
  while ($file = readdir ($dir))
  { if ($file != "." && $file != ".." && !is_dir($path.$file) && ereg($regular_expression,$file))
    { $files[] = $file; } 
  } 
  closedir($dir);
  return $files;
}

function file_size_kB($file)
{ return floor(filesize($file)/1024); }

// USER-EINGABE-FILTER
function form_input_filter(&$input)
{ $input = strip_tags($input);
  $input = stripslashes($input);
}

function form_input_filter_low(&$input)
{ $input = strtolower($input);
  form_input_filter($input);
}

function form_text_filter(&$text)
{ $text = stripslashes($text);
  $text = addslashes($text);
  $text = strip_tags($text);
  $text = nl2br($text);
}

function check_phone($phone)
{ return ereg("^[+]{0,1}([0-9]+[ ]*)+$",$phone); }

function check_email($email)
{ return ereg("^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@([a-zA-Z0-9]+[_a-zA-Z0-9-]+\.)+([a-zA-Z]{2,4})$",$email); }

function check_url($url)
{ return true;
}

function arr_dump($arr)
{ if (is_array($arr)) 
  { echo "(";
    foreach($arr as $key => $value)
    { echo "$key => "; 
      switch(true)
	  { case (is_array($value)): arr_dump($value); break;
	    // case (is_object($value)): obj_dump($value); break;
		default: echo $value;
	  }
	  echo ", ";
	}
	echo ")";
  }
}

function obj_dump($obj)
{ if (is_object($obj)) 
  { echo $obj, br_tag();
    $properties = get_object_vars($obj);
    foreach($properties as $name => $value)
    { echo "$name: ";
	  switch(true)
	  { case (is_array($value)): arr_dump($value); break;
	    // case (is_object($value)): obj_dump($value); break;
		default: echo $value;
	  }
	  echo br_tag();
	}
  }
}

?>

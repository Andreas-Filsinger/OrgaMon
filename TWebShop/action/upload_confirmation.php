<?php

if (isset($f_user) AND isset($id) AND check_numeric($id))
{ //$id = intval($id);
  //$sql = "SELECT INFO FROM EREIGNIS WHERE RID=$id";
  //$info = $ibase->get_field($sql,"INFO");
  $event = new torgamon_event($id);
  $data = new tstringlist();
  $data->assignString($event->getInfo());
  if (($data->getValueByName("email") == $f_user)) 
  { $result = true;
    
	$path = $data->getValueByName("path");
    
	$files = file_search($path.$id);
	//var_dump($files);
	foreach($files as $file)
	{ $result = $result AND copy($path.$id."/".$file,$path.$file);
	}
	
	if ($result) 
	{ foreach($files as $file)
	  { $result = $result AND unlink($path.$id."/".$file);
	  }
	  if ($result) 
	  { $result = $result AND rmdir($path.$id."/");
	  }
	}  
  
    if($result)
    { $messagelist->add("Ihre Daten wurden für die Veröffentlichung in \"Die Blasmusik\" freigeschaltet.");
	}
	else
	{ $errorlist->add("Beim Freischalten de Daten ist ein Fehler aufgetreten. Bitte versuchen sie es nochmals.");
	}
  }
  else
  { $errorlist->add("Die übermittelten Daten finden keine Übereinstimmung im System.");
  }
  unset($event);
}

?>
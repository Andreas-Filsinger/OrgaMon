<?php

if (file_exists(MP3_DOWNLOAD_LOG_PATH)) 
{ $log = path_format(MP3_DOWNLOAD_LOG_PATH,true,true) . MP3_DOWNLOAD_LOG_NAME;
} 
else
{ $log = MP3_DOWNLOAD_LOG_NAME;
}

if ($user->loggedIn() AND (isset($id)))
{ $article = new twebshop_article($id);
  $mymusic = $user->getMyMusic()->getItemByArticleID($article->getiRID());
  $mp3 = $article->getMP3DownloadFileName();
  $name = file_name_strip_invalid_characters("hebumusic_" . $article->getMediaName() . "_" . trim($article->TITEL) . "_" . trim($article->getArranger()) . ".mp3"); 

  if ($mymusic->areDownloadsAvailable())
  { if (is_readable($mp3))
    { $size = filesize($mp3);
	
	  $site->setHeader(false);
      $site->setContent(false);
      $site->setFooter(false);
  
      header("Content-Type: audio/mpeg");
      header("Content-Length: $size");
      header("Content-Disposition: attachment; filename=\"$name\"");
	  
	  // ACHTUNG: ZUM VERSTÄNDNIS
	  // 1) DER BEFEHL READFILE() WIRD SO LANGE AUSGEFÜHRT BIS DAS LETZTE 
	  //    BYTE AN DEN APACHE UND VOM APACHE AN DEN CLIENT ÜBERTRAGEN WURDE. 
	  //    ERST DANN LÄUFT DAS SKRIPT WEITER.
	  //    DIES KANN BEI LANGSAMER VERBINDUNG (UPSTREAM) UND GROSSEN DATEIEN LANGE DAUERN.
	  //    DIESE ZEIT ZÄHLT ABER TROTZDEM NICHT ZUR MAXIMUM EXECUTION TIME !!!
	  //    SCHEINBAR UNTERBRICHT DER APACHE PHP SOLANGE ODER BREMST ES SO AUS BIS DIE NÄCHSTEN 
	  //    DATEN AUF DIE REISE GESCHICKT WERDEN KÖNNEN. DIE DAUER DER UNTERBRECHUNG WIRD NICHT 
	  //    ZUR AUSFÜHRUNGSZEIT HINZUGEZÄHLT. 
	  // 2) EIN ABBRUCH DES DOWNLOADS AUF DEM CLIENT BEDEUTET EINEN ABBRUCH DES LAUFENDEN 
	  //    SKRIPTS, DAS SICH DANN IM WAHRSCHEINLICHSTEN FALLE GERADE BEI DER AUSFÜHRUNG VON READFILE() 
	  //    BEFINDET. ALLE WEITEREN ANWEISUNGEN WERDEN NICHT MEHR AUSGEFÜHRT. DESHALB MUSS DIE 
	  //    FEHLERMELDUNG (NÄCHSTE ZEILEN) VORHER GESETZT UND IM ERFOLGSFALL ÜBERSCHRIEBEN WERDEN.
		  
	  $session->registerTmpVar("result",false,$site->getName());
	  $session->registerTmpVar("result_string",ERROR_DOWNLOAD_INCOMPLETE,$site->getName());
      
	  $start = microtime();
	    
      if ($size == readfile($mp3))
	  { $mymusic->decrementRemainingDownloads();
	    $mymusic->updateInDataBase();
		
		$session->registerTmpVar("result",true,$site->getName());
	    $session->registerTmpVar("result_string",$name,$site->getName());
		
		$stop = microtime();
	  
	    file_put_contents($log,
	  	   				"<DATE>"    . date("d.m.Y H:i")       . "</DATE>" . 
	                    "<IP>"      . $_SERVER["REMOTE_ADDR"] . "</IP>" . 
						"<USER>"    . $user->getID()          . "</USER>" . 
						"<FILE>"    . $name                   . "</FILE>" . 
						"<SECONDS>" . round($stop - $start)   . "</SECONDS>\r\n",
						FILE_APPEND
	    ); 
	  }
    } 
	else
	{ $errorlist->add(SENTENCE_DOWNLOAD_FAILED);
	  $errorlist->add(ERROR_FILE_DOESNT_EXIST);
	}
  }
  else
  { //Downloads ausgeschöpft
    $errorlist->add(SENTENCE_DOWNLOAD_FAILED);
   	$errorlist->add(ERROR_NO_DOWNLOADS_AVAILABLE);
  }
  
  unset($name);
  unset($mp3);
  unset($mymusic);
  unset($article);
}
else
{ $errorlist->add(ERROR_NO_AUTHORIZATION_TO_RUN_THIS_ACTION);
}

unset($log);

?>

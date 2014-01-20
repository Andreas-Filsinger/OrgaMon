<?php
class PNGChunk
{ private $imagetext = "";
	
  public function __construct($URL)
  { $this->setPicURL($URL);
  }	
	
  public function createChunk($name, $text)
  { $lengthHEX = dechex(strlen($text)+strlen($name)+1);//Länge der ChunkID und des Textes ermitteln in HEX
	$length = $this->hexToString($lengthHEX);//umwandeln in ASCII-Zeichen
	while(strlen($length) < 4)//Vorne mit HEX 00 auffüllen auf 4 Byte
	{ $length = chr(0).$length;		//chr(0) gibt die ascii NUL zurück -> HEX 00h
	}  
	$tag = "tEXt".$name.chr(0).$text;//Tag für die Prüfsummenbildung und die Ausgabe vorbereiten
	$psHEX = dechex(crc32($tag));//Prüfsumme blden und in HEX umwandeln
	while(strlen($psHEX) < 8)//Vorne mit 0 auffüllen , wenn die läng nicht 8 beträgt
	{ $psHEX = "0".$psHEX;
	}  
	$ps = $this->hexToString($psHEX);//In ASCII Umwandeln
	$inputpos = strpos($this->imagetext, "IEND")-4;//Ermitteln der Chunkposition
	$postTag = substr($this->imagetext, $inputpos);//Auftrennen in vorderen undhinteren teil
	$preTag = substr($this->imagetext, 0, $inputpos);//...

	//Vereinigen des Vorderen teils, der länge in byte, des Tags an sich, der Prüfsumme, und des hinteren Bildteils.
	$this->imagetext = $preTag.$length.$tag.$ps.$postTag;
  }
	
  private function as4($num)
  { $asHex = sprintf('%8X',$num);
	return chr(hexdec(substr($asHex,0,2))) . chr(hexdec(substr($asHex,2,2))) . chr(hexdec(substr($asHex,4,2))) . chr(hexdec(substr($asHex,6,2))); 
  }
	
  public function add_tEXt($parameterName, $parameterValue)
  { // ein PNG Chunk:
	// 0004xLengthOfData . 0004xNameOfChunk . \0 . [ ????xData ] . 0004xCRC
	// 0004xLengthOfData = sizeof(Data);
	// 0004xCRC = crc32(NameOfChunk+Data)

	// tEXt - Chunk:
	// 0004xNameOfChunk = 'tEXt'
	// ????xData = Name . \0 . Value
	   
	// IEND-Chunk
	// 0000IENDcccc
	   
	// ein PNG - File:
	//  137 80 78 71 13 10 26 10 { CHUNK }   IEND-Chunk.

    // Länge  
	$Chunk_IEND = substr($this->imagetext,-12);
	$Chunk_Name = "tEXt";
	$Chunk_Data = $parameterName . chr(0) . $parameterValue;
	$Chunk_CRC = crc32($Chunk_Name . $Chunk_Data);

	// vereinigen des Vorderen teils, der länge in byte, des Tags an sich, der Prüfsumme, und des hinteren Bildteils.
	$this->imagetext = 
	   substr($this->imagetext, 0, -12) . 
	   $this->as4(strlen($Chunk_Data)) .
	   $Chunk_Name . 
	   $Chunk_Data .
	   $this->as4($Chunk_CRC) . 
	   $Chunk_IEND;
		 
	}
	
	
	public function setPicURL($URL)
	{ $this->imagetext = file_get_contents($URL);
	}
	
	public function savePicByURL($saveURL)
	{ file_put_contents($saveURL,$this->imagetext);
	}
	
	private function hexToString($hex) //Umwandeln einer beliebigen HEX-Zahl in ASCII
	{ $out = "";
	  if(strlen($hex) == 1)
	  { $out = chr(hexdec($hex));
	  }
	  else
	  { for ($i=0; $i<strlen($hex)-1; $i+=2)
		{ $out .= chr(hexdec($hex[$i].$hex[$i+1]));
		}
	  }
	  return $out;
	}

}

?>

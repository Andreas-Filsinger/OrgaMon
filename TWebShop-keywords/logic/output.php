<?php

ob_start();

// AUSGABE
//Kopf
if ($site->hasHeader()) 
{ echo $header->getFromHTMLTemplate();
}
// Inhalt
if ($site->hasContent()) 
{ echo $site->getFromHTMLTemplate();
}
// Fuss
if ($site->hasFooter()) 
{ echo $footer->getFromHTMLTemplate();
}


$buffer = ob_get_clean();
//$config = array("indent" => false, "output-xhtml" => true, "wrap" => 200);
//$output = tidy_parse_string($buffer, $config);
//$output->cleanRepair();

//echo tidy_error_count($output); 
//echo $output;
echo trim($buffer);

?>

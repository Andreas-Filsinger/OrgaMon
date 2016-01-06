<?php

ob_start();

// Inhalt
if ($site->hasContent()) { 
    echo $site->getFromHTMLTemplate();
}

$buffer = ob_get_clean();
//$config = array("indent" => false, "output-xhtml" => true, "wrap" => 200);
//$output = tidy_parse_string($buffer, $config);
//$output->cleanRepair();

//echo tidy_error_count($output); 
//echo $output;
echo trim($buffer);


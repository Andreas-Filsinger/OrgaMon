<?php
  
  if (!isset($site) AND !array_key_exists("s_site",$_SESSION)) { $site = "home"; }
  if (!isset($site) AND array_key_exists("s_site",$_SESSION)) { $site = $_SESSION["s_site"]; }
  if (isset($site) AND file_exists($includefile = "s_" . $site . ".inc.php5")) include_once($includefile);
  if (isset($site)) { $_SESSION["s_site"] = $site; }
  
?>
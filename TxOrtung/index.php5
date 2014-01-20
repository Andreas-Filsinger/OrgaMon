<?php
include_once("i_config.inc.php5");
require_once("i_global_vars.inc.php5");
?>
<html>
<head>
<title>TxOrtung Rev. <?php echo VERSION; ?></title>
</head>

<body>
<b>TxOrtung</b><br />
<?php

if (!file_exists(PATH_MAPS)) 
{ if (mkdir(PATH_MAPS)) 
  { echo "<span style=\"color:#0C0;\"><b>Ordner " . PATH_MAPS . " zum Ablegen der Karten wurde erstellt.</b></span><br />";
  }
  else
  { echo "<span style=\"color:#C00;\"><b>Ordner " . PATH_MAPS . " ist nicht vorhanden und konnte nicht erstellt werden. Dieser Ordner wird benötigt, um die Karten abzulegen, und muss gegebenenfalls manuell angelegt werden.</b></span><br />";
  }
}

?>
<form action="locate.php5">
PLZ:&nbsp;<input type="text" name="zip" size="7">
Ort:&nbsp;<input type="text" name="city" size="50"><br>
Strasse:&nbsp;<input type="text" name="street" size="50">
Nr:&nbsp;<input type="text" name="number" size="4"><br>
Profil:&nbsp;<input type="text" name="profile" size="25"><br>
<input type="submit" value="Ok">
</form>
</body>
</html>
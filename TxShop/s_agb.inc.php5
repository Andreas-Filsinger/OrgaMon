<?php

if (file_exists(TERMS_OF_BUSINESS)) 
{ $fp = fopen(TERMS_OF_BUSINESS,"r");
  $agb = fread($fp,filesize(TERMS_OF_BUSINESS));
  fclose($fp);
}
else
{ $agb = "Es liegen zur Zeit keine AGB vor."; }

$agb = nl2br($agb);
?>
<table class="window" width=780 border=0 cellpadding=5 cellspacing=0>
<tr><td>
<b>Allgemeine Geschäftsbedingungen:</b><br />
<?php echo $agb; ?>
</td></tr>
</table>


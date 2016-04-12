<?php

require_once("i_config.inc.php5");
require_once("i_global_vars.inc.php5");
require_once("i_coordinate_funcs.inc.php5");
require_once("i_types.inc.php5");
require_once("i_templates.inc.php5");

define("SERVICE_PATH","/xlocate/ws/XLocate");

$wsdl_url = (USE_STATIC_WSDL) ? CACHED_WSDL_LOCATE : LOCATE_SERVER.":".LOCATE_SERVICE_PORT.SERVICE_PATH."?WSDL";
   
// init xLocate SOAP client  
$xLocate = new XLocateWSService($wsdl_url, array(
  'location' => LOCATE_SERVER . SERVICE_PATH,  
  'trace' => TRUE,
  'exceptions' => TRUE,  
  'proxy_host' => HTTP_PROXY_HOST,  
  'proxy_port' => HTTP_PROXY_PORT,
  'login' => LOGIN,
  'password'=> PASS,
  'uri' => REFERRER)
);  

//define address
$mAddress = new Address();  
$mAddress->country = (isset($country)) ? $country : "D";
$mAddress->postCode = (isset($zip)) ? $zip : null;
$mAddress->city = (isset($city)) ? utf8_encode($city) : null;
$mAddress->city2 = (isset($district)) ? utf8_encode($district) : null;
$mAddress->street = (isset($street)) ? utf8_encode($street) : null;
$mAddress->houseNumber = (isset($number)) ? $number : null;
  
// create findAddress request  
$request = new findAddress(); 
$request->Address_1 = $mAddress;

// set Profile Property (Default = just unset)
if (isset($profile)) {
 $mCallerContext = new CallerContext();
 $mCallerContext->wrappedProperties = array ( new CallerContextProperty() );
 $mCallerContext->wrappedProperties[0]->key="Profile";
 $mCallerContext->wrappedProperties[0]->value=$profile;
 $request->CallerContext_5 = $mCallerContext;
} 

// call findAddress (via SOAP)  
try { 
  $resultMessage = $xLocate->findAddress($request);
} 
catch (SoapFault $exception) { 
  echo "HEADERS:\n" . htmlentities($xLocate->__getLastRequestHeaders()) . "\n";
  echo "ANFRAGE:\n" . htmlentities($xLocate->__getLastRequest()) . "\n";
  print "<pre>";
  print_r($exception);
  print "</pre>";
}

$result = $resultMessage->result->wrappedResultList->ResultAddress;
$addresses = (is_array($result)) ? $result : array($result);

?>
<html>
<head>
<style type="text/css">
  .breakhere {page-break-before: always}
  table.border {border-color:#000000; border-style:solid; border-width:0pt;}
  td { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }
  td.gend { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }
  td.gfoot { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:0pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }
  td.gright { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }
</style>
<title>locate.php5 Rev. <?php echo VERSION; ?></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Expires" content="0">
</head>
<body bgcolor="#ffffff" text="#000000" link="#cc0000" vlink="#999999" alink="#ffcc00">
<table class="border" cellpadding="2" cellspacing="0" width="100%" style="border-collapse:collapse;">
<tr>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">X</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Y</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Strasse</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Nummer</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">PLZ</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Ort</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Ortsteil</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Aussagekraft</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Schaerfe</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Quote</font></td>
  <td bgcolor="#C8D8E0"><font face="Verdana" size="-1">Karte</font></td>
</tr> 
<?php

$data = "";
foreach ($addresses as $address)
{ list($x, $y) = Mercator2GeoDecimal($address->coordinates->point->x, $address->coordinates->point->y);
  
  //$X = $address->coordinates->point->x;
  //$Y = $address->coordinates->point->y;
  
  $template = $_TEMPLATE_LOCATION_RESULT;
  $template = str_replace("~X~",$x,$template);
  $template = str_replace("~Y~",$y,$template);
  $template = str_replace("~STREET~",htmlentities(utf8_decode($address->street)),$template);
  $template = str_replace("~NUMBER~",htmlentities($address->houseNumber),$template);
  $template = str_replace("~ZIP~",$address->postCode,$template);
  $template = str_replace("~CITY~",htmlentities(utf8_decode($address->city)),$template);
  $template = str_replace("~CITY2~",htmlentities(utf8_decode($address->city2)),$template);
  $template = str_replace("~AUSSAGEKRAFT~",htmlentities(utf8_decode($address->classificationDescription)),$template);
  $template = str_replace("~SCHAERFE~",htmlentities(utf8_decode($address->detailLevelDescription)),$template);
  $template = str_replace("~QUOTE~",htmlentities($address->totalScore),$template);
  echo $template;
  
  $data .= 
    $x . CSV_SEPARATOR .
    $y . CSV_SEPARATOR . 
    utf8_decode($address->street) . CSV_SEPARATOR .
    $address->houseNumber . CSV_SEPARATOR .
    $address->postCode . CSV_SEPARATOR .
    utf8_decode($address->city) . CSV_SEPARATOR .
    utf8_decode($address->city2) . CSV_SEPARATOR .
    utf8_decode($address->classificationDescription) . CSV_SEPARATOR .
    utf8_decode($address->detailLevelDescription) . CSV_SEPARATOR .
    $address->totalScore .
    CRLF;
}

?>
</table>
<!-- BEGIN DATA -->
<!--
X;Y;STRASSE;NUMMER;PLZ;ORT;ORSTTEIL;AUSSAGEKRAFT;SCHAERFE;QUOTE
<?php echo $data; ?>
-->
<!-- END DATA -->
</body>
</html>
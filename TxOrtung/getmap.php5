<?php
// TxOrtung 4.012


$time_start = microtime(true);

require_once("i_config.inc.php5");
require_once("i_global_vars.inc.php5");
require_once("i_coordinate_funcs.inc.php5");
require_once("i_types.inc.php5");
require_once("pngTextEdit.php5");

define("SERVICE_PATH","/xmap/ws/XMap");

$wsdl_url = (USE_STATIC_WSDL) ? CACHED_WSDL_GETMAP : SERVER.":".GETMAP_SERVICE_PORT.SERVICE_PATH."?WSDL";

// init xMap SOAP client  
$xMap = new XMapWSService($wsdl_url, array(
  'location' => SERVER.":".GETMAP_SERVICE_PORT.SERVICE_PATH,  
  'trace' => '1',  
  'exceptions' => '1',  
  'proxy_host' => HTTP_PROXY_HOST,  
  'proxy_port' => HTTP_PROXY_PORT,
  'login' => LOGIN,
  'password'=> PASS,
  'uri' => "http://test-uri/")
); 

$z = (isset($z)) ? $z : 100;

list($X, $Y) = GeoDecimal2Mercator($x, $y);

$mapSection = new MapSection();  
$mapSection->center = new Point();
$mapSection->center->point = new PlainPoint();
$mapSection->center->point->x = $X; //685407.751736;
$mapSection->center->point->y = $Y; //6372537.965244; 
$mapSection->scale = 0;  
$mapSection->scrollHorizontal = 0;  
$mapSection->scrollVertical = 0;  
$mapSection->zoom = 0;  

$_width_half = round(13.71/2 * IMAGE_WIDTH * $z/100);
$_height_half = round(8.99/2 * IMAGE_HEIGHT * $z/100);

$boundingBox = new BoundingBox();
$boundingBox->leftTop->point->x = XGeoDecimal2Mercator($x - $_width_half);
$boundingBox->leftTop->point->y = YGeoDecimal2Mercator($y - $_height_half);
$boundingBox->rightBottom->point->x = XGeoDecimal2Mercator($x + $_width_half);
$boundingBox->rightBottom->point->y = YGeoDecimal2Mercator($y + $_height_half);

$mapParams = new MapParams();    
$mapParams->showScale = false;    
$mapParams->useMiles = false;              

$imageInfo = new ImageInfo();  
$imageInfo->format = "PNG";  
$imageInfo->height = IMAGE_HEIGHT;  
$imageInfo->width = IMAGE_WIDTH;  			
			
// include Image in response?
// false = return URL of image
// true = return encoded binary image
$includeImageInResponse = false;

// create renderMap request ...
//$request = new renderMap();
$request = new renderMapBoundingBox();
//$request->MapSection_1 = $mapSection;
$request->BoundingBox_1 = $boundingBox;
$request->MapParams_2 = $mapParams;
$request->ImageInfo_3 = $imageInfo;
$request->boolean_5= $includeImageInResponse;

try { 
  $resultMessage = $xMap->renderMapBoundingBox($request);
}
catch (SoapFault $exception) { 
  print "<pre>";
  print_r($exception);
  print "</pre>";
}

$image_url = $resultMessage->result->image->url;
$image_url = (substr($image_url,0,7) != "http://") ? "http://".$image_url : $image_url;
$image_url = str_replace("localhost",HOST,$image_url);

$bounding_box = $resultMessage->result->visibleSection->boundingBox;
list($lox, $loy) = Mercator2GeoDecimal($bounding_box->leftTop->point->x, $bounding_box->leftTop->point->y, true);
list($rux, $ruy) = Mercator2GeoDecimal($bounding_box->rightBottom->point->x, $bounding_box->rightBottom->point->y, true);
list($mx, $my) = Mercator2GeoDecimal($resultMessage->result->visibleSection->center->point->x, $resultMessage->result->visibleSection->center->point->y, true);

if (SAVE_MAPS)
{ $time_soap = microtime(true);

  $PNG = new PNGChunk($image_url);
  $time_load = microtime(true);

  $PNG->add_tEXt("LOX", $lox);
  $PNG->add_tEXt("LOY", $loy);
  $PNG->add_tEXt("MX", $mx);
  $PNG->add_tEXt("MY", $my);
  $PNG->add_tEXt("RUX", $rux);
  $PNG->add_tEXt("RUY", $ruy);
  $PNG->add_tEXt("ZOOM", $z);

  $PNG->add_tEXt("INFO.MOMENT", date("d.m.Y - H:i:s"));
  $PNG->add_tEXt("INFO.VERSION", "TxOrtung Rev. " . VERSION);

  $PNG->add_tEXt("DAUER.SOAP", round( ($time_soap  - $time_start) * 1000.0, 1) . " ms");
  $PNG->add_tEXt("DAUER.GET", round( ($time_load  - $time_soap) * 1000.0, 1) . " ms");
  $PNG->add_tEXt("DAUER.PATCH", round( (microtime(true) - $time_load) * 1000.0, 1) . " ms");

  $PNG->add_tEXt("DAUER.GESAMT", round( (microtime(true)  - $time_start) * 1000.0, 1) . " ms");

  $PNG->savePicByURL(PATH_MAPS.$x.".".$y.".".$z.".png");
}

?>
<html>
<head>
<title>getmap.php5 Rev. <?php echo VERSION; ?></title>
</head>

<body style="font-family:Courier New; font-size:13px;">
<?php printf("<img src=\"%s\" style=\"border:solid #000000 2px; margin-bottom:10px;\">", $image_url); ?>
<br />
IMAGE=<?php echo $image_url; ?><br />
LOX=<?php echo $lox; ?><br />
LOY=<?php echo $loy; ?><br />
MX=<?php echo $mx; ?><br />
MY=<?php echo $my; ?><br />
RUX=<?php echo $rux; ?><br />
RUY=<?php echo $ruy; ?><br />
ZOOM=<?php echo $z; ?>
</body>
</html>
<?php
function Mercator2GeoMinSec($xIn, $yIn) 
{ $lambda = (180 / pi()) * ($xIn / 6371000.0 + 0.0);
  $phi = (180 / pi()) * (atan(exp($xIn / 6371000.0)) - (pi() / 4)) / 0.5;
  $xIn = $lambda;
  $yIn = $phi;
  
  $xIn = $xIn * 100000;
  $yIn = $yIn * 100000;
  
  if ($xIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $xIn = -$xIn;
  }
  
  $deg = round($xIn / 100000);
  $min = (($xIn / 100000) - $deg) * 60;
  $tmp = round($min);
  $sec = ($min - $tmp) * 600;
  $min = $tmp;
  $xIn = ($deg * 100000 + $min * 1000 + $sec) * $vz;
  
  if ($yIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $yIn = -$yIn;
  }
  
  $deg = round($yIn / 100000);
  $min = (($yIn / 100000) - $deg) * 60;
  $tmp = round($min);
  $sec = ($min - $tmp) * 600;
  $min = $tmp;
  $yIn = ($deg * 100000 + $min * 1000 + $sec) * $vz;
  
  $result[] = $xIn;
  $result[] = $yIn;

  return $result;
}



function XMercator2GeoDecimal($xIn, $round = false)
{ $lambda = (180 / pi()) * ($xIn / 6371000.0 + 0.0);
  $xIn = $lambda;
  $xIn = $xIn * 100000;
  $result = ($round) ? round($xIn) : $xIn;
  return $result;
}

function YMercator2GeoDecimal($yIn, $round = false)
{ $phi = (180 / pi()) * (atan(exp($yIn / 6371000.0)) - (pi() / 4)) / 0.5;
  $yIn = $phi;
  $yIn = $yIn * 100000; 
  $result = ($round) ? round($yIn) : $yIn; 
  return $result;
}

function Mercator2GeoDecimal($xIn, $yIn, $round = false)
{ $result = array();
  $result[] = XMercator2GeoDecimal($xIn, $round);
  $result[] = YMercator2GeoDecimal($yIn, $round);
  return $result;
}

function __Mercator2GeoDecimal($xIn, $yIn)
{ $result = array();

  $lambda = (180 / pi()) * ($xIn / 6371000.0 + 0.0);
  $phi = (180 / pi()) * (atan(exp($yIn / 6371000.0)) - (pi() / 4)) / 0.5;
  $xIn = $lambda;
  $yIn = $phi;
 
  $xIn = $xIn * 100000;
  $yIn = $yIn * 100000;
  
  $result[] = $xIn;
  $result[] = $yIn;
  
  return $result;
}



function GeoMinSec2Mercator($xIn, $yIn)
{ $result = array();

  if ($xIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $xIn = -$xIn;
  }
  $deg = round($xIn / 100000);
  $min = (($xIn / 100000) - $deg) * 100;
  $tmp = round($min);
  $sec = ($min - $tmp) * 100;
  $min = $tmp;
  $xIn = ($deg * 100000 + ($min * 60 + $sec) / 0.036) * $vz;
  
  if ($yIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $yIn = -$yIn;
  }
  
  $deg = round($yIn / 100000);
  $min = (($yIn / 100000) - $deg) * 100;
  $tmp = round($min); //
  $sec = ($min - $tmp) * 100;
  $min = $tmp;
  $yIn = ($deg * 100000 + ($min * 60 + $sec) / 0.036) * $vz;

  $xIn = $xIn / 100000;
  $yIn = $yIn / 100000;
 
  $lambda = $xIn;
  $phi = $yIn;
  $xIn = 6371000.0 * ((pi() / 180) * (($lambda) - 0.0));
  $yIn = 6371000.0 * log(tan((pi() / 4) + (pi() / 180) * $phi * 0.5));
 
  $result[] = $xIn;
  $result[] = $yIn;
 
  return $result;
}


function GeoMinSec2GeoDecimal($xIn, $yIn)
{ $result = array();

  if ($xIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $xIn = -$xIn;
  }
  
  $deg = round($xIn / 100000);
  $min = (($xIn / 100000) - $deg) * 100;
  $tmp = round($min);
  $sec = ($min - $tmp) * 100;
  $min = $tmp;
  $xArg = ($deg * 100000 + ($min * 60 + $sec) / 0.036) * $vz;
  
  if ($yIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $yIn = -$yIn;
  }
  $deg = round($yIn / 100000);
  $min = (($yIn / 100000) - $deg) * 100;
  $tmp = round($min);
  $sec = ($min - $tmp) * 100;
  $min = $tmp;
  $yIn = ($deg * 100000 + ($min * 60 + $sec) / 0.036) * $vz;
  
  $result[] = $xIn;
  $result[] = $yIn;

  return $result;
}


function XGeoDecimal2Mercator($xIn)
{ $xIn = $xIn / 100000;
  $lambda = $xIn;
  $result = 6371000.0 * ((pi() / 180) * (($lambda) - 0.0));
  return $result;
}


function YGeoDecimal2Mercator($yIn)
{ $yIn = $yIn / 100000;
  $phi = $yIn;
  $result = 6371000.0 * log(tan((pi() / 4) + (pi() / 180) * $phi * 0.5));
  return $result;
}

function GeoDecimal2Mercator($xIn, $yIn)
{ $result = array();
  $result[] = XGeoDecimal2Mercator($xIn);
  $result[] = YGeoDecimal2Mercator($yIn);
  return $result;
}

function __GeoDecimal2Mercator($xIn, $yIn)
{ $result = array();

  $xIn = $xIn / 100000;
  $yIn = $yIn / 100000;
  
  $lambda = $xIn;
  $phi = $yIn;
  $xIn = 6371000.0 * ((pi() / 180) * (($lambda) - 0.0));
  $yIn = 6371000.0 * log(tan((pi() / 4) + (pi() / 180) * $phi * 0.5));
  
  $result[] = $xIn;
  $result[] = $yIn;

  return $result;
}


function GeoDecimal2GeoMinSec($xIn, $yIn)
{ $result = array();
  
  if ($xIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $xIn = -$xIn;
  }
  $deg = round($xIn / 100000);
  $min = (($xIn / 100000) - $deg) * 60;
  $tmp = round($min);
  $sec = ($min - $tmp) * 600;
  $min = $tmp;
  $xIn = ($deg * 100000 + $min * 1000 + $sec) * $vz;
  
  if ($yIn >= 0)
  { $vz = 1;
  }
  else
  { $vz = -1;
    $yIn = -$yIn;
  }
  
  $deg = round($yIn / 100000);
  $min = (($yIn / 100000) - $deg) * 60;
  $tmp = round($min);
  $sec = ($min - $tmp) * 600;
  $min = $tmp;
  $yIn = ($deg * 100000 + $min * 1000 + $sec) * $vz;
 
  $result[] = $xIn;
  $result[] = $yIn;

  return $result;
}
?>

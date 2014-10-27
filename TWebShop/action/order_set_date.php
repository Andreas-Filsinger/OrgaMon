<?php

//Fehler: 
//1) wenn !isset($f_choice)
//2) wenn $f_choice == "complete" und !$f_date->isValid()
//3) wenn $f_choice == "complete" und date < cart->latest
//
//OK: 
//1) $f_choice == "soonest" und timestamp aus cart ODER
//2) $f_choice == "complete" und $f_date->isValid(), 
//dann jeweils weitermachen

if (isset($f_choice))
{ $session->registerTmpVar("choice_date",$f_choice,$shop->getCurrentSite());
  
  switch(true)
  { case($f_choice == "complete" AND !$_GLOBALS["f_date"]->isValid()):
    { break;
	}
	case($f_choice == "complete" AND strtotime($f_date) < $cart->getAvailability()->getLatest()):
	{ $errorlist->add(ERROR_INVALID_DATE);
	  break;
	}
	default:
    { $session->registerTmpVar("date",($f_choice == "complete") ? strtotime($f_date) : $cart->getAvailability()->getSoonest(),$shop->getCurrentSite());
	  $session->registerTmpVar("step",$session->getTmpVar("step",$shop->getCurrentSite()) + 1,$shop->getCurrentSite());
    }
  }
}
else
{ $errorlist->add(ERROR_NO_CHOICE_MADE);
}

?>
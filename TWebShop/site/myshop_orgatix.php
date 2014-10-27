<?php

if ($site->isActive()) 
{ //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");
 
  $template->setTemplates(array(torgatix::CLASS_NAME => _TEMPLATE_ORGATIX_MYSHOP_ORGATIX,
                                torgatix_ticket::CLASS_NAME => _TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX,
								torgatix_processor::CLASS_NAME => _TEMPLATE_ORGATIX_PROCESSOR_MYSHOP_ORGATIX));
  
  $orgatix = new torgatix();
  foreach($orgatix->getTickets() as $ticket)
  { $ticket->getInfo();
	$ticket->getAction();
    $ticket->addOption("AUTHOR", ($ticket->PERSON_R == $user->getID()) ? _TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_OPTION_AUTHOR : "");
	$ticket->addOption("EDIT", _TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_OPTION_EDIT);
  }
  
  $site->addComponent("OBJ_ORGATIX", $orgatix->getFromHTMLTemplate($template));
  
  unset($template);
  unset($orgatix); 
}

?>
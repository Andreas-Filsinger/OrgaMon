<?php

if ($site->isActive()) 
{ //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");

  $template->setTemplates(array(torgatix::CLASS_NAME => _TEMPLATE_ORGATIX_MYSHOP_ORGATIX_TICKET,
                                torgatix_ticket::CLASS_NAME => _TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_TICKET,
								torgatix_processor::CLASS_NAME => _TEMPLATE_ORGATIX_PROCESSOR_MYSHOP_ORGATIX_TICKET));
  
  $ticket = (isset($ticket)) ? $ticket : new torgatix_ticket($id);
  $orgatix = new torgatix();
  
  foreach($orgatix->getProcessors() as $processor)
  { $processor->addOption("SELECTED",($ticket->getProcessor()->getID() == $processor->getID()) ? "selected=\"selected\"" : "");
  }
 
  $ticket->addOption("AID","~AID~");
  $ticket->addOption("PRIORITY_" . $ticket->getPriorityLevel(), "checked=\"checked\"");
  $ticket->addOption("PROCESSOR", $orgatix->getFromHTMLTemplate($template));
  $ticket->getInfo();
  $ticket->getAction();
 
  $site->addComponent("OBJ_ORGATIX_TICKET", $ticket->getFromHTMLTemplate($template));
  //$site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
  
  unset($processor);
  unset($orgatix);
  unset($ticket); 
}

?>
<?php

$ticket = new torgatix_ticket($id);
$ticket->setAuthor($user->getID());
$ticket->setProcessor($f_orgatix_processor_id);
$ticket->setPriority($f_choice);
$ticket->setInfo($f_orgatix_ticket_info);
$ticket->setAction($f_orgatix_ticket_action);

if (!$errorlist->error) {
    if ($ticket->getID() == 0) {
        $result = $ticket->insertIntoDataBase();
    } else {
        $result = $ticket->updateInDataBase();
    }
    if ($result) {
        $messagelist->add(SENTENCE_TICKET_SAVED);
        $subsite = "orgatix";
        unset($ticket);
    } else {
        $errorlist->add(ERROR_TICKET_COULD_NOT_BE_SAVED);
        $subsite = "orgatix_ticket";
    }
} else {
    $subsite = "orgatix_ticket";
}
?>
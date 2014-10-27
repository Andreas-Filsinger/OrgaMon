<?php
if ($site->isActive()) { //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");
    $template->setTemplates(array(twebshop_order_state::CLASS_NAME => _TEMPLATE_ORDER_STATE_MYSHOP,
        twebshop_order_item::CLASS_NAME => _TEMPLATE_ORDER_STATE_MYSHOP_ORDER_ITEM));



    $order_state = new twebshop_order_state($user->getID());
    $site->addComponent("OBJ_ORDER_STATE", $order_state->getFromHTMLTemplate($template));

    unset($order_state);
}
?>
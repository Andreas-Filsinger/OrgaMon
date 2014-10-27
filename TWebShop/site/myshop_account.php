<?php
if ($site->isActive()) { //$site->appendTitle($site->getCurrentStep()->getTitle()," : ");
    $template->setTemplates(
            array(
        twebshop_person::CLASS_NAME => _TEMPLATE_PERSON_MYSHOP_ACCOUNT_BILLS,
        twebshop_user::CLASS_NAME => _TEMPLATE_PERSON_MYSHOP_ACCOUNT_BILLS,
        twebshop_bill::CLASS_NAME => _TEMPLATE_BILL_MYSHOP_ACCOUNT));

    // Prüfen, ob überhaupt Zeitabrechnungen 
    // vorliegen können;
    $anzahl = $ibase->get_field(
            "select count(RID) as ANZAHL from BUGET where (PERSON_R=" . $user->getID() . ")"
            , "ANZAHL");
    // echo "[" . $anzahl . "]<br>";	 
    if ($anzahl > 0) {
        // Zeitabrechnung neu erzeugen
        // echo "[Erstelle Zeitabrechnung]<br>";	 
        $orgamon->execAccounting(0, $user->getID());
    }

    // Liste der Rechnungen erzeugen
    $user->getBills();

    $tmp_account = new twebshop_account($user->getID());

    $site->addComponent("VAR_ORGAMON_ACCOUNT_INFO", $tmp_account->getFromHTMLTemplate(_TEMPLATE_ACCOUNT_MYSHOP_ACCOUNT));
    $site->addComponent("VAR_USER_MONITION_DOCUMENT", $cryption->encrypt($user->getMonitionDocument($orgamon->getSystemString(torgamon::BASEPLUG_BILL_PATH))));
    $site->addComponent("VAR_USER_BUDGET_DOCUMENT", $cryption->encrypt($user->getBudgetDocument($orgamon->getSystemString(torgamon::BASEPLUG_BILL_PATH))));
    $site->addComponent("OBJ_BILLS", $user->getFromHTMLTemplate($template));

    unset($tmp_account);
}
?>
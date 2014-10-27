<?php
if ($site->isActive()) {
    $site->addComponent("VAR_DATE_SOONEST", date("d.m.Y", $cart->getAvailability()->getSoonest()));
    $site->addComponent("VAR_DATE_LATEST", date("d.m.Y", $cart->getAvailability()->getLatest()));

    /*
     * Ausgabe des Datums im Eingabefeld (VAR_F_DATE)
     * Es gibt folgende Möglichkeiten:
     * + Die Seite wurde aufgrund einer Fehleingabe nicht verlassen (es wird eine Fehlermeldung ausgegeben):
     *   $f_date ist gesetzt, die Session enthält UNTER UMSTÄNDEN schon einen Wert
     *   VAR_F_DATE muss jedenfalls mit $f_date belegt werden.
     * + Die Seite wird beim Zurückblättern erneut besucht:
     *   $f_date ist NICHT gesetzt, aber die Session enthält bereits einen Wert
     *   Dieser Wert kann das Versendedatum für eine Teillieferung sein.
     *   VAR_F_DATE muss in diesem Falle wieder mit dem Versendedatum für den Komplettversand vorbelegt 
     *   werden: $cart->getAvailability()->getLatest() 
     *   Ansonsten muss VAR_F_DATE mit dem Wert aus der Session belegt werden. Dies ist anhand des Session-Eintrags choice_date 
     *   zu entscheiden.
     * + Die Seite wird zum ersten Mal aufgerufen (es wurde in diesem Bestellprozess noch kein Datum ausgewählt): 
     *   $f_date ist NICHT gesetzt, auch die Session enthält KEINEN Wert
     *   VAR_F_DATE wird mit dem Versendedatum für den Komplettversand vorbelegt: $cart->getAvailability()->getLatest()
     */

    $site->addComponent(
            "VAR_F_DATE", isset($f_date) ?
                    $f_date :
                    date("d.m.Y", ($session->isRegisteredTmp("choice_date", $shop->getCurrentSite()) AND
                            $session->getTmpVar("choice_date", $shop->getCurrentSite()) == "soonest") ?
                                    $cart->getAvailability()->getLatest() :
                                    $session->getTmpVar("date", $shop->getCurrentSite(), $cart->getAvailability()->getLatest())
                    )
    );

    $site->addComponent("VAR_F_CHOICE", $session->getTmpVar("choice_date", $shop->getCurrentSite(), ""));
}
?>
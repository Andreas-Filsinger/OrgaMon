<?php

    /*******************************************************************
     * Links                                                           *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Übersichtsseite über alle Verlage und Musiker                   *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 28.08.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    $site->setName("links");
    $site->setTitle(WORD_LINKS);
    $site->addToSiteMap();
    $site->loadTemplate(__TEMPLATE_PATH);

    if ($site->isActive()) {

        /* === Verlage === */
        $Publishers = "";
        $Publisher  = new twebshop_publisher();
        $Items      = $Publisher->getAllPublishers();

        foreach ($Items as $Item) {
            $Publishers .= "<a href=\"" . __INDEX . "?name=" . $Item['Url'] . "&site=search&action=search_publisher&id=" . $Item['Id'] . "\">" . $Item['Name'] . "</a><br>";
        }

        /* === Musiker === */
        $Musicians = "";
        $Musician  = new twebshop_musician();
        $Items     = $Musician->getAllMusicians();

        foreach ($Items as $Item) {
            $Musicians .= "<a href=\"" . __INDEX . "?name=" . $Item['Url'] . "&site=search&action=search_musician&id=" . $Item['Id'] . "\">" . $Item['Name'] . "</a><br>";
        }

        /* === Eintragen === */
        $site->addComponent("OBJ_PUBLISHER_LIST", $Publishers);
        $site->addComponent("OBJ_MUSICIAN_LIST",  $Musicians);

    }

?>

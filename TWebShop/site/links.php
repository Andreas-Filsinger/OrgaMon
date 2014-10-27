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
        $PublisherList = "";
        $Publishers = new twebshop_publishers();
        $Ids        = $Publishers->getIds();

        foreach ($Ids as $Id) {
            $Publisher = new twebshop_publisher($Id);
            $PublisherList .= "<a href=\"" . $Publisher->createLink() . "\">" . $Publisher->SUCHBEGRIFF . "</a><br>";
            unset($Publisher);
        }

        /* === Musiker === */
        $MusicianList = "";

        $Musicians = new twebshop_musicians();
        $Ids       = $Musicians->getIds();

        foreach ($Ids as $Id) {
            $Musician = new twebshop_musician($Id);
            $MusicianList .= "<a href=\"" . $Musician->createLink() . "\">" . $Musician->NACHNAME . " " . $Musician->VORNAME . "</a><br>";
            unset($Musician);
        }

        /* === Eintragen === */
        $site->addComponent("OBJ_PUBLISHER_LIST", $PublisherList);
        $site->addComponent("OBJ_MUSICIAN_LIST",  $MusicianList);

    }

?>

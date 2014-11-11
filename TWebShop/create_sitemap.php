<?php

    /*******************************************************************
     * Create Sitemap Runtime                                          *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Spezielles Runtimeskript zum Starten der Sitemaperzeugung über  *
     * eine Aktion auf der Kommandozeile per Cronjob                   *
     *                                                                 *
     * Anm: Für eine schönere Lösung wären einige Änderungen notwendig *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 10.11.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    include_once("config.php");

    $_SERVER['HTTP_HOST'] = SHOP_WWW;
    $_SERVER['PHP_SELF']  = "";

    chdir(SHOP_ROOT);
    parse_str("site=sitemap&action=create_static_sitemap", $_GET);

    include "shop.php";

?>

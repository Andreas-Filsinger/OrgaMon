<?php

    /*******************************************************************
     * Action Create Static Sitemap                                    *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Erzeugen der statischen Sitemap mit einer Sitemapindex bei mehr *
     * als 50000 Links.                                                *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 10.11.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    define("MAX_LINKS", 50000);

    $Links = array();

    /* === Artikel ermitteln === */
    $Articles = new twebshop_articles();
    $Ids      = $Articles->getIds();

    foreach ($Ids as $Id) {
        $Article = new twebshop_article($Id);
        $Links[] = $Article->createLink();
        unset($Article);
    }

    unset($Articles);
    
    /* === Musiker ermitteln === */
    $Musicians = new twebshop_musicians();
    $Ids       = $Musicians->getIds();

    foreach ($Ids as $Id) {
        $Musician = new twebshop_musician($Id);
        $Links[]  = $Musician->createLink();
        unset($Musician);
    }

    unset($Musicians);

    /* === Verlage ermitteln === */
    $Publishers = new twebshop_publishers();
    $Ids        = $Publishers->getIds();

    foreach ($Ids as $Id) {
        $Publisher = new twebshop_publisher($Id);
        $Links[]   = $Publisher->createLink();
        unset($Publisher);
    }
    
    unset($Publishers);
  
    /* === Sitemaps erstellen === */
    $fp    = NULL;
    $Step  = 0;
    $Count = 1;

    foreach ($Links as $Link) {

        /* --- Sitemapmaximum beachten --- */
        if ($Step == MAX_LINKS) {
        
            $Count++;
            $Step = 0;
            
            fwrite($fp, "</urlset>\n");
            fclose($fp);

            $fp = NULL;

        }

        /* --- Neue Sitemap starten --- */
        if (!$fp) {

            $fp = fopen(SHOP_SITEMAP_DIR . "urls_" . $Count . ".xml", "w");

            fwrite($fp, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            fwrite($fp, "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");

        }

        /* --- Eintrag hinzufügen --- */
        fwrite($fp, " <url>\n");
        fwrite($fp, "  <loc>" . $Link . "</loc>\n");
        fwrite($fp, " </url>\n");

        $Step++;

    }
    
    if ($fp) {
        fwrite($fp, "</urlset>\n");
        fclose($fp);
    }
    
    /* === Sitemapindex erstellen === */
    $fp = fopen(SHOP_SITEMAP_DIR . "index.xml", "w");
    
    fwrite($fp, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    fwrite($fp, "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");

    for ($i = 1; $i <= $Count; $i++) {
        fwrite($fp, " <sitemap>\n");
        fwrite($fp, "  <loc>" . path() . SHOP_SITEMAP_DIR . "urls_" . $i . ".xml</loc>\n");
        fwrite($fp, "  <lastmod>" . date('Y-m-d\TH:i:s+00:00') . "</lastmod>\n");
        fwrite($fp, " </sitemap>\n");
    }

    fwrite($fp, "</sitemapindex>\n");
    fclose($fp);

?>
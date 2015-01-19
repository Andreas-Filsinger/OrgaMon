<?php

    /*******************************************************************
     * Action Download Part                                            *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Löst einen Download der Stimme aus, ohne den genauen Pfad der   *
     * Datei preis zu geben.                                           *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 14.01.2015 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    $Nr   = $_GET['nr'];
    $Part = $_GET['part'];
    
    /* === Dateinamen erstellen === */
    $Filename = SHOP_PARTS_DIR . $Nr . "-Stimme" . $Part . "-0.pdf";

    /* === Download starten === */
    if (file_exists($Filename)) {
    
        header("Content-Type: application/pdf");
        header("Content-Disposition: attachment; filename=\"" . $Nr . "_" . $Part . ".pdf\"");
        
        readfile($Filename);

        exit();

    }

?>
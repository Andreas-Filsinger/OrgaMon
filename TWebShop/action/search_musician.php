<?php

    /*******************************************************************
     * Nach Musiker suchen                                             *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Suche nach einem Komponisten oder Arrangeur                     *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 28.08.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    if (!isset($sid))
    { $sid = $search->getNextID();
    }

    $Fields = array("ARRANGEUR_R", "KOMPONIST_R");

    $search->doSearch($sid, "searchArticleFields", array("fields" => $Fields, "id" => $id));
    $messagelist->add($search->getHits() . " " . WORD_HITS);

?>
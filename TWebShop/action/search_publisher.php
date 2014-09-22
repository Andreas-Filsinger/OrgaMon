<?php

    /*******************************************************************
     * Nach Publisher suchen                                           *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Suche nach einem Verlag                                         *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 22.08.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    if (!isset($sid))
    { $sid = $search->getNextID();
    }

    $Fields = array("VERLAG_R");

    $search->doSearch($sid, "searchArticleFields", array("fields" => $Fields, "id" => $id));
    $messagelist->add($search->getHits() . " " . WORD_HITS);

?>
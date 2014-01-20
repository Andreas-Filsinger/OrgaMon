<?php
$site->setName("promo_pakets");
$site->setTitle(WORD_CATALOGUES);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {

    $result = $ibase->query("SELECT M.MASTER_R AS RID, A.TITEL AS TITEL, A.ERSTEINTRAG FROM " . TABLE_ARTICLE_MEMBER . " AS M JOIN " .
            TABLE_ARTICLE . " AS A ON (M.MASTER_R=A.RID) AND ((A.WEBSHOP='J') OR (A.WEBSHOP is null)) 
				 WHERE M.CONTEXT_R=" . TWEBSHOP_ARTICLE_CONTEXT_R_PROMO . " GROUP BY M.MASTER_R, A.TITEL, A.ERSTEINTRAG ORDER BY A.ERSTEINTRAG DESC");

    $promo_pakets = "";
    $_year = "";
    while ($data = $ibase->fetch_object($result)) {
        $id = intval($data->RID);
        $year = substr($data->ERSTEINTRAG, 6, 4);
        $thumbs = twebshop_article::getArticleThumbs($id);

        $tmp_promo_paket = new twebshop_article_link(twebshop_article::encryptRID($id), $data->TITEL, "");
        $tmp_promo_paket->addOption("THUMB", (count($thumbs) > 0) ? str_replace("~THUMB~", $thumbs[0], _TEMPLATE_ARTICLE_LINK_PROMO_PAKETS_OPTION_THUMB) : "");
        $tmp_promo_paket->addOption("SID", $search->getNextID());

        if ($year != $_year) {
            $promo_pakets.= str_replace("~YEAR~", $year, $site->_TEMPLATE_YEAR);
            $_year = $year;
        }
        $promo_pakets.= $tmp_promo_paket->getFromHTMLTemplate(_TEMPLATE_ARTICLE_LINK_PROMO_PAKETS);

        unset($id);
        unset($year);
        unset($tmp_promo_paket);
    }
    $ibase->free_result($result);
    $site->addComponent("OBJ_PROMO_PAKETS", $promo_pakets);

    unset($_year);
    unset($promo_pakets);
}
?>
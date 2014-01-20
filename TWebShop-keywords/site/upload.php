<?php
$site->setName("upload");
$site->setTitle("Artikel-Upload \"Die Blasmusik\"");
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {
    $deadline = mktime(23, 59, 59, date("n"), 15, date("Y"));
    $month = (($deadline - time()) > 0) ? (intval(date("m")) + 1) : (intval(date("m")) + 2);

    $site->addComponent("VAR_NEXT_ACTION_ID", $shop->getNextActionID());
    $site->addComponent("VAR_F_ASSOCIATION", isset($f_association) ? $f_association : "");
    $site->addComponent("VAR_F_MEMBER", isset($f_member) ? $f_member : "");
    $site->addComponent("VAR_F_EDITION", isset($f_edition) ? $f_edition : "");
    $site->addComponent("VAR_F_AUTHOR", isset($f_author) ? $f_author : "");
    $site->addComponent("VAR_F_USER", isset($f_user) ? $f_user : "");
    $site->addComponent("VAR_F_TEXT", isset($f_text) ? $f_text : "");
    $site->addComponent("VAR_MONTH", $month);
    $site->addComponent("VAR_MAX_FILE_SIZE", intval(ini_get("upload_max_filesize")));
    $site->addComponent("VAR_MAX_POST_SIZE", intval(ini_get("post_max_size")));

    unset($deadline);
    unset($month);
}
?>

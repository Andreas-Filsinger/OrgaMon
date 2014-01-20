<?php
$site->setName("sitemap");
$site->setTitle(WORD_SITEMAP);
$site->loadTemplate(__TEMPLATE_PATH);

if ($site->isActive()) {

    $this_site = clone($site);
    $map = array();
    $site_files = file_search("site");
    foreach ($site_files as $site_file) {
        $site = new tsite("");
        $site->deactivate();
        include("./site/" . $site_file);
        $last_index = "";
        if ($site->onSiteMap()) {
            $index = substr(strtoupper($site->getTitle()), 0, 1);
            $map[ucwords($site->getTitle())] = "<a href=\"" . __INDEX . "?site={$site->getName()}\">{$site->getTitle()}</a>";
            if ($index != $last_index) {
                $map[$index] = "<b>$index</b>";
            }
        }
    }

    ksort($map);
    //var_dump($map);

    $site = clone($this_site);
    unset($this_site);

    $site->addComponent("OBJ_MAP", implode("<br />", $map));
}
?>

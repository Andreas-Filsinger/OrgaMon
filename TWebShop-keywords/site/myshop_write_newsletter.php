<?php

if (!defined("DEBUG_MODE"))
    define("DEBUG_MODE", false);
if (!defined("__IMAGES_PATH"))
    define("__IMAGES_PATH", "");
if (!defined("EMAILS_TEST"))
    define("EMAILS_TEST", "");

if ($site->isActive()) { //INSERT BUTTONS VORBEREITEN
    $tags_javascript = "";
    $tags_buttons = "";
    foreach ($_TAGS as $index => $property) {
        $tags_javascript.="  _CODE['$index'] = '" . $property["CODE"] . "';\r\n";
        $tags_buttons.="<input type=\"button\" class=\"insertButton\" onClick=\"javascript:insertCode('$index'," . $property["VALUE_REPLACED_BY_SELECTED_TEXT"] . ");\" value=\"" . $property["NAME"] . "\" title=\"" . htmlentities($property["TEMPLATE"]) . "\">\r\n";
    }

    //BILDER
    $images = array();
    if (is_dir(__IMAGES_PATH)) {
        $image_files = file_search(__IMAGES_PATH);
        foreach ($image_files as $image_filename) {
            $image_file = __IMAGES_PATH . $image_filename;
            list($width, $height) = getimagesize($image_file);
            $images[] = "<a rel=\"lightbox[images]\" href=\"$image_file\" target=\"_blank\" title=\"$image_filename ({$width}x{$height}px)\">$image_filename</a>&nbsp;({$width}x{$height}px)&nbsp;[&nbsp;<a href=\"javascript:insertText('$image_file');\"><b>einfügen</b></a>&nbsp;]";
        }
        $images = implode(", ", $images);
    } else {
        $images = "Pfadangabe " . __IMAGES_PATH . " ungültig.";
    }


    /*
      //TEST-EMPFÄNGER
      $test_recipients = "";
      $i = 0;
      foreach(explode(",",EMAILS_TEST) as $test_email)
      { $i++;
      $test_recipients.="<option value=\"$test_email\"" . (($i == 1) ? " selected" : "") . ">$test_email</option>\r\n";
      }
      //$test_recipients.="<option value=\"" . EMAILS_TEST . "\">Alle</option>";

      //RECIPIENT CHECKBOX LIST
      //$emails = file_search("./","^emails[a-zA-Z0-9_.]*.txt$");
      $recipient_checkbox_list = "";
      if (is_dir(MOD_NEWSLETTER_LISTS_PATH))
      { $lists = file_search(MOD_NEWSLETTER_LISTS_PATH,"^[a-zA-Z0-9_.]*.txt$");
      asort($lists);
      //var_dump($lists);
      foreach($lists as $list)
      { //$tmp_txt = ucwords(implode(" ",explode("_",substr(substr($email_txt,0,-4),7))));
      $tmp_count = count(preg_split("/(\r*\n+)+/",file_get_contents(MOD_NEWSLETTER_LISTS_PATH.$list)));
      $tmp_txt = ucwords(implode(" ",explode("_",substr($list,0,-4))));
      $recipient_checkbox_list.="<input type=\"checkbox\" name=\"addressbook[]\" value=\"" . MOD_NEWSLETTER_LISTS_PATH . $list . "\"" . (($list == MOD_NEWSLETTER_DEFAULT_LIST) ? " checked=\"checked\"" : "") . ">&nbsp;<a href=\"" . MOD_NEWSLETTER_LISTS_PATH . $list . "\" target=\"_blank\">$tmp_txt</a>&nbsp;($tmp_count Adressen)<br />\r\n";
      unset($tmp_count);
      unset($tmp_txt);
      }
      }
      else
      { $recipient_check_box_list = "Pfadangabe " . MOD_NEWSLETTER_LISTS_PATH . " ungültig";
      }

      $debug_mode = (DEBUG_MODE) ? "DEBUG MODE!!!" : "";

     */

    $site->addComponent("VAR_F_SUBJECT", isset($f_subject) ? $f_subject : "");
    $site->addComponent("VAR_F_TEXT", isset($f_text) ? $f_text : "");
    //$site->addComponent("VAR_DEBUG_MODE",$debug_mode);
    $site->addComponent("OBJ_TAGS_JAVASCRIPT", $tags_javascript);
    $site->addComponent("OBJ_TAGS_BUTTONS", $tags_buttons);
    $site->addComponent("OBJ_IMAGES", $images);
    //$site->addComponent("OBJ_TEST_RECIPIENTS",$test_recipients);
    //$site->addComponent("OBJ_RECIPIENT_CHECKBOX_LIST",$recipient_checkbox_list); 
}
?>
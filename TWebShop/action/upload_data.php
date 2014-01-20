<?php
if (!$errorlist->error) {
    $path = MOD_UPLOAD_SAVE_PATH . $f_edition . "/" . $f_association . "/";
    $info = "path=$path\r\nauthor=$f_author\r\nemail=$f_user";
    if (($id = torgamon::createEvent(torgamon_event::eT_BenutzerTextUpload, $info)) != false) {
        $result = true;

        $dirs = explode("/", $f_edition . "/" . $f_association . "/" . $id);
        $path = "";
        foreach ($dirs as $dir) {
            $path = $path . $dir . "/";
            if (!is_dir(MOD_UPLOAD_SAVE_PATH . $path)) {
                $result = $result AND mkdir(MOD_UPLOAD_SAVE_PATH . $path);
            }
        }

        unset($dir);
        unset($dirs);

        $path = MOD_UPLOAD_SAVE_PATH . $path;

        if ($result) {
            $file = str_replace("/", "-", $f_edition) . "-" . $f_member;
            $result = $result AND file_put_contents($path . $file . "-t.txt", $f_text);
            $result = $result AND file_put_contents($path . $file . "-a.txt", "$f_author\r\n$f_user");

            $files = array();
            $j = 0;
            for ($i = 0; $i < count($_FILES['f_photo']['name']); $i++) {
                $tmp_file = $_FILES['f_photo']['tmp_name'][$i];
                if (is_uploaded_file($tmp_file)) {
                    $j++;
                    $extension = file_extension($_FILES['f_photo']['name'][$i], 0, 1);
                    if (move_uploaded_file($tmp_file, $path . $file . "-" . $j . $extension)) {
                        $files[] = $j . ") " . $_FILES['f_photo']['name'][$i] . " (" . $_FILES['f_photo']['size'][$i] . " bytes)";
                    }
                    else
                        $result = false;
                }
            }
            $result = $result AND file_put_contents($path . $file . "-p.txt", implode("\r\n", $files));
        }

        if ($result) {
            $messagelist->add("Die Daten wurden auf dem Server gespeichert.");
            $subject = "Freischaltung Ihrer Veröffentlichung in Die Blasmusik";
            $body = load_txt(__LANGUAGE_PATH . __LANGUAGE . "/upload-confirmation-email.txt", false, true) . CRLF . __PATH . "?action=upload_confirmation&f_user=$f_user&id=$id";
            if (torgamon::sendMail($f_user, $subject, $body) != false) {
                $messagelist->add(load_txt(__LANGUAGE_PATH . __LANGUAGE . "/upload-confirmation-message.txt", false, true));
            }
        }
    }

    unset($info);
    unset($path);
}
?>
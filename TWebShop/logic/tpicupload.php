<?php

class twebshop_tpicupload extends tpicupload {

    const CLASS_NAME = "PHP5CLASS TWEBSHOP_TPICUPLOAD";

    static public function getThumbFileName($id) {
        return self::$path . sprintf("%08d", $id) . "th.jpg";
    }

    static public function getImageFileName($id) {
        return self::$path . sprintf("%08d", $id) . ".jpg";
    }

}
?>
<?php
define("TPICUPLOAD_DEFAULT_PATH", "");
define("TPICUPLOAD_DEFAULT_MAX_THUMB_WIDTH", 80);
define("TPICUPLOAD_DEFAULT_THUMB_RESIZE_SHORT_EDGE", false);
define("TPICUPLOAD_DEFAULT_MAX_ORIGINAL_WIDTH", 640);
define("TPICUPLOAD_DEFAULT_ORIGINAL_RESIZE_SHORT_EDGE", false);

define("TPICUPLOAD_MODE_GET_UPLOAD_INFO", 1);
define("TPICUPLOAD_MODE_NEW_FOLDER", 2);
define("TPICUPLOAD_MODE_NEW_PICTURE", 3);
define("TPICUPLOAD_MODE_FINISH", 4);

define("TPICUPLOAD_MESSAGE_OK", "200 OK\r\n");
define("TPICUPLOAD_MESSAGE_ERROR", "400 ERROR\r\n");
define("TPICUPLOAD_MESSAGE_ACCESS_DENIED", "Access denied. Check UserID and Password");
define("TPICUPLOAD_MESSAGE_INVALID_PICTURE_FORMAT", "Invalid picture format (width/height).");

define("TPICUPLOAD_VALUE_MAX_THUMB_WIDTH", "MaxThumbWidth=~MAX_THUMB_WIDTH~\r\n");
define("TPICUPLOAD_VALUE_THUMB_RESIZE_SHORT_EDGE", "ThumbResizeShortEdge=~THUMB_RESIZE_SHORT_EDGE~\r\n");
define("TPICUPLOAD_VALUE_MAX_ORIGINAL_WIDTH", "MaxOriginalWidth=~MAX_ORIGINAL_WIDTH~\r\n");
define("TPICUPLOAD_VALUE_ORIGINAL_RESIZE_SHORT_EDGE", "OriginalResizeShortEdge=~ORIGINAL_RESIZE_SHORT_EDGE~\r\n");
define("TPICUPLOAD_VALUE_FOLDERS", "Folders=~FOLDERS~\r\n");

class tpicupload {

    static protected $path = TPICUPLOAD_DEFAULT_PATH;
    protected $folders = true;
    protected $max_thumb_width = TPICUPLOAD_DEFAULT_MAX_THUMB_WIDTH;
    protected $max_original_width = TPICUPLOAD_DEFAULT_MAX_ORIGINAL_WIDTH;
    protected $thumb_resize_short_edge = TPICUPLOAD_DEFAULT_THUMB_RESIZE_SHORT_EDGE;
    protected $original_resize_short_edge = TPICUPLOAD_DEFAULT_ORIGINAL_RESIZE_SHORT_EDGE;
    protected $mode = 0;
    public $square = true;
    protected $login_required = true;
    public $output = "";
    protected $params = array(
        "user" => NULL,
        "pass" => NULL,
        "filename" => NULL,
        "thumb" => NULL,
        "original" => NULL,
        "newfolder" => NULL,
        "fid" => NULL,
        "description" => NULL,
        "finished" => NULL
    );
    protected $user_funcs = array(
        "login_user" => "tpicupload_login_user",
        "get_folders" => "tpicupload_get_folders",
        "new_folder" => "tpicupload_new_folder",
        "new_picture" => "tpicupload_new_picture",
        "finish_upload" => "tpicupload_finish"
    );

    const CLASS_NAME = "PHP5CLASS TPICUPLOAD";

    public function __construct($max_thumb_width = TPICUPLOAD_DEFAULT_MAX_THUMB_WIDTH, $max_original_width = TPICUPLOAD_DEFAULT_MAX_ORIGINAL_WIDTH, $folders = true, $login_required = true) {
        $this->max_thumb_width = $max_thumb_width;
        $this->max_original_width = $max_original_width;
        $this->folders = $folders;
        $this->login_required = $login_required;
        $this->getParams();
    }

    protected function getParams() {
        $_GETNPOST = array_merge($_GET, $_POST);
        $this->params["user"] = (isset($_GETNPOST["user"])) ? $_GETNPOST["user"] : NULL;
        $this->params["pass"] = (isset($_GETNPOST["pass"])) ? $_GETNPOST["pass"] : NULL;
        $this->params["newfolder"] = (isset($_GETNPOST["newfolder"])) ? $_GETNPOST["newfolder"] : NULL;
        $this->params["fid"] = (isset($_GETNPOST["fid"])) ? $_GETNPOST["fid"] : NULL;
        $this->params["description"] = (isset($_GETNPOST["description"])) ? $_GETNPOST["description"] : NULL;
        $this->params["filename"] = (isset($_GETNPOST["filename"])) ? $_GETNPOST["filename"] : NULL;
        $this->params["original"] = (isset($_FILES["original"])) ? $_FILES["original"] : NULL;
        $this->params["thumb"] = (isset($_FILES["thumb"])) ? $_FILES["thumb"] : NULL;
        $this->params["finished"] = (isset($_GETNPOST["finished"])) ? true : false;
        //file_put_contents("php_error.log", implode("; ",array_keys($_GETNPOST))."\r\n", FILE_APPEND);
        unset($_GETNPOST);
    }

    public function isLoginRequired() {
        return $this->login_required;
    }

    public function setLoginRequired($login_required = true) {
        $this->login_required = $login_required;
    }

    public function setThumbResizeShortEdge($resize_short_edge = false) {
        $this->thumb_resize_short_edge = $resize_short_edge;
    }

    public function setOriginalResizeShortEdge($resize_short_edge = false) {
        $this->original_resize_short_edge = $resize_short_edge;
    }

    public function getMode() {
        switch (true) {
            case($this->params["user"] == NULL AND $this->params["pass"] == NULL): {
                    $this->mode = TPICUPLOAD_MODE_GET_UPLOAD_INFO;
                    break;
                }
            case($this->params["user"] != NULL AND $this->params["pass"] != NULL AND
            $this->params["newfolder"] != NULL AND $this->params["fid"] != NULL): {
                    $this->mode = TPICUPLOAD_MODE_NEW_FOLDER;
                    break;
                }
            case($this->params["user"] != NULL AND $this->params["pass"] != NULL AND
            $this->params["thumb"] != NULL AND $this->params["original"] != NULL AND
            $this->params["filename"] != NULL AND $this->params["fid"] != NULL AND
            $this->params["newfolder"] == NULL): {
                    $this->mode = TPICUPLOAD_MODE_NEW_PICTURE;
                    break;
                }
            case($this->params["user"] != NULL AND $this->params["pass"] != NULL AND $this->params["finished"] == true): {
                    $this->mode = TPICUPLOAD_MODE_FINISH;
                    break;
                }
        }
        return $this->mode;
    }

    public function setFolders($folders) {
        $this->folders = $folders;
    }

    public function setUserFunc($name, $user_func) {
        if (array_key_exists($name, $this->user_funcs)) {
            $this->user_funcs[$name] = $user_func;
            $result = true;
        } else {
            $result = false;
        }
        return $result;
    }

    protected function getUserFunc($name, $user_func) {
        return ($user_func == "") ? $this->user_funcs[$name] : $user_func;
    }

    public function getUploadInfo($folders = array()) {
        return TPICUPLOAD_MESSAGE_OK .
                str_replace("~MAX_THUMB_WIDTH~", $this->max_thumb_width, TPICUPLOAD_VALUE_MAX_THUMB_WIDTH) .
                str_replace("~THUMB_RESIZE_SHORT_EDGE~", bool2str($this->thumb_resize_short_edge), TPICUPLOAD_VALUE_THUMB_RESIZE_SHORT_EDGE) .
                str_replace("~MAX_ORIGINAL_WIDTH~", $this->max_original_width, TPICUPLOAD_VALUE_MAX_ORIGINAL_WIDTH) .
                str_replace("~ORIGINAL_RESIZE_SHORT_EDGE~", bool2str($this->original_resize_short_edge), TPICUPLOAD_VALUE_ORIGINAL_RESIZE_SHORT_EDGE) .
                str_replace("~FOLDERS~", ($this->folders) ? "yes" : "no", TPICUPLOAD_VALUE_FOLDERS) .
                implode("\r\n", $folders);
    }

    public function loginUser($user_func = "") {
        $user_func = $this->getUserFunc("login_user", $user_func);
        $result = call_user_func($user_func, $this->params);
        return $result->value;
    }

    public function newFolder($user_func = "") {
        $user_func = $this->getUserFunc("new_folder", $user_func);
        $result = new tpicupload_user_func_result();
        if (!$this->login_required XOR $this->loginUser()) {
            $result = call_user_func($user_func, $this->params);
        } else {
            $result->addMessage(TPICUPLOAD_MESSAGE_ACCESS_DENIED);
        }
        return ($result->value) ? (TPICUPLOAD_MESSAGE_OK . $result . "\r\n") : (TPICUPLOAD_MESSAGE_ERROR . $result . "\r\n");
    }

    public function newPicture($user_func = "") {
        $user_func = $this->getUserFunc("new_picture", $user_func);
        $result = new tpicupload_user_func_result();
        if (!$this->login_required XOR $this->loginUser()) {
            if ($this->isValidThumbFormat($this->params["thumb"]["tmp_name"], $this->square) AND $this->isValidOriginalFormat($this->params["original"]["tmp_name"], $this->square)) {
                $result = call_user_func($user_func, $this->params);
            } else {
                $result->addMessage(TPICUPLOAD_MESSAGE_INVALID_PICTURE_FORMAT);
            }
        } else {
            $result->addMessage(TPICUPLOAD_MESSAGE_ACCESS_DENIED);
        }
        return ($result->value) ? (TPICUPLOAD_MESSAGE_OK . $result . "\r\n") : (TPICUPLOAD_MESSAGE_ERROR . $result . "\r\n");
    }

    public function finishUpload($user_func = "") {
        $user_func = $this->getUserFunc("finish_upload", $user_func);
        $result = new tpicupload_user_func_result();
        if (!$this->login_required XOR $this->loginUser()) {
            $result = call_user_func($user_func, $this->params);
        } else {
            $result->addMessage(TPICUPLOAD_MESSAGE_ACCESS_DENIED);
        }
        return ($result->value) ? (TPICUPLOAD_MESSAGE_OK . $result . "\r\n") : (TPICUPLOAD_MESSAGE_ERROR . $result . "\r\n");
    }

    public function isValidThumbFormat($picture, $square = true) {
        return self::isValidPictureFormat($picture, $this->max_thumb_width, $square, $this->thumb_resize_short_edge);
    }

    public function isValidOriginalFormat($picture, $square = true) {
        return self::isValidPictureFormat($picture, $this->max_original_width, $square, $this->original_resize_short_edge);
    }

    static public function setPath($path = "") {
        self::$path = ($path == "") ? TPICUPLOAD_DEFAULT_PATH : $path;
    }

    static public function getPath() {
        return self::$path;
    }

    static public function buildFileName($prefix = "", $postfix = "") {
        return $prefix . time() . "_" . sprintf("%04d", rand(0, 1000)) . $postfix;
    }

    static public function isValidPictureFormat($picture, $max, $square = true, $short = false) {
        list($width, $height, $type, $attr) = getimagesize($picture);
        $result = true;
        do {
            if ($square AND ($width == $height) AND ($width == $max) AND ($height == $max))
                break; //Quadrat (short ist egal)
            if (($width > $height) AND //Querformat &&
                    ( (!$short AND ($width == $max) AND ($height <= $max)) OR //lange Seite(width) muss stimmen, also: width= und height<= ||
                    ($short AND ($height == $max) AND ($width >= $max))     //kurze Seite(height) muss stimmen, also: height= und width>=
                    )
            )
                break;
            if (($width < $height) AND //Hochformat &&
                    ( (!$short AND ($height == $max) AND ($width <= $max)) OR //lange Seite(height) muss stimmen, also: height= und width<= ||
                    ($short AND ($width == $max) AND ($height >= $max))     //kurze Seite(width) muss stimmen, also: width= und height>=
                    )
            )
                break;
            $result = false;
        } while (false);
        $result = $result AND ($type == 2); //&& JPG
        return $result;

        /* return ( ($square AND ($width == $height) AND ($width == $max) AND ($height == $max)) //Quadrat (short ist egal)
          OR
          ( ($width > $height) AND //Querformat &&
          ( (!$short AND ($width == $max) AND ($height <= $max)) OR //lange Seite(width) muss stimmen, also: width= und height<= ||
          ($short AND ($height == $max) AND ($width >=$max))      //kurze Seite(height) muss stimmen, also: height= und width>=
          )
          )
          OR
          ( ($width < $height) AND //Hochformat &&
          ( (!$short AND ($height == $max) AND ($width <= $max)) OR //lange Seite(height) muss stimmen, also: height= und width<= ||
          ($short AND ($width == $max) AND ($height >= $max))     //kurze Seite(width) muss stimmen, also: width= und height>=
          )
          )
          )
          AND ($type == 2); //&& JPG */
    }

}

class tpicupload_user_func_result {

    public $value = false;
    public $messages = array();

    const CLASS_NAME = "PHP5CLASS TPICUPLOAD_USER_FUNC_RESULT";

    public function __construct($value = false) {
        $this->value = $value;
    }

    public function addMessage($message) {
        $this->messages[] = $message;
    }

    public function __toString() {
        return implode(";", $this->messages);
    }

}
?>
<?php
define("T_CRYPT_ID_DEFAULT_KEY", "");
define("T_CRYPT_ID_DEFAULT_FILE", "id.sig");

class tcryptID {

    static private $instance = NULL;
    private $key = "";
    private $init = "\0\0\0\0\0\0\0\0";
    private $ID = 0;
    private $str = "";

    const CLASS_NAME = "PHP5CLASS T_CRYPT_ID";

    private function __construct($key) {
        $this->key = ($key == "") ? $this->readKeyFromFile(T_CRYPT_ID_DEFAULT_FILE) : $key;
        $this->initiate();
    }

    static public function create($key = T_CRYPT_ID_DEFAULT_KEY) {
        if (!self::$instance) {
            self::$instance = new tcryptID($key);
        }
        return self::$instance;
    }

    private function initiate() {
        $i = "\0\0\0\0\0\0\0\0";
        $this->init = mcrypt_encrypt(MCRYPT_BLOWFISH, $this->key, $i, MCRYPT_MODE_ECB, $i);
    }

    public function readKeyFromFile($file) {
        if (file_exists($file)) {
            $this->key = file_get_contents($file);
        }
        return $this->key;
    }

    public function encrypt($id) {
        $this->ID = $id;
        $str = self::IDToStr($id);
        $str = mcrypt_cfb(MCRYPT_BLOWFISH, $this->key, $str, MCRYPT_ENCRYPT, $this->init);
        $str = base64_encode($str);
        // $str = urlencode($str); // URLENCODE kann in Formularen nicht benutzt werden, wird sonst doppelt codiert
        return $str;
    }

    public function decrypt($str) {
        $this->str = $str;
        // URLDECODE wird von PHP oder APACHE erledigt, DARF NICHT mehr durchgeführt werden
        $id = base64_decode($str);
        $id = mcrypt_cfb(MCRYPT_BLOWFISH, $this->key, $id, MCRYPT_DECRYPT, $this->init);
        $id = self::StrToID($id);
        return $id;
    }

    public function getID() {
        return $this->ID;
    }

    public function getString() {
        return $this->Str;
    }

    static public function IDToStr($id) {
        $result = "";
        for ($i = 0; $i < 8; $i++) {
            $lowerbyte = ($id & 255);
            $result .= chr($lowerbyte);
            $id = $id >> 8;
        }
        return $result;
    }

    static public function StrToID($str) {
        $result = 0;
        if (strlen($str) == 8) {
            for ($l = 7; $l >= 0; $l--) {
                $result = $result << 8;
                $result = $result + ord($str[$l]);
            }
        }
        return intval($result);
    }

    public function __wakeup() {
        self::$instance = $this;
    }

    public function __toString() {
        return self::CLASS_NAME;
    }

}
?>
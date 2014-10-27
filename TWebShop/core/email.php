<?php
if (!defined("CRLF"))
    define("CRLF", "\r\n");
if (!defined("LF"))
    define("LF", "\n");

class temail {

    private $headers = array();
    private $return_path = "";
    public $text;
    public $html = false;
    public $plain;
    public $images;
    public $attachment;
    private $crlf = CRLF;
    private $boundary = "";
    private $text_is_set = false;
    private $html_is_set = false;
    private $plain_is_set = false;
    private $html_images = false;
    private $attachment_is_set = false;

    const BASE64_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const CLASS_NAME = "PHP5CLASS TEMAIL";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct() {
        $this->header = new temail_header();
    }

    public function setCRLF($crlf = "\n\r") {
        $this->crlf = $crlf;
    }

    public function getCRLF() {
        return $this->crlf;
    }

    public function setReturnPath($value) {
        $this->return_path = $value;
    }

    public function setFrom($value) {
        $this->headers["From"] = $value;
    }

    public function setSender($value) {
        $this->headers["Sender"] = $value;
    }

    public function setReplyTo($value) {
        $this->headers["Reply-To"] = $value;
    }

    private function setRecipients($value, $type) {
        if (isset($this->headers[$type])) {
            $this->headers[$type].= self::serializeEmails($value);
        }
        else
            $this->headers[$type] = self::serializeEmails($value);
    }

    private function getRecipients($type) {
        return (isset($this->headers[$type])) ? $this->headers[$type] : array();
    }

    public function setTo($value) {
        $this->setRecipients($value, "To");
    }

    public function getTo() {
        return $this->getRecipients("To");
    }

    public function setCC($value) {
        $this->setRecipients($value, "Cc");
    }

    public function getCC() {
        return $this->getRecipients("Cc");
    }

    public function setBCC($value) {
        $this->setRecipients($value, "Bcc");
    }

    public function getBCC() {
        return $this->getRecipients("Bcc");
    }

    public function addRecipients($value, $type, $unique = false) {
        if (!isset($this->headers[$type])) {
            $this->headers[$type] = array();
        }
        if (is_string($value)) {
            $value = preg_split("/(\r*\n+[ ]*\t*)*(,|;){1}(\r*\n+[ ]*\t*)*/", $value);
        }
        $this->headers[$type] = array_merge($this->headers[$type], $value);
        if ($unique) {
            $this->headers[$type] = array_unique($this->headers[$type]);
        }
    }

    public function addTo($value) {
        $this->addRecipients($value, "To");
    }

    public function addCC($value) {
        $this->addRecipients($value, "Cc");
    }

    public function addBCC($value) {
        $this->addRecipients($value, "Bcc");
    }

    function setSubject($value = "Kein Betreff") {
        $this->headers["Subject"] = $value;
    }

    function setDate($value = 0) { // Absendedatum im Format Weekday, DD-Mon-YY HH:MM:SS TIMEZONE 
        if ($value == 0)
            $date = date("D, d M Y H:i:s") . " GMT";
        else
            $date = $value;
        $this->headers['Date'] = $date;
    }

    function setComments($value) {
        $this->headers['Comments'] = $value;
    }

    function setKeywords($value) {
        $this->headers['Keywords'] = $value;
    }

    function setText($text) {
        $this->text = $text;
        $this->text_is_set = true;
    }

    function getInlineImages() {
        $images = self::getHTMLTagAttributeValues($this->html, "IMG", "SRC");
        foreach ($images as $image) {
            if (parse_url($image, PHP_URL_SCHEME) != "") {
                $images = array_diff($images, array($image));
            }
        }
        return $images;
    }

    function __getInlineImages() {
        $images = ($this->html) ? array_unique(self::getHTMLTagAttributeValues($this->html, "IMG", "SRC")) : array();
        return $images;
    }

    function getBackgroundImages() { //$styles = html_get_field($this->html, "", "STYLE");
        //var_dump($styles);
        $styles = array();
        return $styles;
    }

    function setHTML($html) {
        if ($this->text_is_set === false) {
            $this->text = "Diese Nachricht enthaelt HTML.";
        }
        $this->html = $html;
        if ($this->plain_is_set === false) {




            $this->plain = strip_tags(br2nl($html, $this->crlf));
        }
        $this->images = array_unique(array_merge($this->getInlineImages(), $this->getBackgroundImages()));
        //var_dump($this->images);
        if ($this->images !== false) {
            $this->html_images = true;
        }
        $this->html_is_set = true;
    }

    function setPlain($plain) {
        $this->plain = $plain;
        $this->plain_is_set = true;
    }

    function setAttachment($filename) {
        if (file_exists($filename)) {
            $this->attachment[] = $filename;
            $this->attachment_is_set = true;
            if (($this->text_is_set === false) AND ($this->text == "")) {
                $this->text = "Diese Nachricht enthaelt Dateianhaenge.";
            }
        }
    }

    private function crlf($n = 1) {
        $c = '';
        for ($i = 0; $i < $n; $i++) {
            $c.= $this->crlf;
        }
        return $c;
    }

    private function createCID() {
        return md5(microtime());
    }

    private function createBoundary($name = "MailPart") {
        return "----=_" . ucfirst($name) . "_" . md5(microtime());
    }

    private function getMimeHeader() {
        switch (true) {
            case ((!$this->html_is_set) AND (!$this->html_images) AND (!$this->attachment_is_set)) : {
                    $mimetype = "text";
                    $subtype = "plain";
                    $type = "";
                    $boundary = "";
                    break;
                }
            case ((!$this->html_is_set) AND (!$this->html_images) AND ($this->attachment_is_set)) : {
                    $mimetype = "multipart";
                    $subtype = "mixed";
                    $type = "";
                    $boundary = $this->createBoundary($subtype);
                    break;
                }
            case (($this->html_is_set) AND (!$this->html_images) AND (!$this->attachment_is_set)) : {
                    $mimetype = "multipart";
                    $subtype = "alternative";
                    $type = "";
                    $boundary = $this->createBoundary($subtype);
                    break;
                }
            case (($this->html_is_set) AND (!$this->html_images) AND ($this->attachment_is_set)) : {
                    $mimetype = "multipart";
                    $subtype = "mixed";
                    $type = "multipart/alternative";
                    $boundary = $this->createBoundary($subtype);
                    break;
                }
            case (($this->html_is_set) AND ($this->html_images) AND (!$this->attachment_is_set)) : {
                    $mimetype = "multipart";
                    $subtype = "related";
                    $type = "multipart/alternative";
                    $boundary = $this->createBoundary($subtype);
                    break;
                }
            case (($this->html_is_set) AND ($this->html_images) AND ($this->attachment_is_set)) : {
                    $mimetype = "multipart";
                    $subtype = "mixed";
                    $type = "multipart/related";
                    $boundary = $this->createBoundary($subtype);
                    break;
                }
        }
        $mime_header['MIME-Version'] = "1.0";
        $mime_header['Content-Type'] = $mimetype . "/" . $subtype;
        if ($type != "") {
            $mime_header['Content-Type'] .= ";" . $this->crlf . "\ttype=\"" . $type . "\"";
        }
        if ($boundary != "") {
            $mime_header['Content-Type'] .= ";" . $this->crlf . "\tboundary=\"" . $boundary . "\"";
        }
        $mime_header['Content-Transfer-Encoding'] = "7bit";

        if ($this->boundary == "")
            $this->boundary = $boundary;
        return $mime_header;
    }

    public function getHeader() {
        $header = "";
        switch (true) {
            case($this->return_path != ""): {
                    $header = "Return-Path: <" . $this->return_path . ">" . $this->crlf;
                    break;
                }
            case(isset($this->headers['From']) AND is_string($this->headers['From'])): {
                    $header = "Return-Path: <" . $this->headers['From'] . ">" . $this->crlf;
                    break;
                }
            case(isset($this->headers['Sender']) AND is_string($this->headers['Sender'])): {
                    $header = "Return-Path: <" . $this->headers['Sender'] . ">" . $this->crlf;
                    break;
                }
        }
        foreach ($this->headers as $key => $value) {
            if (is_array($value)) {
                $value = implode("," . $this->crlf . "\t", $value);
            }
            $header .= $key . ": " . $value . $this->crlf;
        }
        foreach ($this->getMimeHeader() as $key => $value) {
            $header .= $key . ": " . $value . $this->crlf;
        }
        return $header;
    }

    public function getBody() {
        $body = wordwrap($this->text, 75, $this->crlf) . $this->crlf(2);
        if ($this->boundary != "") {
            if ($this->html_is_set) {
                $body .= "--" . $this->boundary . $this->crlf;
                $body .= "~NextPart~" . $this->crlf(2);
            }
            if ($this->attachment_is_set) {
                for ($i = 0; $i < count($this->attachment); $i++) {
                    $body.= "--" . $this->boundary . $this->crlf;
                    $body.= "~AttachedPart" . $i . "~" . $this->crlf(2);
                }
            } else if ($this->html_images) {
                for ($i = 0; $i < count($this->images); $i++) {
                    $body.= "--" . $this->boundary . $this->crlf;
                    $body.= "~ImagePart" . $i . "~" . $this->crlf(2);
                }
            }
            $body .= "--" . $this->boundary . "--";

            switch (true) {
                case (($this->html_is_set) AND ($this->html_images) AND ($this->attachment_is_set)): {
                        $boundary = $this->create_boundary("related");
                        $nextpart = "Content-Type: multipart/related; " . $this->crlf;
                        $nextpart.= "\ttype=\"multipart/alternative\";" . $this->crlf;
                        $nextpart.= "\tboundary=\"" . $boundary . "\"" . $this->crlf;
                        $nextpart.= $this->crlf;
                        $nextpart.= "--" . $boundary . $this->crlf;
                        $nextpart.= "~NextPart~" . $this->crlf(2);
                        for ($i = 0; $i < count($this->images); $i++) {
                            $nextpart.= "--" . $boundary . $this->crlf;
                            $nextpart.= "~ImagePart" . $i . "~" . $this->crlf(2);
                        }
                        $nextpart.= "--" . $boundary . "--";
                        $body = str_replace("~NextPart~", $nextpart, $body);
                    }
                case (($this->html_is_set) AND ($this->html_images)): {
                        $boundary = $this->createBoundary("alternative");
                        $nextpart = "Content-Type: multipart/alternative; " . $this->crlf;
                        $nextpart.= "\tboundary=\"" . $boundary . "\"" . $this->crlf;
                        $nextpart.= $this->crlf;
                        $nextpart.= "--" . $boundary . $this->crlf;
                        $nextpart.= "~PlainPart~" . $this->crlf(2);
                        $nextpart.= "--" . $boundary . $this->crlf;
                        $nextpart.= "~HtmlPart~" . $this->crlf(2);
                        $nextpart.= "--" . $boundary . "--";
                        $body = str_replace("~NextPart~", $nextpart, $body);
                    }
                case (($this->html_is_set) AND (!$this->html_images) AND ($this->attachment_is_set)): {
                        $boundary = $this->createBoundary("alternative");
                        $nextpart = "Content-Type: multipart/alternative; " . $this->crlf;
                        $nextpart.= "\tboundary=\"" . $boundary . "\"" . $this->crlf;
                        $nextpart.= $this->crlf;
                        $nextpart.= "--" . $boundary . $this->crlf;
                        $nextpart.= "~PlainPart~" . $this->crlf(2);
                        $nextpart.= "--" . $boundary . $this->crlf;
                        $nextpart.= "~HtmlPart~" . $this->crlf(2);
                        $nextpart.= "--" . $boundary . "--";
                        $body = str_replace("~NextPart~", $nextpart, $body);
                    }
                case (($this->html_is_set) AND (!$this->html_images)): {
                        $nextpart.= "~PlainPart~" . $this->crlf(2);
                        $nextpart.= "--" . $this->boundary . $this->crlf;
                        $nextpart.= "~HtmlPart~";
                        $body = str_replace("~NextPart~", $nextpart, $body);
                    }
            }

            if ($this->html_is_set) {
                $plainpart = "Content-Type: text/plain;charset=utf-8" . $this->crlf;
                $plainpart.= "Content-Transfer-Encoding: 8bit" . $this->crlf(2);
                $plainpart.= wordwrap($this->plain, 75, $this->crlf);

                $htmlpart = "Content-Type: text/html;charset=utf-8" . $this->crlf;
                $htmlpart.= "Content-Transfer-Encoding: quoted-printable" . $this->crlf(2);
                $html = $this->html;
                if ($this->html_images) {
                    for ($i = 0; $i < count($this->images); $i++) {
                        $cid[$i] = $this->createCID();
                        $html = str_replace($this->images[$i], "cid:" . $cid[$i], $html);
                    }
                }
                $htmlpart.= self::encodeQuotedPrintable($html, $this->crlf);
            }

            if ($this->html_images) {
                for ($i = 0; $i < count($this->images); $i++) {
                    $imagepart[$i] = "Content-Type: " . self::getCTT($this->images[$i]) . $this->crlf;
                    $imagepart[$i].= "Content-Transfer-Encoding: base64" . $this->crlf;
                    $imagepart[$i].= "Content-ID: <" . $cid[$i] . ">" . $this->crlf;
                    $imagepart[$i].= "Content-Disposition: inline" . $this->crlf(2);
                    $imagepart[$i].= self::encodeBase64(file_get_contents($this->images[$i]), $this->crlf);
                }
            }

            if ($this->attachment_is_set) {
                for ($i = 0; $i < count($this->attachment); $i++) {
                    $ctt = getCTT($this->attachment[$i]);
                    if (strtoupper(substr($ctt, 0, 4)) == "TEXT") {
                        $cte = "quoted-printable";
                        $encoded = self::encodeQuotedPrintable(file_get_contents($this->attachment[$i]), $this->crlf);
                    } else {
                        $cte = "base64";
                        $encoded = self::encodeBase64(file_get_contents($this->attachment[$i]), $this->crlf);
                    }
                    $attachedpart[$i] = "Content-Type: " . $ctt . $this->crlf;
                    $attachedpart[$i].= "Content-Transfer-Encoding: " . $cte . $this->crlf;
                    // $attachedpart[$i].= "Content-ID: <" . $cid[$i] . ">" . $this->crlf;
                    $attachedpart[$i].= "Content-Disposition: attachment; filename=\"" . $this->attachment[$i] . "\"" . $this->crlf(2);
                    $attachedpart[$i].= $encoded;
                }
            }

            $body = str_replace("~PlainPart~", $plainpart, $body);
            $body = str_replace("~HtmlPart~", $htmlpart, $body);
            for ($i = 0; $i < count($this->images); $i++) {
                $body = str_replace("~ImagePart" . $i . "~", $imagepart[$i], $body);
            }
            for ($i = 0; $i < count($this->attachment); $i++) {
                $body = str_replace("~AttachedPart" . $i . "~", $attachedpart[$i], $body);
            }
        }
        return $body;
    }

    public function mailByPHP() {
        return mail($this->headers['To'], $this->headers['Subject'], $this->get_body(), $this->get_header());
    }

    public function mailBySMTP() {

        return true;
    }

    public function writeToEMLFile($filename) {
        return file_put_contents($filename, $this->getHeader() . $this->crlf . $this->getBody());
    }

    static public function serializeeMails($emails, $separator = ",") {
        if (is_string($emails))
            $emails = preg_split("/(\r*\n+[ ]*\t*)*(,|;){1}(\r*\n+[ ]*\t*)*/", $emails);
        var_dump($emails);
        for ($i = 0; $i < count($emails); $i++) {
            $emails[$i] = trim($emails[$i]);
        }
        $result = implode($separator . " " . LF . "\t", $emails);
        return $result;
    }

    static public function encodeQuotedPrintable($data, $crlf = "\r\n") {
        $escape = "=";
        $encoded = "";

        $lines = preg_split("/\r?\n/", $data);
        reset($lines);

        foreach ($lines as $line) {
            $length = strlen($line);
            $eline = "";

            for ($i = 0; $i < $length; $i++) {
                $c = $line[$i];
                $dec = ord($c);

                switch (true) {
                    case (($dec == 32) OR ($dec == 9)) : {
                            if ($i == ($length) - 1)
                                $c = $escape . strtoupper(sprintf("%02s", dechex($dec)));
                            break;
                        }
                    case (($dec > 126) OR ($dec < 32) OR ($dec == 61)) : {
                            $c = $escape . strtoupper(sprintf("%02s", dechex($dec)));
                            break;
                        }
                } // switch

                if ((strlen($eline) + strlen($c)) >= 76) {
                    $encoded .= $eline . $escape . $crlf;
                    $eline = "";
                }

                $eline .= $c;
            }
            $encoded .= $eline . $crlf;
        }
        $encoded = substr($encoded, 0, (-1) * strlen($crlf));
        return $encoded;
    }

    static public function encodeBase64($data, $crlf = "\r\n") {
        $base64_alphabet = self::BASE64_ALPHABET;
        $escape = "=";
        $encoded = "";
        $eline = "";

        $bitstream = "";
        for ($i = 0; $i < strlen($data); $i++) {
            $c = $data[$i];
            $dec = ord($c);
            $_8bits = sprintf("%08s", decbin($dec));
            $bitstream .= $_8bits;
        }

        $_6bitpacks = (int) (strlen($bitstream) / 6);
        $finalpack = (int) (strlen($bitstream) % 6);
        for ($i = 0; $i < $_6bitpacks; $i++) {
            $_6bits = substr($bitstream, $i * 6, 6);
            $eline .= $base64_alphabet[bindec($_6bits)];
            if (($i + 1) % 76 == 0) {
                $encoded .= $eline . $crlf;
                $eline = "";
            }
        }

        $lastbits = substr($bitstream, -$finalpack);
        $_6bits = $lastbits;
        $escapes = "";
        while (strlen($_6bits) < 6) {
            $_6bits .= "00";
            $escapes .= $escape;
        }

        $eline .= $base64_alphabet[bindec($_6bits)] . $escapes;
        $encoded .= $eline;
        return $encoded;
    }

    static public function convertHTMLToPlain($html) {
        $plain = $html;

        //Titel ermitteln
        $title = "";
        $p = strpos(strtoupper($plain), "<TITLE>", 0);
        if ($p !== false) {
            $o = strpos(strtoupper($plain), "</TITLE>", $p);
            if ($o !== false) {
                $title = substr($plain, $p + 7, $o - $p - 7);
            }
        }

        //$plain = preg_replace("/(<\/?)(\w+)([^>]*>)/e","'\\1'.strtolower('\\2').'\\3'",$plain);
        //$plain = preg_replace("/(<a)(\w+)(href=(\w+))(\w+)([^>]*>)(\w+)(<\/a[^>]*>)/e","'\\7'['\\4'",$plain);
        $plain = preg_replace("/(<a\s*(.*?)\s*href=['\"]+?\s*(?P<link>\S+)\s*['\"]+?\s*(.*?)\s*>\s*(?P<name>\S+)\s*<\/a>)/i", "$3<##$5##>", $plain);

        echo "*$title*";

        //$plain = html_entity_decode(strip_tags($html));

        return $plain;
    }

    static private function getHTMLTagAttributeValues($html, $tag, $attribute) {
        $j = 0;
        $tags = preg_split("/>/", $html);
        $values = array();
        for ($i = 0; $i < count($tags); $i++) {
            $tags[$i] = trim($tags[$i]);
            $p = strpos(strtoupper($tags[$i]), "<" . strtoupper($tag), 0);
            if ($p !== false) {
                $a = strpos(strtoupper($tags[$i]), strtoupper($attribute), 0);
                if ($a !== false) {
                    $a = strpos($tags[$i], "=\"", $a);
                    $o = strpos($tags[$i], "\" ", $a);
                    if ($o === false)
                        $value = substr($tags[$i], $a);
                    else
                        $value = substr($tags[$i], $a + 1, $o - $a);
                    $values[$j] = preg_replace("/(\")?/", "", $value);
                    //echo "*$value*";
                    //echo $tags[$i];
                    $j++;
                }
            }
        }
        return $values;
    }

    static private function getCTT($filename) {
        switch (file_extension($filename, true, true)) { // TEXT
            case(".ASC") : $ctt = "text/plain";
                break;
            case(".TXT") : $ctt = "text/plain";
                break;
            case(".C") : $ctt = "text/plain";
                break;
            case(".CC") : $ctt = "text/plain";
                break;
            case(".H") : $ctt = "text/plain";
                break;
            case(".HH") : $ctt = "text/plain";
                break;
            case(".CPP") : $ctt = "text/plain";
                break;
            case(".HPP") : $ctt = "text/plain";
                break;
            case(".PHP") : $ctt = "text/plain";
                break;
            case(".HTML") : $ctt = "text/html";
                break;
            case(".HTM") : $ctt = "text/html";
                break;
            case(".CSS") : $ctt = "text/css";
                break;
            // APPLICATION
            case(".XLS") : $ctt = "application/excel";
                break;
            case(".CSV") : $ctt = "application/excel";
                break;
            case(".DOC") : $ctt = "application/msword";
                break;
            case(".DOT") : $ctt = "application/msword";
                break;
            case(".WRD") : $ctt = "application/msword";
                break;
            case(".PDF") : $ctt = "application/pdf";
                break;
            case(".PGP") : $ctt = "application/pgp";
                break;
            case(".AI") : $ctt = "application/postscript";
                break;
            case(".EPS") : $ctt = "application/postscript";
                break;
            case(".PS") : $ctt = "application/postscript";
                break;
            case(".RTF") : $ctt = "application/rtf";
                break;
            case(".GZ") : $ctt = "application/x-gzip";
                break;
            case(".TAR") : $ctt = "application/x-tar";
                break;
            case(".ZIP") : $ctt = "application/zip";
                break;
            // IMAGE
            case(".GIF") : $ctt = "image/gif";
                break;
            case(".PNG") : $ctt = "image/png";
                break;
            case(".JPEG") : $ctt = "image/jpeg";
                break;
            case(".JPG") : $ctt = "image/jpeg";
                break;
            case(".JPE") : $ctt = "image/jpeg";
                break;
            case(".TIFF") : $ctt = "image/tiff";
                break;
            case(".TIF") : $ctt = "image/tiff";
                break;
            // AUDIO
            case(".AU") : $ctt = "audio/basic";
                break;
            case(".SND") : $ctt = "audio/basic";
                break;
            case(".MIDI") : $ctt = "audio/midi";
                break;
            case(".MID") : $ctt = "audio/midi";
                break;
            case(".KAR") : $ctt = "audio/midi";
                break;
            case(".MPGA") : $ctt = "audio/mpeg";
                break;
            case(".MP2") : $ctt = "audio/mpeg";
                break;
            case(".MP3") : $ctt = "audio/mpeg";
                break;
            case(".RA") : $ctt = "audio/x-pn-realaudio";
                break;
            case(".RAM") : $ctt = "audio/x-pn-realaudio";
                break;
            case(".RPM") : $ctt = "audio/x-pn-realaudio-plugin";
                break;
            case(".WAV") : $ctt = "audio/x-wav";
                break;

            default : $ctt = "application/octet-stream";
                break;
        }
        return $ctt;
    }

}

class temail_header {

    private $to = "";
    private $cc = "";
    private $bcc = "";
    private $from = "";
    private $sender = "";
    private $return_path = "";
    private $reply_to = "";

    const CLASS_NAME = "PHP5CLASS TEMAIL_HEADER";

    protected $_CLASS_NAME = self::CLASS_NAME;

    public function __construct() {
        
    }

    public function addBCC($bcc) {
        
    }

    public function getBCCString() {
        
    }

}
?>
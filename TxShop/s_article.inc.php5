<?php
$article = new twebshop_article($id);
//$article->getAll();
$article->getComposer();
$article->getArranger();
$article->price->setHTMLTemplate($_TEMPLATE_PRICE_ARTICLE);
$article->addOption("CART",$_TEMPLATE_ARTICLE_ARTICLE_OPTION_CART);

$mp3player = tmp3player::create($_TEMPLATE_MP3PLAYER);
$mp3player->setConfigXML("./tmp/".session_id()."_config.xml.php5");
$mp3player->setConfigXMLTemplate("./swf/template.config.xml");
$mp3player->setSWFPath("./swf/");
$mp3player->setMP3Path(MP3_PATH);
$mp3player->setUserID(session_id());
$mp3player->setInfo($article->TITEL);

if ($mp3player->setPlaylist($article->getSounds(MP3_PATH)))
{ ?>
<script language="JavaScript" type="text/javascript">
<!--
var hasReqestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);
// requiredMajorVersion, requiredMinorVersion, requiredRevision sind in h_header.inc.php5 zu finden
if (!hasReqestedVersion) 
{ var UpdateHint = 
  '<span style="color:#CC0000; font-weight:bold;"><?php echo SENTENCE_FLASH_UPDATE . 
              "<a href=\"http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash\" target=\"_blank\">" . 
			  image_tag(__PNG_PATH."download_flash.png",HINT_DOWNLOAD_FLASH,"vertical-align:middle; margin-left:5px;") . 
			  "</a>"; 
  ?></span>'
    document.write(UpdateHint);
}
// -->
</script>
<noscript>
<?php echo SENTENCE_JAVASCRIPT_DISABLED . SENTENCE_FLASH_CHECK_NOT_POSSIBLE; ?>
</noscript>

<?php
  $mp3player->makeConfigXML();
  $player = $mp3player->getFromHTMLTemplate();
  $hint = "<a href=\"http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash\" target=\"_blank\">" . 
          image_tag(__PNG_PATH."download_flash.png",HINT_DOWNLOAD_FLASH,"vertical-align:middle; margin-right:5px;") . 
          "</a><span class=\"smallblack\">" . SENTENCE_FLASH_REQUIRED . "</span>";
} 
else
{ $player = "";
  $hint = "";
}

echo str_replace("~PLAYER~",$player,$article->getFromHTMLTemplate($_TEMPLATE_ARTICLE_ARTICLE));
echo $hint;

unset($article);
unset($mp3player);
?>
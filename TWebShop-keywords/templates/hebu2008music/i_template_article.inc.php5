<?php

// ARTIKEL-TEMPLATE FÜR DIE SUCHTREFFER
define("_TEMPLATE_ARTICLE_SEARCH",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"<div class=\"left\"><a name=\"~NUMERO~\" href=\"" . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"<div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"search_body_left\"><p><b>" .
WORD_COMPOSER . ":</b>&nbsp;~COMPOSER~</p><p><b>" .
WORD_ARRANGER . ":</b>&nbsp;~ARRANGER~</p><p><b>" .
WORD_DURATION . ":</b>&nbsp;~DAUER~</p></div>" . CRLF .
"<div class=\"search_body_middle\"><p><b>" .
WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p><p><b>" .
WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p><p><b>" .
WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p></div>" . CRLF .
"<div class=\"search_body_right\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"article_options\">~OPTION_DETAILS~~OPTION_MINISCORE~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF . 
"</div><div class=\"clear\"></div>" . CRLF
);

// TEMPLATE FÜR OPTION INFO IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_DETAILS",
"<a href=\"" . __INDEX . "?site=article&id=~RID~\">" . WORD_DETAILS . image_tag(__TEMPLATE_IMAGES_PATH."option_details.png",WORD_DETAILS) . "</a>"
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_CART",
"<a href=\"" . __INDEX . "?site=~SITE~&action=add_to_cart&aid=~AID~&id=~RID~#~NUMERO~\">" . nbsp(SENTENCE_INTO_CART) . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_cart.png",SENTENCE_ADD_TO_CART) . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO",
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . WORD_DEMOS . image_tag(__TEMPLATE_IMAGES_PATH."option_demo.png",WORD_DEMO) . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&aid=~AID~&id=~RID~#~NUMERO~\">" . WORD_MINISCORE . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore.png",SENTENCE_SEND_MINISCORE) . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . WORD_RECORDS . image_tag(__TEMPLATE_IMAGES_PATH."option_record.png",SENTENCE_SEARCH_RECORDS) . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IN DER SUCHTREFFERANSICHT
define("_TEMPLATE_ARTICLE_SEARCH_OPTION_MP3",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&aid=~AID~&vid=~VERSION_MP3~&id=~RID~#~NUMERO~\">" . nbsp(SENTENCE_BUY_MP3_DOWNLOAD) . image_tag(__TEMPLATE_IMAGES_PATH."option_buy_mp3.png",SENTENCE_BUY_MP3_DOWNLOAD) . "</a>"
);



// ARTIKEL-TEMPLATE FÜR DIE ARTIKEL-EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><h1>~TITEL~</h1>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"  <p><b>" . WORD_COMPOSER . ":</b>&nbsp;~COMPOSER~</p>" . CRLF .
"  <p><b>" . WORD_ARRANGER . ":</b>&nbsp;~ARRANGER~</p>" . CRLF .
"  <p><b>" . WORD_DURATION . ":</b>&nbsp;~DAUER~</p><hr>" . CRLF .
"  <p><b>" . WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p>" . CRLF .
"  <p><b>" . WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p>" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p><hr>" . CRLF .
"  <p>~BEM~</p><!--~PUBLISHER~--><hr>" . CRLF .
"  <p>~MEMBERS~</p><hr>" . CRLF .
"  <p id=\"article_options\">~OPTION_MINISCORE~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~</p>" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_CART",
_TEMPLATE_ARTICLE_SEARCH_OPTION_CART
);

// TEMPLATE FÜR OPTION DEMO IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_DEMO",
_TEMPLATE_ARTICLE_SEARCH_OPTION_DEMO
);

// TEMPLATE FÜR OPTION MINISCORE IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_MINISCORE",
_TEMPLATE_ARTICLE_SEARCH_OPTION_MINISCORE
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_RECORDS",
_TEMPLATE_ARTICLE_SEARCH_OPTION_RECORDS
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_THUMB",
_TEMPLATE_ARTICLE_SEARCH_OPTION_THUMB
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IN DER EINZELANSICHT
define("_TEMPLATE_ARTICLE_ARTICLE_OPTION_MP3",
_TEMPLATE_ARTICLE_SEARCH_OPTION_MP3
);


// ARTIKEL-TEMPLATE FÜR DEN EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART",
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><p>~POSITION~.</p>&nbsp;~OPTION_DETAILS~&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>Stück:&nbsp;~QUANTITY~x</b>&nbsp;&nbsp;<b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"<form id=\"~UID~\" action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"  <input type=\"hidden\" name=\"site\" value=\"cart\" />" . CRLF .
"  <input type=\"hidden\" name=\"action\" value=\"update_cart\" />" . CRLF .
"  <input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"uid\" value=\"~UID~\" />" . CRLF .
"  <!-- <p class=\"hint\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~ --><!-- &nbsp;|&nbsp;~PUBLISHER~ --><!-- </p> -->" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p>" . CRLF .
"  <p id=\"article_options\">" . SENTENCE_CHANGE_QUANTITY . CRLF .
"    <input id=\"quantity\" type=\"text\" class=\"minimal\" name=\"f_quantity\" value=\"~QUANTITY~\" size=\"1\" maxlength=\"2\" style=\"vertical-align:baseline; text-align:center; margin-bottom:5px;\" onblur=\"submit();\" />~OPTION_REFRESH~" . CRLF .
"    ~OPTION_DELETE~" . CRLF .
"  </p>" . CRLF .
"  <p>~OPTION_VERSION~&nbsp;~OPTION_COPY~</p>" . CRLF .
"</form>" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<script type=\"text/javascript\"> checkDetail('~UID~'); </script>" . CRLF
);

// TEMPLATE FÜR OPTION DETAILS ANZEIGEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DETAILS",
"<a href=\"" . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>"
);

// TEMPLATE FÜR OPTION AKTUALISIEREN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_REFRESH",
"<input type=\"image\" class=\"imageasbutton\" src=\"" . __TEMPLATE_IMAGES_PATH . "option_refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:middle; height:auto; margin-right:10px; background:none;\">"
);

// TEMPLATE FÜR OPTION LÖSCHEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DELETE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=delete_from_cart&aid=~AID~&uid=~UID~\">" . SENTENCE_DELETE_FROM_CART . image_tag(__TEMPLATE_IMAGES_PATH."option_delete.png",SENTENCE_DELETE_FROM_CART,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_DEMO",
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_demo_blue.png",WORD_DEMO,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore_blue.png",SENTENCE_SEND_MINISCORE,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_record_blue.png",SENTENCE_SEARCH_RECORDS,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION KOPIEREN IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_COPY",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&id=~RID~&vid=~VERSION_R~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_copy.png",SENTENCE_COPY_ARTICLE_VERSION,"vertical-align:middle; margin-right:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IM EINKAUFSWAGEN
define("_TEMPLATE_ARTICLE_CART_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

// TEMPLATE FÜR OPTION AUSGABEART IM EINKAUFSWAGEN - AUSGABEART ÖFFENTLICH
define("_TEMPLATE_ARTICLE_CART_OPTION_VERSION_PUBLIC",
"~VERSION~"
);

// TEMPLATE FÜR OPTION AUSGABEART IM EINKAUFSWAGEN - AUSGABEART NICHT ÖFFENTLICH / NICHT VERÄNDERBAR
define("_TEMPLATE_ARTICLE_CART_OPTION_VERSION_NOT_PUBLIC",
"<b>~VERSION~</b>" . CRLF . "<input type=\"hidden\" name=\"f_version_r\" value=\"~VERSION_R~\">" . CRLF
);

// ARTIKEL-TEMPLATE FÜR DIE BESTELLÜBERSICHT
define("_TEMPLATE_ARTICLE_ORDER",
"<tr>" . CRLF .
"<td style=\"border-bottom:1px solid #000000;\">~NUMERO~</td> " . CRLF .
"<td style=\"border-bottom:1px solid #000000;\">~TITEL~<br /><span class=\"smallgrey\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~<!-- &nbsp;|&nbsp;~PUBLISHER~ --></span></td>" . CRLF .
"<td style=\"border-bottom:1px solid #000000;\">~VERSION~</td>" . CRLF .
"<td style=\"border-bottom:1px solid #000000;\">~QUANTITY~</td>" . CRLF .
"<td style=\"border-bottom:1px solid #000000;\">~PRICE~</td></tr>" . CRLF
);



// TEMPLATE FÜR EMAIL MELDUNG BROKEN LINK
define("_TEMPLATE_ARTICLE_BROKEN_LINK_EMAIL",
SYS_WORD_ARTICLE_ID . ": ~RID_INT~" . CRLF . WORD_TITLE . ": ~TITEL~"
);


// ARTIKEL-TEMPLATE FÜR DEN NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER",
"<!-- ~RID_INT~ //-->" . CRLF .
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"<div class=\"left\"><a name=\"~RID~\" href=\"" . __PATH . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"<div class=\"right\"><b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"search_body_left\"><p><b>" .
WORD_COMPOSER . ":</b>&nbsp;~COMPOSER~</p><p><b>" .
WORD_ARRANGER . ":</b>&nbsp;~ARRANGER~</p><p><b>" .
WORD_DURATION . ":</b>&nbsp;~DAUER~</p></div>" . CRLF .
"<div class=\"search_body_middle\"><p><b>" .
WORD_GENRE . ":</b>&nbsp;~TREE_PATH~</p><p><b>" .
WORD_DIFFICULTY . ":</b>&nbsp;~SCHWER_GRUPPE~&nbsp;~SCHWER_DETAILS~</p><p><b>" .
WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p></div>" . CRLF .
"<div class=\"search_body_right\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"article_options\">~OPTION_DETAILS~~OPTION_MINISCORE~~OPTION_DEMO~~OPTION_RECORDS~~OPTION_MP3~~OPTION_CART~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF . 
"</div><div class=\"clear\"></div>" . CRLF
);


// TEMPLATE FÜR OPTION INFO IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DETAILS",
"<a href=\"" . __PATH . __INDEX . "?site=article&id=~RID~\">" . WORD_DETAILS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_details.png\" alt=\"" . WORD_DETAILS . "\" /></a>"
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_CART",
"<a href=\"" . __PATH . __INDEX . "?site=cart&action=add_to_cart&id=~RID~\">" . nbsp(SENTENCE_INTO_CART) . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_add_to_cart.png\" alt=\"" . SENTENCE_ADD_TO_CART . "\" /></a>"
);

// TEMPLATE FÜR OPTION DEMO IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_DEMO",
"<a href=\"" . __PATH . __INDEX . "?site=demo&id=~RID~\">" . WORD_DEMOS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_demo.png\" alt=\"" . WORD_DEMO . "\" /></a>"
);

// TEMPLATE FÜR OPTION MINISCORE IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MINISCORE",
"<a href=\"" . __PATH . __INDEX . "?action=miniscore&id=~RID~\">" . WORD_MINISCORE . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_miniscore.png\" alt=\"" . SENTENCE_SEND_MINISCORE . "\" /></a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_RECORDS",
"<a href=\"" . __PATH . __INDEX . "?site=search&action=search_records&id=~RID~\">" . WORD_RECORDS . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_record.png\" alt=\"" . SENTENCE_SEARCH_RECORDS . "\" /></a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

//TEMPLTATE FÜR OPTION MP3-DOWNLOAD IM NEWSLETTER
define("_TEMPLATE_ARTICLE_NEWSLETTER_OPTION_MP3",
"<a href=\"" . __PATH . __INDEX . "?site=cart&action=add_to_cart&vid=~VERSION_MP3~&id=~RID~\">" . nbsp(SENTENCE_BUY_MP3_DOWNLOAD) . "<img src=\"" . __PATH . __TEMPLATE_IMAGES_PATH . "option_buy_mp3.png\" alt=\"" . SENTENCE_BUY_MP3_DOWNLOAD. "\" /></a>"
);


define("_TEMPLATE_ARTICLE_MYSHOP_MYMUSIC",
"<!--<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\">~NUMERO~</td>-->" . CRLF . 
"<td style=\"text-align:left;  padding-left:10px; padding-right:10px; border-bottom:1px dashed #DDDDDD;\"><a href=\"" . __INDEX . "?site=article&id=~ARTIKEL_R~\">~TITEL~</a></td>" . CRLF . 
"<td style=\"text-align:center;  padding-left:20px; padding-right:20px; border-bottom:1px dashed #DDDDDD;\">~MP3_FILE_SIZE~ MB</td>" . CRLF
);


// ARTIKEL-TEMPLATE FÜR DIE MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST",
"<div class=\"article_main_container\">" . CRLF .
"<div class=\"article_header\">" . CRLF .
"  <div class=\"left\"><p>~POSITION~.</p>&nbsp;~OPTION_DETAILS~&nbsp;(" . WORD_ORDER_NO . " ~NUMERO~)</div>" .  CRLF .
"  <div class=\"right\"><b>Stück:&nbsp;~QUANTITY~x</b>&nbsp;&nbsp;<b>" . WORD_PRICE . "</b>&nbsp;~PRICE~</div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<div class=\"article_body\">" . CRLF .
"<form id=\"~UID~\" action=\"" . __INDEX . "\" method=\"post\">" . CRLF .
"  <input type=\"hidden\" name=\"site\" value=\"myshop\" />" . CRLF .
"  <input type=\"hidden\" name=\"subsite\" value=\"wishlists\" />" . CRLF .
"  <input type=\"hidden\" name=\"action\" value=\"update_wishlist\" />" . CRLF .
"  <input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"uid\" value=\"~UID~\" />" . CRLF .
"  <input type=\"hidden\" name=\"id\" value=\"~WID~\" />" . CRLF .
"  <!-- <p class=\"hint\">~COMPOSER~&nbsp;|&nbsp;~ARRANGER~ --><!-- &nbsp;|&nbsp;~PUBLISHER~ --><!-- </p> -->" . CRLF .
"  <p><b>" . WORD_AVAILABILITY . ":</b>&nbsp;~AVAILABILITY~</p>" . CRLF .
"  <p id=\"article_options\">" . SENTENCE_CHANGE_QUANTITY . CRLF .
"    <input id=\"quantity\" type=\"text\" class=\"minimal\" name=\"f_quantity\" value=\"~QUANTITY~\" size=\"1\" maxlength=\"2\" style=\"vertical-align:baseline; text-align:center; margin-bottom:5px;\" onblur=\"submit();\" />~OPTION_REFRESH~" . CRLF .
"    ~OPTION_DELETE~" . CRLF .
"    ~OPTION_MOVE_TO_CART~" . CRLF .
"  </p>" . CRLF .
"  <p>~OPTION_VERSION~&nbsp;~OPTION_COPY~</p>" . CRLF .
"</form>" . CRLF .
"</div>" . CRLF .
"<div class=\"article_side\">~OPTION_THUMB~</div>" . CRLF .
"<div class=\"clear\"></div>" . CRLF .
"</div><div class=\"clear\"></div>" . CRLF .
"<script type=\"text/javascript\"> checkDetail('~UID~'); </script>" . CRLF
);

// TEMPLATE FÜR OPTION DETAILS ANZEIGEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DETAILS",
"<a href=\"" . __INDEX . "?site=article&id=~RID~\">~TITEL~</a>"
);

// TEMPLATE FÜR OPTION AKTUALISIEREN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_REFRESH",
"<input type=\"image\" class=\"imageasbutton\" src=\"" . __TEMPLATE_IMAGES_PATH . "option_refresh.png\" alt=\"" . WORD_REFRESH . "\" style=\"vertical-align:middle; height:auto; margin-right:10px; background:none;\">"
);

// TEMPLATE FÜR OPTION LÖSCHEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DELETE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=delete_from_wishlist&aid=~AID~&uid=~UID~&wid=~WID~\">" . SENTENCE_DELETE_FROM_CART . image_tag(__TEMPLATE_IMAGES_PATH."option_delete.png",SENTENCE_DELETE_FROM_CART,"vertical-align:middle; margin-right:10px;") . "</a>"
);

// TEMPLATE FÜR OPTION DEMO IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_DEMO",
"<a href=\"" . __INDEX . "?site=demo&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_demo_blue.png",WORD_DEMO,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION MINISCORE IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_MINISCORE",
"<a href=\"" . __INDEX . "?site=~SITE~&action=miniscore&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_miniscore_blue.png",SENTENCE_SEND_MINISCORE,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION AUFNAHMEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_RECORDS",
"<a href=\"" . __INDEX . "?site=search&action=search_records&sid=~NEXT_SID~&id=~RID~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_record_blue.png",SENTENCE_SEARCH_RECORDS,"vertical-align:middle; margin-right:5px; margin-top:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION KOPIEREN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_COPY",
"<a href=\"" . __INDEX . "?site=cart&action=add_to_cart&id=~RID~&vid=~VERSION_R~\">" . image_tag(__TEMPLATE_IMAGES_PATH."option_copy.png",SENTENCE_COPY_ARTICLE_VERSION,"vertical-align:middle; margin-right:5px;") . "</a>"
);

// TEMPLATE FÜR OPTION ABBILDUNG IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_THUMB",
"<a href=\"~IMAGE~\" target=\"_blank\"><img src=\"~THUMB~\" style=\"border:1px #000000 solid;\" alt=\"~TITEL~\" /></a>"
);

// TEMPLATE FÜR OPTION AUSGABEART IN DER MERKLISTE - AUSGABEART ÖFFENTLICH
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_VERSION_PUBLIC",
"~VERSION~"
);

// TEMPLATE FÜR OPTION AUSGABEART IN DER MERKLISTE - AUSGABEART NICHT ÖFFENTLICH / NICHT VERÄNDERBAR
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_VERSION_NOT_PUBLIC",
"<b>~VERSION~</b>" . CRLF . "<input type=\"hidden\" name=\"f_version_r\" value=\"~VERSION_R~\">" . CRLF
);

// TEMPLATE FÜR OPTION EINKAUFSWAGEN IN DER MERKLISTE
define("_TEMPLATE_ARTICLE_WISHLIST_OPTION_MOVE_TO_CART",
"<a href=\"" . __INDEX . "?site=cart&action=move_to_cart&aid=~AID~&wid=~WID~&uid=~UID~\">" . nbsp(SENTENCE_INTO_CART) . image_tag(__TEMPLATE_IMAGES_PATH."option_add_to_cart.png",SENTENCE_ADD_TO_CART) . "</a>"
);

?>
<?php

define("_TEMPLATE_CART",
image_tag(__TEMPLATE_IMAGES_PATH."icon_cart.png",WORD_CART,"margin-bottom:10px; margin-right:20px; vertical-align:middle;") .
"<span style=\"font-size:22px; vertical-align:middle;\"><b>" . WORD_CART . "</b></span><br />" . 
"~OBJ_MESSAGELIST~" . CRLF .
"<table style=\"border:0px #545454 solid; width:780px;\" cellspacing=\"5\">" . CRLF . 
"~ARTICLES~
<tr>
<td>
  <table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
  <tr>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_top_corner_grey.png","","border:0px;") . "</td>
    <td rowspan=\"2\" style=\"font-size:11px; width:100px; background:#D9D9D9; vertical-align:top; text-align:center; padding-top:5px; padding-left:0px;\">
      " . WORD_REFRESH . "<br />~OPTION_REFRESH_DELIVERY~
    </td>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_top_corner_grey.png","","border:0px;") . "</td>
  </tr>
  <tr>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_left_bottom_corner_grey.png","","border:0px;") . "</td>
    <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#D9D9D9;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_article_cart_right_bottom_corner_grey.png","","border:0px;") . "</td>
  </tr>
  </table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:0px; font-size:11px;\">
<table style=\"padding:0px; border:0px; table-layout:fixed;\" cellspacing=\"0\">
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_left_top_corner_green.png","","border:0px;") . "</td>
  <td rowspan=\"2\" style=\"width:45px !important; background:#CCFFB3; text-align:right; vertical-align:top; padding-top:5px; padding-left:0px;\"></td>
  <td rowspan=\"2\" style=\"width:100%; background:#CCFFB3; vertical-align:top; padding-top:5px; padding-left:10px;\">
    <b>" . WORD_SHIPPING . "</b><br /><br />&nbsp;
  </td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:top; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_right_top_corner_green.png","","border:0px;") . "</td>
</tr>
<tr>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_left_bottom_corner_green.png","","border:0px;") . "</td>
  <td style=\"padding:0px; border:0px; width:29px; vertical-align:bottom; background:#CCFFB3;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_delivery_cart_right_bottom_corner_green.png","","border:0px;") . "</td>
</tr>
</table>
</td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\"><b>~DELIVERY~</b></td>
</tr>
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<td style=\"color:#000000; vertical-align:middle; text-align:right; padding-right:5px; padding-left:5px;  font-size:14px;\"><b>" . WORD_SUM . "</b></td>
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\"><b>~SUM~</b></td>
</tr>
<tr style=\"height:20px;\">
<td style=\"color:#000000; vertical-align:middle; padding:0px; padding-right:5px; font-size:11px; text-align:right; background:transparent;\"></td>
<!-- <td style=\"color:#000000; vertical-align:middle; text-align:left; padding-right:5px; padding-left:5px; font-size:14px;\">~OPTION_LOAD~</td> -->
<td colspan=\"2\" style=\"color:#000000; vertical-align:middle; padding:0px; padding-left:15px; font-size:14px; text-align:right;\">~OPTION_ORDER~</td>
</tr>
</table>" . CRLF
);

define("_TEMPLATE_CART_OPTION_ORDER",
"<a href=\"" . __INDEX . "?site=order\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_order.png",SENTENCE_GO_TO_CHECKOUT,"vertical-align:middle; margin-bottom:5px;") . 
"<br />" . SENTENCE_GO_TO_CHECKOUT .
"</a>"
);

define("_TEMPLATE_CART_OPTION_REFRESH_DELIVERY",
"<a href=\"" . __INDEX . "?site=cart&action=refresh_delivery\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_refresh.png",WORD_REFRESH,"vertical-align:middle;") . 
"</a>"
);

define("_TEMPLATE_CART_OPTION_LOAD",
"<a href=\"" . __INDEX . "?site=cart&action=load_cart&aid=~AID~\">" . 
image_tag(__TEMPLATE_IMAGES_PATH."option_load_cart.png",SENTENCE_LOAD_LAST_CART,"vertical-align:middle; margin-right:10px;") . 
"</a>"
);

define("_TEMPLATE_CART_ORDER",
"<table style=\"border:2px #545454 solid; width:780px; padding:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr><td><b>" . WORD_ORDER_NO . "</b></td><td><b>" . WORD_TITLE . "</b></td><td><b>" . WORD_VERSION . "</b></td><td><b>" . WORD_QUANTITY . "</b></td><td><b>" . WORD_PRICE . "</b></td></tr>" . CRLF . 
"~ARTICLES~" . CRLF .
"<tr><td></td><td>" . WORD_SHIPPING . "</td><td></td><td></td><td>~DELIVERY~</td></tr>" . CRLF . 
"<tr><td></td><td><b>" . WORD_SUM . "</b></td><td></td><td></td><td><b>~SUM~</b></td></tr>" . CRLF . 
"</table>" . CRLF
);

?>
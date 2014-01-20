<?php
if ($errorlist->error) { echo $errorlist->getFromHTMLTemplate($errorlist->getAsCustomHTML("&gt;&nbsp;<b>","</b><br />")); }
$errorlist->clear();

$template->setTemplates(array(twebshop_article::CLASS_NAME => $_TEMPLATE_ARTICLE_CART_ORDER, 
                              twebshop_cart::CLASS_NAME => $_TEMPLATE_CART_ORDER, 
							  twebshop_price::CLASS_NAME => $_TEMPLATE_PRICE_CART));

image_show(__PNG_PATH."icon_order.png","","margin-bottom:0px; margin-right:20px; vertical-align:middle; text-align:left;");
?>
<span style="font-size:20px; vertical-align:middle;"><b>order form</b></span>
<table style="width:750px; padding:0px; border:2px #545454 solid; table-layout:fixed; margin-bottom:10px;" cellspacing="1">
<form name="orderform" action="<?php echo $_INDEX;?>" method="get">
<tr>
<td style="color:#FFFFFF; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background-image:url('<?php echo __PNG_PATH; ?>back_menu_head.png'); background-repeat:repeat-x;">
  your customer data
</td>
</tr>
<tr>
<td style="padding:10px; border:0px; font-size:11px; background:url('<?php echo __PNG_PATH; ?>back_article.png') repeat-x;">
name:&nbsp;<input class="text" type="text" name="name" maxlength="100" size="50" value="<?php if (isset($name)) echo $name; ?>"><br />
address:&nbsp;<input class="text" type="text" name="address" maxlength="100" size="100" value="<?php if (isset($address)) echo $address; ?>"><br />
city:&nbsp;<input class="text" type="text" name="city" maxlength="50" size="50" value="<?php if (isset($city)) echo $city; ?>"><br />
state/country:&nbsp;
<select name="state_country" style="font-size:11px; font-weight:bold; vertical-align:middle;">
<?php
$states = preg_split("/\r*\n+/",file_get_contents("./states.txt"));
foreach($states as $state) 
echo "<option value=\"$state\" " . ((isset($state_country) AND $state_country == $state) ? "selected" : "") . ">$state</option>";
?>
</select><br />
zip code:&nbsp;<input class="text" type="text" name="zip" maxlength="20" size="10" value="<?php if (isset($zip)) echo $zip; ?>"><br />
phone:&nbsp;<input class="text" type="text" name="phone" maxlength="40" size="30" value="<?php if (isset($phone)) echo $phone; ?>"><br />
email:&nbsp;<input class="text" type="text" name="email" maxlength="70" size="40" value="<?php if (isset($email)) echo $email; ?>"><br />
</td>
</tr>
<td style="color:#FFFFFF; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background-image:url('<?php echo __PNG_PATH; ?>back_menu_head.png'); background-repeat:repeat-x;">
  your order data
</td>
</tr>
<tr>
<td style="padding:10px; border:0px; background:url('<?php echo __PNG_PATH; ?>back_article.png') repeat-x;">
  <?php echo $cart->getFromHTMLTemplate($template); ?>
</td>
</tr>
<td style="color:#FFFFFF; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background-image:url('<?php echo __PNG_PATH; ?>back_menu_head.png'); background-repeat:repeat-x;">
  final step
</td>
</tr>
<tr>
<td style="font-size:11px; padding:10px; border:0px; background:transparent;">
  <!--
  <?php image_show(__PNG_PATH."button_cancel.png","","vertical-align:middle;"); ?>&nbsp;<b>cancel</b>&nbsp;&nbsp;&nbsp;
  -->
  <a class="lnk_06" href="javascript:document.forms.orderform.submit();"><?php image_show(__PNG_PATH."button_send.png","","vertical-align:middle;"); ?> <b> send order</b></a>
</td>
</tr>
<input type="hidden" name="action" value="order">
<input type="hidden" name="site" value="order"> 
</form>
</table>


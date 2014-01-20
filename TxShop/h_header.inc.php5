<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<!---  meta http-equiv="expires" content="0" //--->
<script src="AC_OETags.js" language="javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--
var requiredMajorVersion = 9;
var requiredMinorVersion = 0;
var requiredRevision = 115;
// -->
</script>
<title>windbandmusic.com</title>
<link rel="stylesheet" type="text/css" href="style.css.php5">
</head>

<body>
<table style="height:100%; width:100%; table-layout:fixed; border-width:0px; padding:0px;" cellspacing="0">
<tr><td style="padding:0px; height:120px; border-width:0px;">
 
  <form action="<?php echo $_INDEX; ?>" method="post">
  <input type="hidden" name="site" value="search">
  <table style="width:100%px; height:120px; color:#FFFFFF; border-width:0px; padding:0px; table-layout:fixed;" cellspacing="0">
  <tr>
    <td style="width:230px; height:120px; background-color:#FFFFFF; padding:0px; border-width:0px;"><?php image_show(__PNG_PATH."logo_title.png","windbandmusic.com") ?></td>
    <td style="width:70px; vertical-align:top; background-color:#ADCBE7; padding:0px; padding-top:55px; background:url('<?php echo __PNG_PATH; ?>back_title.png') repeat-x;">
    </td>
    <td style="width:50px; vertical-align:middle; text-align:left; padding-left:0px; padding-top:55px; padding-bottom:30px; color:#000000; background:url('<?php echo __PNG_PATH; ?>back_title.png') repeat-x;">
	  <b>search</b>
	</td>
	<td style="width:170px; vertical-align:middle; text-align:left; padding-left:0px; padding-top:55px; padding-bottom:30px; background:url('<?php echo __PNG_PATH; ?>back_title.png') repeat-x;">
	  <input type="text" class="text" name="expression" value="<?php if (isset($_SESSION["s_expression"])) echo $_SESSION["s_expression"]; ?>" size="30">
	</td>
    <td style="width:30px; vertical-align:middle; text-align:left; padding-left:0px; padding-top:55px; padding-bottom:30px; background:url('<?php echo __PNG_PATH; ?>back_title.png') repeat-x;">
      <input type="image" src="<?php echo __PNG_PATH; ?>button_search.png" name="search" value="Ok" alt="<?php echo HINT_SEARCH; ?>" style="float:left;">
	</td>
    <td style="vertical-align:middle; text-align:left; padding-left:0px; padding:0px; background:url('<?php echo __PNG_PATH; ?>back_title.png') repeat-x;">
	  
    </td>
    <td style="width:36px; vertical-align:bottom; text-align:right; padding:0px; background:url('<?php echo __PNG_PATH; ?>back_fat_bar_left.png') no-repeat;">
      <!--
	  <a class="lnk_01" href="<?php echo $_INDEX; ?>?site=cart"><?php image_show(__PNG_PATH."icon_big_cart_header.png",HINT_SHOW_CART); ?></a>
	  //-->
	</td>
	<td style="width:150px; vertical-align:middle; text-align:left; padding:0px; padding-top:60px; padding-bottom:10px; background:url('<?php echo __PNG_PATH; ?>back_fat_bar.png') repeat-x;">
      <b>
	  <?php
	    $link = (($cart->getPositions() > 0) AND ($site != "cart")) ? "<a class=\"lnk_02\" href=\"./$_INDEX?site=cart\">" . WORD_CART . "</a>" : "<span class=\"grey\">" . WORD_CART . "</span>";
		echo $link; 
	  ?>
	  </b><br />&nbsp;&nbsp;&nbsp;&nbsp;<span class="smallgrey">(<?php echo twebshop_price::toCurrency($cart->getSum()); ?>)</span>
	</td>
    <td style="width:50px; vertical-align:middle; text-align:right; padding:0px; padding-top:60px; padding-bottom:10px; background:url('<?php echo __PNG_PATH; ?>back_fat_bar.png') repeat-x;">
	  <b>
	  <?php
	    $link = (($cart->getPositions() > 0) AND ($site != "order")) ? "<a class=\"lnk_02\" href=\"./$_INDEX?site=order\">" . WORD_ORDER . "</a>" : "<span class=\"grey\">" . WORD_ORDER . "</span>";
		echo $link; 
	  ?>
	  </b>
	</td>
    <td style="width:75px; padding:0px; border-width:0px; background:url('<?php echo __PNG_PATH; ?>back_fat_bar.png') repeat-x;">
	</td>
  </tr>
  </table>
  <input type="hidden" name="action" value="search_user_expression">
  <input type="hidden" name="site" value="search">
  <input type="hidden" name="type" value="user">
  </form>
  
</td></tr>

<tr><td style="height:0px; padding:0px;">
</td></tr>

<tr><td style="vertical-align:top; background-image:url('<?php echo __PNG_PATH; ?>background.png_NOT_ACTIVE'); padding-top:0px; padding-left:15px; padding-right:15px; border:0px #DDDDDD solid;">
  
  <table style="width:100% border:0px;" cellspacing="0">
  <tr><td style="width:180px; vertical-align:top; border:0px #DDDDDD solid;"> 
    
	<table style="width:180px; border-width:2px; border-color:#545454; border-style:solid; table-layout:fixed; border" cellspacing="1">
    <tr>
      <td style="color:#FFFFFF; padding-left:10px; text-align:left; vertical-align:middle; font-size:11px; background-image:url('<?php echo __PNG_PATH; ?>back_menu_head.png'); background-repeat:repeat-x;">
        menu 
      </td>
	</tr><tr>
	  <td style="color:#000000; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('<?php echo __PNG_PATH; ?>back_menu_item.png') repeat-x;">
	    &gt; <a href="<?php echo  $_INDEX; ?>?site=home"><?php echo LINK_HOME; ?></a>
	  </td>
    </tr><tr>
	  <td style="color:#000000; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('<?php echo __PNG_PATH; ?>back_menu_item.png') repeat-x;">
	    &gt; <a href="<?php echo  $_INDEX; ?>?site=tob"><?php echo LINK_GBC; ?></a>
	  </td>
    </tr><tr>
	  <td style="color:#000000; padding-left:10px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('<?php echo __PNG_PATH; ?>back_menu_item.png') repeat-x;">
	    &gt; <a href="<?php echo  $_INDEX; ?>?site=imprint"><?php echo LINK_CONTACT; ?></a>
	  </td>
    </tr>
	<?php
	  $template->setTemplates(array(twebshop_article::CLASS_NAME => $_TEMPLATE_ARTICLE_CART_SMALL, twebshop_cart::CLASS_NAME => $_TEMPLATE_CART_SMALL, twebshop_price::CLASS_NAME => $_TEMPLATE_PRICE_CART_SMALL)); 
	  if (($cart->getPositions() > 0) AND ($site != "cart"))
	  { echo $cart->getFromHTMLTemplate($template); 
	  }
	?>
	<!--<tr>
	  <td style="color:#000000; padding-left:10px; border-width:0px; border-color:#000000; border-style:solid; border-top-width:0px; border-bottom-width:0px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('<?php echo __PNG_PATH; ?>back_menu_item.png') repeat-x;">
	    
	  </td>
    </tr><tr>
	  <td style="color:#000000; padding-left:10px; border-width:0px; border-color:#000000; border-style:solid; border-top-width:0px; border-bottom-width:0px; height:20px; text-align:left; vertical-align:middle; font-size:11px; background:transparent url('<?php echo __PNG_PATH; ?>back_menu_item.png') repeat-x;">
	    
	  </td>
    </tr>
	-->
    </table>
    
  </td><td style="vertical-align:top; padding-left:15px;">
 
  
  
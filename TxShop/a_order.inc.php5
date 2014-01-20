<?php

//define("EMAIL_ORDER_ADDRESS","tschroff@gmx.de");
define("EMAIL_ORDER_ADDRESS","order@windbandmusic.com");
define("EMAIL_ORDER_SUBJECT","windbandmusic.com Bestellung");

form_input_filter($name);
form_text_filter($address);
form_input_filter($city);
form_input_filter($state_country);
form_input_filter($zip);
form_input_filter($phone);
form_input_filter($email);

if (strlen($name) == 0)       $errorlist->add(ERROR_NO_NAME_GIVEN);
if (strlen($address) == 0)    $errorlist->add(ERROR_NO_ADDRESS_GIVEN);
if (strlen($city) == 0)       $errorlist->add(ERROR_NO_CITY_GIVEN);
if ($state_country[0] == "-") $errorlist->add(ERROR_NO_COUNTRY_SELECTED);
if (strlen($zip) == 0)        $errorlist->add(ERROR_NO_ZIP_GIVEN);
if (!check_email($email))     $errorlist->add(ERROR_INVALID_EMAIL);
if (!check_phone($phone))     $errorlist->add(ERROR_INVALID_PHONE);

if (!$errorlist->error)
{ $template->setTemplates(array(twebshop_article::$name => $_TEMPLATE_ARTICLE_CART_EMAIL, 
                                twebshop_cart::$name => $_TEMPLATE_CART_EMAIL,
								twebshop_price::$name => $_TEMPLATE_PRICE_CART_EMAIL)); 

  $message = date("d.m.Y") . LF . LF. $name . LF . $address . LF . $zip . LF . $city . LF . $state_country . LF . $phone . LF . $email . LF . LF;
  $message.= $cart->getFromHTMLTemplate($template);
   
  $i = 0;
  do
  { $i++;
    $m = mail(EMAIL_ORDER_ADDRESS, EMAIL_ORDER_SUBJECT, $message,"From: webshop@windbandmusic.com");
  } while($m != true AND $i <= 3);

  if ($m == true) 
  { $cart->clear();
    $messagelist->add(SENTENCE_ORDER_SENT);
	$site = "no";
  }
  else 
  { $errorlist->add(ERROR_ORDER_NOT_SENT);
  }
  
  //file_put_contents("order_email.txt",str_replace(LF,CRLF,$message));
}

?>
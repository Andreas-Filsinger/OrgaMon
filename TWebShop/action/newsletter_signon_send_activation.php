<?php

$id = $tmp_person->getIDasHash();

$bill = new twebshop_bill(TWEBSHOP_BILL_R_NEWSLETTER);
$name = $bill->MOTIVATION;
unset($bill);

$subject = SENTENCE_NEWSLETTER_SIGNON;

$body = $name . CRLF . CRLF . load_txt(__LANGUAGE_PATH.__LANGUAGE."/newsletter-signon-activation-email.txt", false, true) . CRLF . __PATH . "?action=newsletter_signon_activate&f_user=$f_user&id=$id";

if (torgamon::sendMail($tmp_person->getID(),$subject,$body) != false)
{ $messagelist->add(load_txt(__LANGUAGE_PATH.__LANGUAGE."/newsletter-signon-send-activation-message.txt", false, true));
}

unset($body);
unset($subject);
unset($name);
unset($id);

?>
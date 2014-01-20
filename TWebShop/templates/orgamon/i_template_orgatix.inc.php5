<?php

define("_TEMPLATE_ORGATIX_MYSHOP_ORGATIX",
"<table style=\"width:100%; padding:0px; border:0px; margin:0px;\" cellspacing=\"0\">" . CRLF . 
"<tr>" . CRLF .
"<td style=\"height:25px; background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_PRIORITY . "</b></td>" . CRLF . 
"<td style=\"background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_DATE . "</b></td>" . CRLF . 
"<td style=\"background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_STATE_OF_PROCESS . "</b></td>" . CRLF . 
"<td style=\"background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_SUBJECT . "</b></td>" . CRLF .
"<td style=\"background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_PROCESSOR . "</b></td>" . CRLF . 
"<td style=\"text-align:center; background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_AUTHOR . "</b></td>" . CRLF .
"<td style=\"text-align:center; background:#ADCBE7 url('" . __TEMPLATE_IMAGES_PATH ."back_orgatix_table_header.png') repeat-x; padding-left:10px; padding-right:10px;\"><b>" . WORD_OPTIONS . "</b></td>" . CRLF .
"</tr>" . CRLF .
"~TICKETS~" . CRLF .
"</table>" . CRLF
);

define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX",
"<tr>" . CRLF .
"<td style=\"height:25px; text-align:left; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7; co3lor:#~PAPERCOLOR_HEX~;\">". CRLF . 
"<div style=\"width:12px; height:12px; border:1px solid #000000; background:#~PAPERCOLOR_HEX~; float:left;\">" . image_tag(__TEMPLATE_IMAGES_PATH."back_orgatix_priority.png",WORD_PRIORITY.":~PRIORITY_STRING~","border:0px;") . "</div>&nbsp;&nbsp;~PRIORITY_STRING~<!-- ~PRIORITAET~ -->" . CRLF . 
"</td>" . CRLF . 
"<td style=\"text-align:left; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~MOMENT_DATE~</td>" . CRLF . 
"<td style=\"text-align:left; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~AKTION_FIRST_LINE~</td>" . CRLF . 
"<td style=\"text-align:left; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~INFO_FIRST_LINE~</td>" . CRLF . 
"<td style=\"text-align:left; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~PROCESSOR~&nbsp;<!-- ~BEARBEITER_R~ --></td>" . CRLF . 
"<td style=\"text-align:center; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~VERFASSER~</td>" . CRLF .
"<td style=\"text-align:center; padding-left:10px; padding-right:10px; border-bottom:1px solid #ADCBE7;\">~OPTION_EDIT~</td>" . CRLF .
"</tr>" . CRLF
);


define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_OPTION_EDIT",
"<a href=\"" . __INDEX . "?site=myshop&subsite=orgatix_ticket&id=~RID~\">" . WORD_EDIT . "</a>" . CRLF
);

define("_TEMPLATE_ORGATIX_PROCESSOR_MYSHOP_ORGATIX",
"~USERNAME~"
);

define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_TICKET",
"<form action=\"" . __INDEX . "\" method=\"post\" style=\"margin:0px;\">" . CRLF . 
"<p style=\"margin:0px; margin-bottom:10px;\"><b>" . WORD_DATE . ":</b> ~MOMENT_DATE~&nbsp;&nbsp;&nbsp;<b>" . WORD_TIME . ":</b> ~MOMENT_TIME~</p>" . CRLF .
"<p style=\"margin:0px; margin-bottom:10px;\"><b>" . WORD_PROCESSOR . ":</b>" . CRLF . 
"~OPTION_PROCESSOR~</p>" . CRLF .
"<p style=\"margin-bottom:10px;\"><b>" . WORD_PRIORITY . ":</b> " . CRLF .
"<input type=\"radio\" name=\"f_choice\" id=\"f_choice_high\"   value=\"20\" style=\"vertical-align:top;\" ~OPTION_PRIORITY_2~>&nbsp;<label for=\"f_choice_high\"   style=\"vertical-align:top;\">" . WORD_HIGH . "</label>" . CRLF .
"<input type=\"radio\" name=\"f_choice\" id=\"f_choice_middle\" value=\"10\" style=\"vertical-align:top;\" ~OPTION_PRIORITY_1~>&nbsp;<label for=\"f_choice_middle\" style=\"vertical-align:top;\">" . WORD_MIDDLE . "</label>" . CRLF .
"<input type=\"radio\" name=\"f_choice\" id=\"f_choice_low\"    value=\"0\"  style=\"vertical-align:top;\" ~OPTION_PRIORITY_0~>&nbsp;<label for=\"f_choice_low\"    style=\"vertical-align:top;\">" . WORD_LOW . "</label>" . CRLF .
"</p>" . CRLF .
"<p style=\"margin-bottom:10px;\"><b>" . WORD_DESCRIPTION . "</b><br />" . CRLF .
"<textarea name=\"f_orgatix_ticket_info\" style=\"width:100%; height:200px;\">~INFO_TEXT~</textarea>" . CRLF .
"</p>" . CRLF .
"<p style=\"margin-bottom:10px;\"><b>" . WORD_STATE_OF_PROCESS . "</b><br />" . CRLF .
"<textarea name=\"f_orgatix_ticket_action\" style=\"width:100%; height:75px;\">~AKTION_TEXT~</textarea>" . CRLF .
"</p>" . CRLF .
"<input type=\"hidden\" name=\"action\" value=\"save_orgatix_ticket\">" . CRLF . 
"<input type=\"hidden\" name=\"subsite\" value=\"orgatix\">" . CRLF . 
"<input type=\"hidden\" name=\"aid\" value=\"~OPTION_AID~\">" . CRLF . 
"<input type=\"hidden\" name=\"id\" value=\"~RID~\">" . CRLF .
"<input type=\"submit\" value=\"" . WORD_SAVE . "\" style=\"font-family:Tahoma; font-size:11px; font-weight:bold; border:2px solid #6699CC; padding-left:10px; padding-right:10px; background:#FFFFFF;\">" . CRLF . 
"</form>"
);

define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_TICKET_OPTION_AUTHOR",
image_tag(__TEMPLATE_IMAGES_PATH."option_orgatix_author.png","","border:0px;")
);

define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_OPTION_AUTHOR",
image_tag(__TEMPLATE_IMAGES_PATH."option_orgatix_author.png","","border:0px;")
);

define("_TEMPLATE_ORGATIX_TICKET_MYSHOP_ORGATIX_TICKET_OPTION_PROCESSOR",
""
);

define("_TEMPLATE_ORGATIX_MYSHOP_ORGATIX_TICKET",
"<select name=\"f_orgatix_processor_id\">" . CRLF . "~PROCESSORS~</select>"
);

define("_TEMPLATE_ORGATIX_PROCESSOR_MYSHOP_ORGATIX_TICKET",
"<option value=\"~RID~\" style=\"color:#~FARBE_VORDERGRUND_HEX~; background:#~FARBE_HINTERGRUND_HEX~;\" ~OPTION_SELECTED~>~USERNAME~ (~KUERZEL~)</option>" . CRLF
);

?>
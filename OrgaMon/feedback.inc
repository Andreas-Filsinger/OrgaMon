 function _(key : Integer; value : string = '') : Integer;
 begin
   if assigned(fb) then
    result := fb(key,value)
   else
    result := cFeedBack_CONT;
 end;

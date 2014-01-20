function showSearchInputHint()
{ if (document.forms['form_search'].elements['f_search_expression'].value.length == 0)
  { document.forms['form_search'].elements['f_search_expression'].value = SEARCH_HINT;
	search_expression_empty = true;
  }
}
		
function clearSearchInputHint()
{ if (search_expression_empty)
  { document.forms['form_search'].elements['f_search_expression'].value = '';
  }
}
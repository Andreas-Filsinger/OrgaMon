function leadingZero(number, digits)
{ while(number.length < digits)
  { number = '0' + number;
  }
  return number;
}

function setSelectedOptionByValue(form_name, element_name, value)
{ var index = 0;
  for(var i = 0; i < document.forms[form_name].elements[element_name].options.length; i++)
  { if (document.forms[form_name].elements[element_name].options[i].value == value) index = i;
  }
  document.forms[form_name].elements[element_name].options.selectedIndex = index;
}

function setCheckedRadioButtonByValue(form_name, element_name, value)
{ var index = 0;
  for(var i = 0; i < document.forms[form_name].length; i++)
  { element = document.forms[form_name].elements[i];
    if (element.name == element_name && element.value == value)
    { element.checked = true;
	}
  }
}

function checkRadioButtonById(id)  
{ document.getElementById(id).checked = true;
}

function uncheckRadioButtonByID(id)
{ document.getElementById(id).checked = false;
}

function getIndexOfChecked(form_name, element_name)
{ var element = document.forms[form_name].elements[element_name];
  var i = 0;
  for(i = 0; i < element.length; i++)
  { if (element[i].checked) break;
  }
  return i;
}

function getValueOfChecked(form_name, element_name)
{ var element = document.forms[form_name].elements[element_name];
  //alert(element.length);
  var index = getIndexOfChecked(form_name, element_name);
  var value = (index == 0 && !element.length) ? document.forms[form_name].elements[element_name].value : document.forms[form_name].elements[element_name][index].value;
  return value;
}
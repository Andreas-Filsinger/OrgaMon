document.cookie = 'TWEBSHOP_COOKIE_TEST=true;';
function checkCookies(site)
{ if (!document.cookie)
  { //alert(site);
	if (site != 'cookies') window.location.href = '?site=cookies';
  }
  else
  { //alert('Cookies erlaubt');
  }
}

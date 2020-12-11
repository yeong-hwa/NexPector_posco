// JavaScript Document
function onlyNumber(e) {
	if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
			// Allow: Ctrl+A
		(e.keyCode == 65 && e.ctrlKey === true) ||
			// Allow: home, end, left, right
		(e.keyCode >= 35 && e.keyCode <= 39)) {
		// let it happen, don't do anything
		return;
	}
	// Ensure that it is a number and stop the keypress
	if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
		e.preventDefault();
	}
}

function ipChk(strIP)
{
	var blsRet = false;
	if(strIP.search(/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/) >= 0)
	{
		var arrIP = strIP.split('.');
		if(arrIP.length == 4)
		{
			if(arrIP[0] < 256 && arrIP[1] < 256 && arrIP[2] < 256 && arrIP[3] < 256)
				return true;
		}
	}
	return blsRet;
}

function cfn_empty_valchk(obj, alert_str)
{
	if(cfn_isEmpty(obj))
	{
		alert(alert_str + " 을/를 입력해 주십시오.");
		obj.focus();
		return false;
	}

	return true;
}

function cfn_empty_radio_valchk(obj, alert_str)
{
	for(i=0;i<obj.length;i++)
	{
		if(obj[i].checked)
			return true;
	}
	alert(alert_str + " 을/를 선택해 주십시오.");	

	return false;
}

function cfn_isEmpty(obj)
{
	if(obj.value == "" || obj.value == null)
		return true;

	return false;
}

var tmp_color;
function cfn_lst_mouseover(obj)
{
	tmp_color = obj.style.backgroundColor;
	obj.style.backgroundColor='#8BE3FA';
}

function cfn_lst_mouseout(obj)
{
	//obj.style.backgroundColor='#FFFFFF';
	obj.style.backgroundColor=tmp_color;
	tmp_color = "";
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function cfn_getTimeStamp() {
	  var d = new Date();

	  var s =
	    cfn_leadingZeros(d.getFullYear(), 4)+
	    cfn_leadingZeros(d.getMonth() + 1, 2)+
	    cfn_leadingZeros(d.getDate(), 2)+

	    cfn_leadingZeros(d.getHours(), 2)+
	    cfn_leadingZeros(d.getMinutes(), 2)+
	    cfn_leadingZeros(d.getSeconds(), 2);

	  return s;
	}



	function cfn_leadingZeros(n, digits) {
	  var zero = '';
	  n = n.toString();

	  if (n.length < digits) {
	    for (var i = 0; i < digits - n.length; i++)
	      zero += '0';
	  }
	  return zero + n;
	}


	function cfn_minus_zero(val)
	{
		return val < 0?0:val;
	}
	
	
	function cfn_makecombo_opt(select_obj, qry_url, fn_callback)
	{
		$.ajaxSetup({ async:false });
		$.getJSON(qry_url, function(data){
			$(data).each(function(){
				if(jQuery.type(this.CODE) === "undefined" && jQuery.type(this.VAL) === "undefined"){
					var tmp_str = "<option value=''>등록된 정보가 없음</option>";
				} else {
					var tmp_str = "<option value=\"" + this.CODE + "\">" + this.VAL + "</option>";
				}
				$(select_obj).append(tmp_str);
			});

			fn_callback && fn_callback();
		});
		$.ajaxSetup({ async:true });
	}
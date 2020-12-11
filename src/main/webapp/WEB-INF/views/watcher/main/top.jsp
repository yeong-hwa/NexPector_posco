<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script>
function fn_logout()
{
	if(!confirm("로그아웃 하시겠습니까?")) {
		return;
	}
	parent.frm.target = "";
	parent.frm.action="<c:url value='/watcher/logout.htm'/>";
	parent.frm.submit();
}

function fn_start_page()
{
	if(!confirm('메인 페이지로 이동 하시겠습니까?'))
		return;

	parent.frm.target = "";
	parent.frm.action="<c:url value='/watcher/main.htm'/>";
	parent.frm.submit();
}

$(function(){
	$("#main_menu1").click(function (){
		parent.fn_select_menu("<c:url value='/watcher/go_realtime_stats.realtime_main.htm?req_data=tree_data;watcher_main.TreeSvrGroupQry'/>");
	});
	$("#main_menu2").click(function (){
		parent.fn_select_menu("<c:url value='/watcher/go_server_detail.server_detail_main.htm'/>");
	});
	$("#main_menu3").click(function (){
		parent.fn_select_menu("<c:url value='/watcher/go_history_stats.history_stats_main.htm'/>");
	});
});

function fn_setting()
{
	window.open("<c:url value='/watcher/go_main.setting.htm'/>?req_data=user_compo_lst;UserCompoLstQry|compo_lst;CompoLstQry&S_USER_ID=${sessionScope.S_USER_ID}","setting","width=400, height=420, location=no", true);
}

function fn_setting_ok()
{
	$("#main_menu1").click();
}

function fn_error_popup_open()
{
	alarm_flag = false;
	top.fn_error_popup_open();
}

$(function(){
	/*$("#btn_warning").hover(function(){
		$(this).attr("bgcolor", "#AA5566");
	}, function(){
		$(this).attr("bgcolor", "");
	});*/

	fn_alarm_blink();
});

var alarm_flag;
function fn_alarm_blink()
{
	if(alarm_flag)
	{
		if($("#btn_warning").attr("bgcolor") == "" || $("#btn_warning").attr("bgcolor") == null)
			$("#btn_warning").attr("bgcolor", "#AA5566");
		else
			$("#btn_warning").attr("bgcolor", "");
	}
	else
	{
		$("#btn_warning").attr("bgcolor", "");
	}
	setTimeout("fn_alarm_blink()", 1000);
}

</script>

<body onLoad="MM_preloadImages('${img2}/menu01_on.png','${img2}/menu02_on.png','${img2}/menu03_on.png')">
	<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	  <tr>
	    <td height="60" colspan="2" valign="top" background="${img2}/bg_top.jpg">
		<!-- 상단 메뉴 네비게이션 시작 -->
	    <table width="1250" border="0" cellspacing="0" cellpadding="0">
	        <tr>
	          <td height="44"><img src="${img2}/logo_default.jpg" style="cursor:hand;" onclick="fn_start_page()"></td>
	          <!--<td width="114" rowspan="2"><a id="main_menu0" href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()%>/NexPector_Dashboard" target="_blank" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','${img2}/menu04_on.png',1)"><img src="${img2}/menu04_off.png" name="Image0" width="114" height="51" border="0"></a></td>
	          <td width="114" rowspan="2"><a id="main_menu1" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','${img2}/menu01_on.png',1)"><img src="${img2}/menu01_off.png" name="Image3" width="114" height="51" border="0"></a></td>
	          <td width="114" rowspan="2"><a id="main_menu2" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','${img2}/menu02_on.png',1)"><img src="${img2}/menu02_off.png" name="Image4" width="114" height="51" border="0"></a></td>
	          <td width="114" rowspan="2"><a id="main_menu3" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','${img2}/menu03_on.png',1)"><img src="${img2}/menu03_off.png" name="Image5" width="114" height="51" border="0"></a></td>
	          <td width="114" rowspan="2"><a id="main_menu4" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','${img2}/menu03_on.png',1)"><img src="${img2}/menu03_off.png" name="Image6" width="114" height="51" border="0"></a></td> -->
<%-- 	          <td width="164" rowspan="2"><a id="main_menu0" href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()%>/NexPector_Dashboard" target="_blank" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','${img2}/menu04_on.png',1)"><img src="${img2}/menu04_off.png" name="Image0" width="164" height="51" border="0"></a></td> --%>
	          <td width="164" rowspan="2"><a id="main_menu1" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','${img2}/menu01_on.png',1)"><img src="${img2}/menu01_off.png" name="Image3" width="164" height="51" border="0"></a></td>
	          <td width="164" rowspan="2"><a id="main_menu2" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','${img2}/menu02_on.png',1)"><img src="${img2}/menu02_off.png" name="Image4" width="164" height="51" border="0"></a></td>
	          <td width="164" rowspan="2"><a id="main_menu3" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','${img2}/menu03_on.png',1)"><img src="${img2}/menu03_off.png" name="Image5" width="164" height="51" border="0"></a></td>
	          <td width="270" align="right">
	          	<table>
	          		<tr>
	          			<td id="btn_warning"><img id="img_warning" src="${img2}/icon_warning1.png" onclick="fn_error_popup_open()" style="cursor:hand;"></td>
	          			<td><a href="#"><img src="${img2}/btn_setting.png" hspace="2" onclick="fn_setting()"></a></td>
	          			<td><a href="#"><img src="${img2}/btn_logout.png" hspace="2" onclick="fn_logout()"></a></td>
	          		</tr>
	          	</table>


	          </td>
	        </tr>
	        <tr>
	          <td height="7"><img src="${img2}/dot.png"></td>
	          <td><img src="${img2}/dot.png"></td>
	        </tr>
	    </table>
	    <!-- 상단 메뉴 네비게이션 끝 -->
	    </td>
	  </tr>
	</table>
</body>
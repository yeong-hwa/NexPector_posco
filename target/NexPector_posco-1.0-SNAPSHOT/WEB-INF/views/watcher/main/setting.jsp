<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>

<jsp:useBean id="user_compo_lst" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="compo_lst" class="java.util.ArrayList" scope="request"/>

<script>
	$(function() {
		$( "#user_compo_lst, #compo_lst" ).sortable({            connectWith: ".conSort"        }).disableSelection();
		this.focus();
	});
	
	function fn_save()
	{
		var compo_id = "";
		for(i=0;i<$("#user_compo_lst li").last().index()+1;i++)
		{
			compo_id += $("#user_compo_lst li input[name='compo_id']").eq(i).val() + ";";
		}
		
		var param = "S_COMPO_ID_LST=" + compo_id;
		
		param += "&S_USER_ID=${param.S_USER_ID}";
		
		//alert(param);
		//ajax_reqAction("main.reg_user_compo.neonex", param, "fn_result");
		
		$.post("<c:url value='/watcher/main/setting_modify.htm'/>", param, function(){
			alert('저장 되었습니다.');
			opener.fn_setting_ok();
			window.close();
		});
		
	}

	// 중복 제거
	/* 	function fn_result(str)
		{
			alert('저장 되었습니다.');
			opener.fn_setting_ok();
			this.close();
		} */
</script>
<style>    
	#user_compo_lst, #compo_lst { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; margin-right: 10px; }    
	#user_compo_lst li, #compo_lst li { margin: 0 2px 2px 2px; padding: 2px; font-size: 1.0em; width: 120px; border: 1 ; border-style:solid; border-color: 3f3f3f; background-color: efefef}    
</style>
<body>
<div style="width:100%;height:450;overflow:hidden;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	    <td height="1" colspan="2" bgcolor="a8b9d7" ><img src="${img2}/dot.png"></td>
	</tr>
	<tr>
		<td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
	</tr>
	<tr>
	    <td height="39" style="padding-left: 10px"><img src="${img2}/icon_next.jpg" align="absmiddle">&nbsp;<b>실시간 통계 Component 설정</b></td>
		<td align="right" style="padding-right: 10px"><input type="button" name="btn" style="width:40;height:20;background-color: dfdfdf;cursor:pointer;" value="저장" onclick="fn_save()"></td>
	</tr>
	<tr>
		<td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
	</tr>
</table>
<table width="100%" height="80%" border="1" style="border: solid;">
	<tr>
		<td width="50%">
			<img src="${img2}/icon_result.jpg" align="absmiddle"> 사용자 Component
		</td>
		<td width="50%">
			<img src="${img2}/icon_result.jpg" align="absmiddle"> Component
		</td>
	</tr>
	<tr valign="top">
		<td width="50%">
			<ul id="user_compo_lst" class="conSort" style="width:97%;">
				<c:forEach items="${user_compo_lst}" var="m">
					<li style="width:100%;height:25;">${m.S_COMPO_NAME}<input type="hidden" name="compo_id" value="${m.S_COMPO_ID}"></li>
				</c:forEach>
			</ul>
		</td>
		<td width="50%">
			<ul id="compo_lst" class="conSort" style="width:97%">
				<c:forEach items="${compo_lst}" var="m">
					<li style="width:100%;height:25;">${m.S_COMPO_NAME}<input type="hidden" name="compo_id" value="${m.S_COMPO_ID}"></li>
				</c:forEach>
			</ul>
		</td>
	</tr>
</table>
</div>
</body>
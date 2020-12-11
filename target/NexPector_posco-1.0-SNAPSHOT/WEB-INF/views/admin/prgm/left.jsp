<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="menu" items="${sessionScope.m_menu}" varStatus="stat">
	<li><a href="${menu.S_MENU_URL}?menuCode=${menu.N_MENU_CODE}&upperMenuCode=${menu.PARENT_MENU}" <c:if test="${sessionScope.s_menu == menu.N_MENU_CODE}">class="selected"</c:if>>${menu.S_MENU_NAME}</a></li>
</c:forEach>

<%--
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<c:set var="tmp" value="["/>
<c:forEach items="${sessionScope.m_menu}" var="m" varStatus="vt1">
	<c:set var="tmp" value="${tmp}["/>
	<c:forEach items="${sessionScope.l_menu}" var="l" varStatus="vt2">		
		<c:if test="${m.N_MENU_CODE / l.N_MENU_CODE >= 1 and m.N_MENU_CODE / l.N_MENU_CODE < 2}">
			<c:set var="tmp" value="${tmp}\"${m.S_MENU_URL}\""/>
			<c:if test="${not vt2.last}"><c:set var="tmp" value="${tmp},"/></c:if>
		</c:if>		
	</c:forEach>
	<c:set var="tmp" value="${tmp}]"/>
	<c:if test="${not vt1.last}"><c:set var="tmp" value="${tmp},"/></c:if>
</c:forEach>
<c:set var="tmp" value="${tmp}]"/>

<script>
	var arrMenu = ${tmp};

	function fn_selectMenu(url)
	{
		parent.fn_select_menu(url);
	}
	
	function fn_submenu_change(str)
	{
		if(str=="user")
		{
			server_menu.style.display = "none";
			system_menu.style.display = "none";
			
			user_menu.style.display = "block";
			
			fn_select_menu("submenu_user", 0);
		}
		if(str=="server")
		{
			user_menu.style.display = "none";
			system_menu.style.display = "none";
						
			server_menu.style.display = "block";
			
			fn_select_menu("submenu_server", 0);
		}
		if(str=="system")
		{
			server_menu.style.display = "none";
			user_menu.style.display = "none";
									
			system_menu.style.display = "block";
			
			fn_select_menu("submenu_system", 0);
		}
	}
	
	function fn_select_menu(obj, num)
	{
		if(eval(obj).length > 1)
		{
			for(i=0;i<eval(obj).length;i++)
			{
				if(i == num)
				{
					eval(obj)[i].className = "pl10 line_gray white b blue_bg";
					if(obj == "submenu_user")
						fn_selectMenu(document.all.url_user[i].value);
					if(obj == "submenu_server")
						fn_selectMenu(document.all.url_server[i].value);
					if(obj == "submenu_system")
						fn_selectMenu(document.all.url_system[i].value);
				}
				else
				{
					eval(obj)[i].className = "pl10 line_gray";
				}
			}
		}
		else
		{
			eval(obj).className = "pl10 line_gray white b blue_bg";
			if(obj == "submenu_user")
				fn_selectMenu(document.all.url_user.value);
			if(obj == "submenu_server")
				fn_selectMenu(document.all.url_server.value);
			if(obj == "submenu_system")
				fn_selectMenu(document.all.url_system.value);
		}
	}
</script>

<%
	java.util.List<java.util.Map> l_menu_lst = (java.util.List)session.getAttribute("l_menu");

	if(l_menu_lst.size() > 0)
	{
		if(l_menu_lst.get(0).get("N_MENU_CODE").toString().equals("1000000"))
		{%>
			<script>
				function init()
				{
					fn_select_menu("submenu_user", 0);
				}
			</script>
		<%}
		if(l_menu_lst.get(0).get("N_MENU_CODE").toString().equals("2000000"))
		{%>
			<script>
				function init()
				{
					fn_select_menu("submenu_server", 0);
				}
			</script>
		<%}
		if(l_menu_lst.get(0).get("N_MENU_CODE").toString().equals("3000000"))
		{%>
			<script>
				function init()
				{
					fn_select_menu("submenu_system", 0);
				}
			</script>
		<%}
	}
	else
	{%>
	<script>
		function init()
		{
			
		}
	</script>
	<%}
%>



<body onload="init()">
	<div id="user_menu" style="display: position:absolute;">
	<!-- leftmenu start -->
		      <table width="200" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		          <td><img src="${img1}/title_menu01.jpg"></td>
		        </tr>
		       	<% int cnt = 0; %>
		        <c:forEach items="${sessionScope.m_menu}" var="m" varStatus="vt1">
						<c:if test="${m.N_MENU_CODE / 1000000 >= 1 and m.N_MENU_CODE / 1000000 < 2}">
							<tr>
						    	<td height="32" id="submenu_user" class="pl10 line_gray" style="cursor:hand;" onclick="javascript:fn_select_menu('submenu_user', <%=cnt++%>)">${m.S_MENU_NAME}</td>
						    	<input type="hidden" name="url_user" value="${m.S_MENU_URL}">
						    </tr>						    
						</c:if>
				</c:forEach>		        
		      </table>
		      <!-- leftmenu end -->
	</div>
	<div id="server_menu" style="display:none;position:absolute;">
	<!-- leftmenu start -->
		      <table width="200" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		          <td><img src="${img1}/title_menu02.jpg"></td>
		        </tr>
		        <% cnt = 0; %>
		        <c:forEach items="${sessionScope.m_menu}" var="m" varStatus="vt1">
						<c:if test="${m.N_MENU_CODE / 1000000 >= 2 and m.N_MENU_CODE / 1000000 < 3}">
							<tr>
						    	<td height="32" id="submenu_server" class="pl10 line_gray" style="cursor:hand;" onclick="javascript:fn_select_menu('submenu_server', <%=cnt++%>)">${m.S_MENU_NAME}</td>
						    	<input type="hidden" name="url_server" value="${m.S_MENU_URL}">
						    </tr>
						</c:if>				
				</c:forEach>	
		      </table>
		      <!-- leftmenu end -->
	</div>
	<div id="system_menu" style="display:none;position:absolute;">
	<!-- leftmenu start -->
		      <table width="200" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		          <td><img src="${img1}/title_menu03.jpg"></td>
		        </tr>
		        <% cnt = 0; %>
		        <c:forEach items="${sessionScope.m_menu}" var="m" varStatus="vt1">
						<c:if test="${m.N_MENU_CODE / 1000000 >= 3 and m.N_MENU_CODE / 1000000 < 4}">
							<tr>
						    	<td height="32" id="submenu_system" class="pl10 line_gray" style="cursor:hand;" onclick="javascript:fn_select_menu('submenu_system', <%=cnt++%>)">${m.S_MENU_NAME}</td>
						    	<input type="hidden" name="url_system" value="${m.S_MENU_URL}">
						    </tr>
						</c:if>
				</c:forEach>		       
		      </table>
		      <!-- leftmenu end -->
	</div>
</body>
</html>--%>

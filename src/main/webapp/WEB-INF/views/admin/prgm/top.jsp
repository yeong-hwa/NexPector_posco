<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>

<script>
	function fn_submenu_change(str)
	{
		parent.ifm_submenu.fn_submenu_change(str);
	}
	
	function fn_logout()
	{
		/* if(!confirm("로그아웃 하시겠습니까?"))
		{
			return;
		} */
		parent.frm.target = "";
		parent.frm.action="<c:url value="/admin/logout.htm"/>";
		parent.frm.submit();
	}
	
</script>

<body background="${img1}/top_bg.jpg" style="background-repeat:repeat-x" onLoad="MM_preloadImages('${img1}/menu01_on.jpg','${img1}/menu02_on.jpg','${img1}/menu03_on.jpg')">
<table width="995" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2" valign="top">
      <!-- top navigation start -->
		<table width="995" border="0" align="center" cellpadding="0" cellspacing="0">
	        <tr>
	          <td height="67" valign="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	              <tr>
	                <td height="53"><img src="${img1}/logo_neonex.png"></td>
	                <td align="right" class="white">
	                	<img src="${img1}/icon_login.png" align="absmiddle" />
	                	<span class="orange b">${sessionScope.S_USER_NAME}</span>&nbsp;님 로그인 하셨습니다
	                	<img src="${img1}/btn_logout.png" align="absmiddle" style="cursor:hand;" onclick="fn_logout()"/>
						&nbsp;&nbsp;<a href="#" onclick="top.goWatcherPage(); return false;"><sapn class="white">사용자 페이지</sapn></a>
	                </td>
	              </tr>
	            </table></td>
	        </tr>
		</table>
		</td>
	</tr>
	<tr>
          <td>
            <!-- 1차메뉴 start -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="center">
              	<c:forEach items="${sessionScope.l_menu}" var="m">
	              	<c:if test="${m.N_MENU_CODE == '1000000'}">
	                	<td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','${img1}/menu01_on.jpg',1)"><img src="${img1}/menu01.jpg" onclick="fn_submenu_change('user')" name="Image6"></a></td>
	                </c:if>
	                <td><img src="${img1}/menu_line.png"></td>
	                <c:if test="${m.N_MENU_CODE == '2000000'}">
	                	<td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','${img1}/menu02_on.jpg',1)"><img src="${img1}/menu02.jpg" onclick="fn_submenu_change('server')" name="Image7"></a></td>
	                </c:if>
	                <td><img src="${img1}/menu_line.png"></td>
	                <c:if test="${m.N_MENU_CODE == '3000000'}">
	                	<td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','${img1}/menu03_on.jpg',1)"><img src="${img1}/menu03.jpg" onclick="fn_submenu_change('system')" name="Image8"></a></td>
	                </c:if>
                </c:forEach>
              </tr>
            </table>
            <!-- 1차메뉴 end -->
            </td>
        </tr>
        <tr>
          <td height="8"></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
      </table>
      <!-- top navigation end -->
    </td>
  </tr>
</table>
</html>
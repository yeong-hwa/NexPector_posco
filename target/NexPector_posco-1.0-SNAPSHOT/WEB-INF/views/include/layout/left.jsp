<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" language="javascript">
$(document).ready(function(){
	
});

var currSubMenu;

function chgSubMenu(obj, url, nm){
	$('#subMenuUl li').removeAttr('class');
	$(obj).addClass('leftmenu');
	
	// subTitle 변경
	var str = "<div class='breadcrumb'>";
	str += "<a href='<c:url value='main.htm'/>'>Home</a> > <c:out value='${CURR_MENU_NM }' /> > <strong>"+nm+"</strong>";
	str += "</div>";
	str += "<h2>"+nm+"</h2>";
	
	$('#subTitleDiv').html(str);

	// contents 페이지 교체
	$('#rightDiv').load("<c:url value='/'/>"+url);
}
</script>
</head>
<body>
    <p class="left_title"><img src="<c:url value="/common/images/web/left_title_menu0${CURR_ORD }.gif"/>" /></p>
    <p><img src="<c:url value="/common/images/web/leftmenu_top.gif"/>" alt=""/></p>
    <div class="leftmenu_ce">
        <ul id="subMenuUl">
        <c:forEach var="subMenuList" items="${USER_SUBMENU }" step="1" varStatus="status">
        	<c:if test="${subMenuList.up_cd == CURR_MENU_ID }">
        		<c:choose>
        			<c:when test="${subMenuList.menu_ord == 1 }">
        				<li class="leftmenu" onclick="chgSubMenu(this, '${subMenuList.menu_path}','${subMenuList.menu_nm }')" style="cursor: pointer;"><c:out value="${subMenuList.menu_nm }" /></li>
        			</c:when>
        			<c:otherwise>
        				<li onclick="chgSubMenu(this, '${subMenuList.menu_path}','${subMenuList.menu_nm }')" style="cursor: pointer;"><c:out value="${subMenuList.menu_nm }" /></li>
        			</c:otherwise>
        		</c:choose>
        	</c:if>
        </c:forEach>
        </ul>
    </div>
    <p><img src="<c:url value="/common/images/web/leftmenu_bt.gif"/>" alt=""/></p>
    <div class="link"><img src="<c:url value="/common/images/web/link_homepage.gif"/>" alt="본원홈페이지링크"/></div>
</body>
</html>
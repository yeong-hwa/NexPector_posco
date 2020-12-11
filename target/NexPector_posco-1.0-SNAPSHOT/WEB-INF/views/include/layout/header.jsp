<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"   prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="t"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<div class="header fix">
    <h1 class="logo">
    	<a href="<c:url value="/accept/main.htm" />">
    		<img src="<c:url value="/common/images/web/logo.png"/>" alt="국립 김제 농업생명 청소년 수련원 체험활동 교육신청시스템" />
    	</a>
    </h1>
    <div>
        <ul class="gnb">
      	<c:forEach var="menuList" items="${USER_MENU }" step="1" varStatus="status">
       		<c:choose>
       			<c:when test="${menuList.menu_id == CURR_MENU_ID }">
	       			<li class="menu0${menuList.menu_ord }">
		      			<a href="<c:url value="${menuList.menu_path}"/>">
		      				<img id="menuImg${menuList.menu_ord }" name="menuImg${menuList.menu_ord }"
		      					src="<c:url value="/common/images/web/gnb_menu0${menuList.menu_ord }_on.gif"/>" alt="${menuList.menu_nm }" style="cursor: pointer;"
		      					onMouseOut="MM_swapImgRestore()"
		      					onMouseOver="MM_swapImage('menuImg${menuList.menu_ord }','','<c:url value="/common/images/web/gnb_menu0${menuList.menu_ord }_on.gif"/>',1)" />
		      			</a>
		      		</li>
       			</c:when>
       			<c:otherwise>
	       			<li class="menu0${menuList.menu_ord }">
		      			<a href="<c:url value="${menuList.menu_path}"/>">
		      				<img id="menuImg${menuList.menu_ord }" name="menuImg${menuList.menu_ord }"
		      					src="<c:url value="/common/images/web/gnb_menu0${menuList.menu_ord }_no.gif"/>" alt="${menuList.menu_nm }" style="cursor: pointer;"
		      					onMouseOut="MM_swapImgRestore()"
		      					onMouseOver="MM_swapImage('menuImg${menuList.menu_ord }','','<c:url value="/common/images/web/gnb_menu0${menuList.menu_ord }_on.gif"/>',1)" />
		      			</a>
		      		</li>
       			</c:otherwise>
       		</c:choose>
       	</c:forEach>
       	<c:if test="${fn:length(USER_MENU) < 5}">
       		<c:forEach var="vars" begin="${fn:length(USER_MENU) + 1}" end="5" step="1" varStatus="status">
       			<li class="menu0${vars }">&nbsp;</li>
       		</c:forEach>
       	</c:if>
            <li class="menu06">
	            <strong><span class="txt_blue">${USER_NAME}</span></strong>님 반갑습니다
	            <a href='<c:url value="/logout.htm" />'><img src="<c:url value="/common/images/web/btn_logout.gif"/>" alt="로그아웃"/></a>
            </li>
        </ul>
    </div>
</div>

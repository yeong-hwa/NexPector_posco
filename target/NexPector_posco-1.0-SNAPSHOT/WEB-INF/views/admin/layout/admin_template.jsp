<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
	<head>
	<title>NexPector Manager</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!-- Project CSS -->
		<link type="text/css" href="<c:url value="/admin/css/common.css" />" rel="stylesheet">
		<!-- jQuery CSS -->
		<link type="text/css" href="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.css" />" rel="stylesheet">
		<!-- Kendo UI CSS -->
		<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
		<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
		<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" rel="stylesheet"/>
		<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" rel="stylesheet"/>

		<style type="text/css">
			.k-pager-wrap .k-icon{margin-top: 4px;}
			.manaint_f{height: 19px;}
			.k-grid, .k-scheduler, .k-menu, .k-editor{border-radius: 0px;}
			/*th a{font-family: dotum, '돋움';}*/
			.k-grid-header tr th, .k-grid-header tr th a, .k-pager-wrap{font-family: 'NGB';}
			.k-pager-wrap{clear: none;}
		</style>

		<!-- jQuery Javascript -->
		<script type="text/javascript" src="<c:url value="/js/jquery-1.11.2.min.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"/>"></script>
		<!-- Kendo UI Javascript -->
		<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
		<!-- Project Javascript -->
		<script type="text/javascript" src="<c:url value="/js/common.js" />"></script>
		<script type="text/javascript" src="<c:url value="/common/js/common.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/function.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/global-variables.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery-migrate-1.1.1.min.js" />"></script>
		<script type="text/javascript" src="<c:url value="/common/js/jquery.maskedinput.min.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery-extend.js" />"></script>

		<script type="text/javascript">
			var console = window.console || {log:function(){}}; // IE8 이하 버전 console.log 에러 처리 - 개발버전
//			var console = {log:function(){}}; // 상용버전

			var c = createConstants('${ctx}');
			c.countPerPage(10); // Paging 한페이지 표시 개수
			c.pageSize(10); // Paging 하단 부분 몇개 나눌지 여부
		</script>
	</head>

<body>
	<!-- s:전체영역 -->
	<div id="Wrapper">

		<!-- s:상단영역 -->
		<div id="topArea">
			<div class="boxT">
				<div class="slogoB">
					<h1 class="slogo">
						<img src="<c:url value="/images/watcher/logo_s01.png" />" height="14px" alt="NEXPector"/>
					</h1>
					<%--<span style="float:right; position:relative; top:-11px; padding-right:25px; padding-left:15px; font-weight:bold; color:#fff; margin:0px;">
						<a href="<c:url value="/watcher/main/switch.htm"/>"> 사용자 페이지</a>
					</span>
					<span class="logoutA">
						<span style="color:#f2641a;font-weight: bold;">${sessionScope.S_USER_NAME}</span>&nbsp;님 로그인 하셨습니다
						<a href="<c:url value="/watcher/logout.htm"/>">
							<img src="<c:url value="/images/botton/logout.png"/>" alt="Logout" />
						</a>
						&lt;%&ndash;<a href="#"><img src="<c:url value="/images/botton/set.png"/>" alt="설정" /></a>&ndash;%&gt;
					</span>--%>
					<span class="logoutA">
						<span style="color:#f2641a;font-weight: bold;">${sessionScope.S_USER_NAME}</span>&nbsp;님 로그인 하셨습니다
						<a href="<c:url value="/watcher/logout.htm"/>"><img src="<c:url value="/images/botton/logout.png"/>" alt="Logout" /></a>
						<%--<a href="#"><img src="<c:url value="/images/botton/set.png"/>" alt="설정" /></a>--%>
						<a href="<c:url value="/watcher/main/switch.htm"/>" class="ico_adm">사용자 페이지</a>
					</span>
				</div>
				<!--네비게이션-->
				<div class="gnvBox">
					<span>
						<a href="/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01">
							<img src="<c:url value='/common/images/watcher/logo01.png'/>" alt="Nexpector Manager" />
						</a>
					</span>
					<ul>
						<c:forEach var="menu" items="${sessionScope.l_menu}" varStatus="stat">
							<% // 좌측 메뉴의 첫번째 URL 이 상단 메뉴의 URL 과 같으면 메뉴 이미지를 on, off 처리하기 위한 로직  %>
							<c:set var="firstUri" value="${sessionScope.m_menu ne null and not empty sessionScope.m_menu ? sessionScope.m_menu[0] : ''}"/>
							<c:choose>
								<c:when test="${fn:indexOf(firstUri, menu.S_MENU_URL) > -1}">
									<c:set var="imgSrc" value="/images/nv/mnv0${stat.count}_on.png"/>
								</c:when>
								<c:otherwise>
									<c:set var="imgSrc" value="/images/nv/mnv0${stat.count}_off.png"/>
								</c:otherwise>
							</c:choose>
							<li>
								<a href="<c:url value="${menu.S_MENU_URL}?menuCode=${menu.N_MENU_CODE}&upperMenuCode=${menu.N_MENU_CODE}"/>" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('mnavi01_0${stat.count}','','<c:url value="/images/nv/mnv0${stat.count}_on.png"/>',1)">
									<img src="<c:url value="${imgSrc}"/>" alt="${menu.S_MENU_NAME}" name="mnavi01_0${stat.count}" width="181" height="65" border="0" id="mnavi01_0${stat.count}" />
								</a>
							</li>
						</c:forEach>
						<%--<li><a href="01_1사용자관리_사용자정보관리.htm" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('mnavi01_01','','<c:url value="/images/nv/mnv01_on.png"/>',1)"><img src="<c:url value="/images/nv/mnv01_on.png"/>" alt="사용자 관리" name="mnavi01_01" width="181" height="65" border="0" id="mnavi01_01" /></a></li>
						<li><a href="02_1감시장비관리_감시장비관리.htm" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('mnavi01_02','','<c:url value="/images/nv/mnv02_on.png"/>',1)"><img src="<c:url value="/images/nv/mnv02_off.png"/>" alt="감시장비관리 상세조회" name="mnavi01_02" width="183" height="65" border="0" id="mnavi01_02" /></a></li>
						<li><a href="03_1시스템정보관리_메뉴정보관리.htm" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('mnavi01_03','','<c:url value="/images/nv/mnv03_on.png"/>',1)"><img src="<c:url value="/images/nv/mnv03_off.png"/>" alt="시스템정보관리" name="mnavi01_03" width="182" height="65" border="0" id="mnavi01_03" /></a></li>--%>
					</ul>
				</div>
				<!--//네비게이션-->
			</div>
		</div>
		<!-- e:상단영역 // -->

		<!-- s:콘텐츠영역 -->
		<div id="contentsArea">
			<div class="boxC">
				<!-- left nv -->
				<div class="leftNv_Area3">
					<!-- historyNv-->
					<ul class="history_leftNv">
						<!-- left 영역 -->
					  <tiles:insertAttribute name="left" />
					</ul>
					<!-- historyNv-- //-->
				</div>
				<!-- left nv // -->

				<!-- contents box -->
				<div class="contentsbox_Area">
					<div class="c_start">
						<!-- contents 영역 -->
					  <tiles:insertAttribute name="body" />
					</div>
				</div>
				<!-- contents box // -->
			</div>
		</div>
		<!-- e:콘텐츠영역 // -->

		<!-- s:하단영역 -->
		<div id="footerArea">
			<div class="boxF">COPYRIGHT(c) POSCO all rights reserved.</div>
		</div>
		<!-- e:하단영역 // -->

	</div>
	<!-- e:전체영역 // -->
</body>

</html>
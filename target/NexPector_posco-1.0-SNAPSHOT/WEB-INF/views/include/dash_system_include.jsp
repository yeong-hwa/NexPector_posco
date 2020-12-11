<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set var="img3"><c:url value='/common/dashboard/images'/></c:set>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<link href="/common/dashdaekyo/css/font.css" type="text/css" rel="stylesheet" />
<link href="/common/dashdaekyo/css/default.css" type="text/css" rel="stylesheet" />
<link href="/common/dashdaekyo/css/layout_new.css" type="text/css" rel="stylesheet" />
<link href="/common/dashdaekyo/css/jquery.mCustomScrollbar.css" type="text/css" rel="stylesheet" />

<link type="text/css" href="<c:url value="/common/dashboard/css/jquery-ui/jquery-ui.min.css" />" rel="stylesheet"/> <!-- 1.12.1 -->
<link type="text/css" href="<c:url value="/css/popup.css" />" rel="stylesheet"/>

<!-- Kendo UI CSS -->
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" rel="stylesheet"/>


<!-- Jquey JS-->
<script type="text/javascript" src="<c:url value="/js/jquery-1.11.2.min.js" />"></script>
<script type="text/javascript" src="/common/dashdaekyo/js/webwidget_scroller_tabphone.js"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"/>"></script>




<!-- <script src="<c:url value='/common/dashboard/js/jquery-1.6.min.js' />"></script> -->
<script src="<c:url value='/common/dashboard/js/jquery.mCustomScrollbar.concat.min.js' />"></script>

<!-- Kendo UI JS -->
<script src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>

<script type="text/javascript" src="<c:url value="/js/common.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/common.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/function.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/global-variables.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/jquery-migrate-1.1.1.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.maskedinput.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery-extend.js" />"></script>

	<!-- 스크립트 -->
	<script src="/common/dashdaekyo/js/slider.js"></script>


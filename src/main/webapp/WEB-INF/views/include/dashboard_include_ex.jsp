<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set var="img3"><c:url value='/common/dashboard/images'/></c:set>

<!--
<link href="<c:url value="/common_2/css/dashboard_default.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common_2/css/layout.css"/>" rel="stylesheet" />
<link href="<c:url value="/common_2/RGraph/css/default.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common_2/css/jquery.mCustomScrollbar.css"/>" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="<c:url value="/common_2/js/jquery-1.9.1.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common_2/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common_2/js/common.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common_2/js/control.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common_2/js/jquery.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common_2/js/jquery.mCustomScrollbar.concat.min.js"/>"></script>
-->
<link href="<c:url value="/common/dashboard/css/default.css"/>" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="<c:url value="/common/dashboard/tool-tip/tip-yellowsimple/tip-yellowsimple.css"/>" type="text/css" />
<script type="text/javascript" src="<c:url value="/common/dashboard/RGraph/libraries/RGraph.common.core.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/dashboard/RGraph/libraries/RGraph.common.effects.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/dashboard/RGraph/libraries/RGraph.hbar.js"/>"></script>
<!--[if lt IE 9]><script type="text/javascript" src="<c:url value="/common/dashboard/RGraph/excanvas/excanvas.js"/>"></script><![endif]-->
<!--jquery scroll-->
<script src="<c:url value="/common/dashboard/js/jquery.min.js"/>"></script>
<script>window.jQuery || document.write('<script src="/common/dashboard/js/jquery-1.11.0.min.js"><\/script>')</script>
<!-- custom scrollbar plugin -->
<script src="<c:url value="/common/dashboard/js/jquery.mCustomScrollbar.concat.min.js"/>"></script>
<script src="<c:url value="/common/dashboard/tool-tip/jquery.poshytip.js"/>"></script>

<!--
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.common.effects.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.line.js"/>"></script>
-->

<%
	String jimg1 = "/common/images/admin";
	String jimg2 = "/common/images/watcher";
	String jimg3 = "/common/images/dashboard";
%>
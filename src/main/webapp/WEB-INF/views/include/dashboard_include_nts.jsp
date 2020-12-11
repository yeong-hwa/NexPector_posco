<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set var="img3"><c:url value='/common/images/dashboard'/></c:set>

<link href="<c:url value="/common/css/dashboard_default.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/css/layout.css"/>" rel="stylesheet" />
<link href="<c:url value="/common/RGraph/css/default.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/css/jquery.mCustomScrollbar.css"/>" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="<c:url value="/common/js/jquery-1.9.1.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/common.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/control.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.mCustomScrollbar.concat.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.jquery-1.11.0.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.common.core.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.common.effects.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.common.dynamic.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.common.effects.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/RGraph/libraries/RGraph.line.js"/>"></script>

<%
	String jimg1 = "/common/images/admin";
	String jimg2 = "/common/images/watcher";
	String jimg3 = "/common/images/dashboard";
%>
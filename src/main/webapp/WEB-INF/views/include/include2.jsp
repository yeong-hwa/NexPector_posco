<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="img1"><c:url value='/common/images/admin'/></c:set>
<c:set var="img2"><c:url value='/common/images/watcher'/></c:set>

<link href="<c:url value="/common/css/default1.css"/>" rel="stylesheet">
<script type="text/javascript" src="<c:url value="/common/js/jquery-1.9.1.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/common.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/control.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.maskedinput.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery-extend.js"/>"></script>

<%
	String jimg1 = "/common/images/admin";
	String jimg2 = "/common/images/watcher";
%>